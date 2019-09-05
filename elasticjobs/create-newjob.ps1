Write-Output "Creating a new job"
$JobName = "Reindex Job Pool vCore-Pool-1"
$targetGroupName = "vCore-Pool-1"
$credentialName = 'jobuser'
$JobAgent = Get-AzSqlElasticJobAgent -ResourceGroupName "Default-SQL-NorthCentralUS" -Name "ElasticJobAgent" -ServerName "<yourserver>"
if ($null -eq (Get-AzSqlElasticJob -ResourceGroupName $JobAgent.ResourceGroupName -ServerName $JobAgent.ServerName -AgentName $JobAgent.AgentName -Name $JobName -ErrorAction Ignore))
{
$Job = $JobAgent | New-AzSqlElasticJob -Name $JobName -ErrorAction Ignore -IntervalType Week -IntervalCount 1 -StartTime (Get-date "8/25/2019 05:00:00") -Enable
}
$Job = Get-AzSqlElasticJob -ResourceGroupName "Default-SQL-NorthCentralUS" -AgentName $JobAgent.AgentName -ServerName $JobAgent.ServerName -JobName $JobName

Write-Output "Creating job steps"
$SQLText1 = @"
SELECT 
DB_NAME() AS [Current Database],
SYSDATETIME()  as [QueryDate],
dbschemas.[name] as 'Schema',
dbtables.[name] as 'Table',
dbindexes.[name] as 'Index',
indexstats.avg_fragmentation_in_percent,
indexstats.page_count
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, NULL) AS indexstats
INNER JOIN sys.tables dbtables on dbtables.[object_id] = indexstats.[object_id]
INNER JOIN sys.schemas dbschemas on dbtables.[schema_id] = dbschemas.[schema_id]
INNER JOIN sys.indexes AS dbindexes ON dbindexes.[object_id] = indexstats.[object_id]
AND indexstats.index_id = dbindexes.index_id
WHERE indexstats.database_id = DB_ID()
ORDER BY page_count desc
"@


$SQLReindex = @"
-- http://www.sqlmusings.com
-- Ensure a USE <databasename> statement has been executed first.
SET NOCOUNT ON

-- adapted from "Rebuild or reorganize indexes (with configuration)" from MSDN Books Online 
-- (http://msdn.microsoft.com/en-us/library/ms188917.aspx)
 
-- =======================================================
-- || Configuration variables:
-- || - 10 is an arbitrary decision point at which to
-- || reorganize indexes.
-- || - 30 is an arbitrary decision point at which to
-- || switch from reorganizing, to rebuilding.
-- || - 0 is the default fill factor. Set this to a
-- || a value from 1 to 99, if needed.
-- =======================================================
DECLARE @reorg_frag_thresh   float		SET @reorg_frag_thresh   = 10.0
DECLARE @rebuild_frag_thresh float		SET @rebuild_frag_thresh = 30.0
DECLARE @fill_factor         tinyint	SET @fill_factor         = 80
DECLARE @report_only         bit			SET @report_only         = 0

-- added (DS) : page_count_thresh is used to check how many pages the current table uses
DECLARE @page_count_thresh	 smallint	SET @page_count_thresh   = 100
 
-- Variables required for processing.
DECLARE @objectid       int
DECLARE @indexid        int
DECLARE @partitioncount bigint
DECLARE @schemaname     nvarchar(130) 
DECLARE @objectname     nvarchar(130) 
DECLARE @indexname      nvarchar(130) 
DECLARE @partitionnum   bigint
DECLARE @partitions     bigint
DECLARE @frag           float
DECLARE @page_count     int
DECLARE @command        nvarchar(4000)
DECLARE @intentions     nvarchar(4000)
DECLARE @table_var      TABLE(
                          objectid     int,
                          indexid      int,
                          partitionnum int,
                          frag         float,
								  page_count   int
                        )
 
-- Conditionally select tables and indexes from the
-- sys.dm_db_index_physical_stats function and
-- convert object and index IDs to names.
INSERT INTO
    @table_var
SELECT
    [object_id]                    AS objectid,
    [index_id]                     AS indexid,
    [partition_number]             AS partitionnum,
    [avg_fragmentation_in_percent] AS frag,
	[page_count]				   AS page_count
FROM
    sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL , NULL, 'LIMITED')
WHERE
    [avg_fragmentation_in_percent] > @reorg_frag_thresh 
	AND
	page_count > @page_count_thresh
	AND
    index_id > 0
	
 
-- Declare the cursor for the list of partitions to be processed.
DECLARE partitions CURSOR FOR
    SELECT * FROM @table_var
 
-- Open the cursor.
OPEN partitions
 
-- Loop through the partitions.
WHILE (1=1) BEGIN
    FETCH NEXT
        FROM partitions
        INTO @objectid, @indexid, @partitionnum, @frag, @page_count
 
    IF @@FETCH_STATUS < 0 BREAK
 
    SELECT
        @objectname = QUOTENAME(o.[name]),
        @schemaname = QUOTENAME(s.[name])
    FROM
        sys.objects AS o WITH (NOLOCK)
        JOIN sys.schemas as s WITH (NOLOCK)
        ON s.[schema_id] = o.[schema_id]
    WHERE
        o.[object_id] = @objectid
 
    SELECT
        @indexname = QUOTENAME([name])
    FROM
        sys.indexes WITH (NOLOCK)
    WHERE
        [object_id] = @objectid AND
        [index_id] = @indexid
 
    SELECT
        @partitioncount = count (*)
    FROM
        sys.partitions WITH (NOLOCK)
    WHERE
        [object_id] = @objectid AND
        [index_id] = @indexid
 
    -- Build the required statement dynamically based on options and index stats.
    SET @intentions =
        @schemaname + N'.' +
        @objectname + N'.' +
        @indexname + N':' + CHAR(13) + CHAR(10)
    SET @intentions =
        REPLACE(SPACE(LEN(@intentions)), ' ', '=') + CHAR(13) + CHAR(10) +
        @intentions
    SET @intentions = @intentions +
        N' FRAGMENTATION: ' + CAST(@frag AS nvarchar) + N'%' + CHAR(13) + CHAR(10) +
        N' PAGE COUNT: '    + CAST(@page_count AS nvarchar) + CHAR(13) + CHAR(10)
 
    IF @frag < @rebuild_frag_thresh BEGIN
        SET @intentions = @intentions +
            N' OPERATION: REORGANIZE' + CHAR(13) + CHAR(10)
        SET @command =
            N'ALTER INDEX ' + @indexname +
            N' ON ' + @schemaname + N'.' + @objectname +
            N' REORGANIZE; ' + 
            N' UPDATE STATISTICS ' + @schemaname + N'.' + @objectname + 
            N' ' + @indexname + ';'

    END
    IF @frag >= @rebuild_frag_thresh BEGIN
        SET @intentions = @intentions +
            N' OPERATION: REBUILD' + CHAR(13) + CHAR(10)
        SET @command =
            N'ALTER INDEX ' + @indexname +
            N' ON ' + @schemaname + N'.' +     @objectname +
            N' REBUILD'
    END
    IF @partitioncount > 1 BEGIN
        SET @intentions = @intentions +
            N' PARTITION: ' + CAST(@partitionnum AS nvarchar(10)) + CHAR(13) + CHAR(10)
        SET @command = @command +
            N' PARTITION=' + CAST(@partitionnum AS nvarchar(10))
    END
    IF @frag >= @rebuild_frag_thresh AND @fill_factor > 0 AND @fill_factor < 100 BEGIN
        SET @intentions = @intentions +
            N' FILL FACTOR: ' + CAST(@fill_factor AS nvarchar) + CHAR(13) + CHAR(10)
        SET @command = @command +
            N' WITH (FILLFACTOR = ' + CAST(@fill_factor AS nvarchar) + ')'
    END
 
    -- Execute determined operation, or report intentions
    IF @report_only = 0 BEGIN
        SET @intentions = @intentions + N' EXECUTING: ' + @command
        PRINT @intentions	    
        EXEC (@command)
    END ELSE BEGIN
        PRINT @intentions
    END
	PRINT @command

END
 
-- Close and deallocate the cursor.
CLOSE partitions
DEALLOCATE partitions
 
GO
"@

If ($null -eq (Get-AzSqlElasticJobStep -ResourceGroupName $jobAgent.ResourceGroupName -ServerName $JobAgent.ServerName -AgentName $JobAgent.AgentName -JobName $Job.JobName -StepName "step1" -ErrorAction Ignore))
{
    $Job | Add-AzSqlElasticJobStep -Name "step1" -TargetGroupName $targetGroupName -CredentialName $credentialName -CommandText $SQLText1
}

$outputDatabase=Get-AzSqlDatabase -DatabaseName $JobAgent.DatabaseName -ResourceGroupName $JobAgent.ResourceGroupName -ServerName $JobAgent.ServerName
$jobStep = Get-AzSqlElasticJobStep -ResourceGroupName $JobAgent.ResourceGroupName -ServerName $JobAgent.ServerName -AgentName $JobAgent.AgentName -JobName $job.JobName  -StepName "step1"
$jobStep | Set-AzSqlElasticJobStep -CommandText $SQLText1 -OutputDatabaseObject $outputDatabase `
-OutputCredentialName $jobStep.CredentialName -OutputTableName "Fragmentation" -OutputSchemaName "dbo" -RetryAttempts 1 

If ($null -eq (Get-AzSqlElasticJobStep -ResourceGroupName $jobAgent.ResourceGroupName -ServerName $JobAgent.ServerName -AgentName $JobAgent.AgentName -JobName $Job.JobName -StepName "step2" -ErrorAction Ignore))
{
    $Job | Add-AzSqlElasticJobStep -Name "step2" -TargetGroupName $targetGroupName -CredentialName $credentialName -CommandText $SqlReindex
}
$jobStep = Get-AzSqlElasticJobStep -ResourceGroupName $JobAgent.ResourceGroupName -ServerName $JobAgent.ServerName -AgentName $JobAgent.AgentName -JobName $job.JobName  -StepName "step2"
$jobStep | Set-AzSqlElasticJobStep -CommandText $SQLReindex -OutputDatabaseObject $outputDatabase `
-OutputCredentialName $jobStep.CredentialName -OutputTableName "Reindex" -OutputSchemaName "dbo" -RetryAttempts 1 


If ($null -eq (Get-AzSqlElasticJobStep -ResourceGroupName $jobAgent.ResourceGroupName -ServerName $JobAgent.ServerName -AgentName $JobAgent.AgentName -JobName $Job.JobName -StepName "step3" -ErrorAction Ignore))
{
    $Job | Add-AzSqlElasticJobStep -Name "step3" -TargetGroupName $targetGroupName -CredentialName $credentialName -CommandText $SQLText1
}

$outputDatabase=Get-AzSqlDatabase -DatabaseName $JobAgent.DatabaseName -ResourceGroupName $JobAgent.ResourceGroupName -ServerName $JobAgent.ServerName
$jobStep = Get-AzSqlElasticJobStep -ResourceGroupName $JobAgent.ResourceGroupName -ServerName $JobAgent.ServerName -AgentName $JobAgent.AgentName -JobName $job.JobName  -StepName "step3"
$jobStep | Set-AzSqlElasticJobStep -CommandText $SQLText1 -OutputDatabaseObject $outputDatabase `
-OutputCredentialName $jobStep.CredentialName -OutputTableName "Fragmentation" -OutputSchemaName "dbo" -RetryAttempts 1 

<# $Job | Add-AzSqlElasticJobStep -Name "step1" -TargetGroupName "Pool2" -CredentialName "jobuser" -CommandText $SqlText1
$Job | Add-AzSqlElasticJobStep -Name "step1" -TargetGroupName "Pool3" -CredentialName "jobuser" -CommandText $SqlText1
$Job | Add-AzSqlElasticJobStep -Name "step1" -TargetGroupName "Pool4" -CredentialName "jobuser" -CommandText $SqlText1
$Job | Add-AzSqlElasticJobStep -Name "step1" -TargetGroupName "Pool5" -CredentialName "jobuser" -CommandText $SqlText1
$Job | Add-AzSqlElasticJobStep -Name "step1" -TargetGroupName "vCore-Pool-1" -CredentialName "jobuser" -CommandText $SqlText1
 #>