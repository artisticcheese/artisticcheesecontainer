# In the master database (target server)
# - Create the master user login
# - Create the master user from master user login
# - Create the job user login
$sqlserver = Get-AzSqlServer  -Name "<yourdbname>"
$Params = @{
      'Database'        = 'master'
      'ServerInstance'  = "$($sqlserver.servername).database.windows.net"
      'Username'        = "<SQLsa acccount>"
      'Password'        = "<SQL sa password>"
      'OutputSqlErrors' = $true
      'Query'           = "CREATE LOGIN masteruser WITH PASSWORD='<your password>'"
}
$Params.Query = "select @@version"
#Invoke-SqlCmd @Params 
$Params.Query = "CREATE USER masteruser FROM LOGIN masteruser"
#Invoke-SqlCmd @Params
$Params.Query = "CREATE LOGIN jobuser WITH PASSWORD='<jobuser password>'"
#Invoke-SqlCmd @Params

$allDBs = Get-AzSqlDatabase -ServerName $sqlServer.ServerName -ResourceGroupName $sqlserver.ResourceGroupName
# For each of the target databases
# - Create the jobuser from jobuser login
# - Make sure they have the right permissions for successful script execution
$TargetDatabases = $allDBs
$CreateJobUserScript = "CREATE USER jobuser FROM LOGIN jobuser"
$GrantAlterSchemaScript = "GRANT ALTER ON SCHEMA::dbo TO jobuser"
$GrantCreateScript = "GRANT CREATE TABLE TO jobuser"
$AddtoDBOwnerRole = "ALTER ROLE db_owner ADD MEMBER jobuser"
$i = 0
$TargetDatabases | ForEach-Object {
      $i++
      $Params.Database = $_.DatabaseName
      Write-Output "Creating users on $($_.DatabaseName), $i out of $($TargetDatabases.Count) "
      #$Params.Query = $CreateJobUserScript
      $Params.Query = $AddtoDBOwnerRole
      Invoke-SqlCmd @Params

      $Params.Query = $GrantAlterSchemaScript
      #Invoke-SqlCmd @Params

      $Params.Query = $GrantCreateScript
      #Invoke-SqlCmd @Params
}

# Create job credential in Job database for master user
$JobAgent = Get-AzSqlElasticJobAgent -ResourceGroupName "Default-SQL-NorthCentralUS" -Name "ElasticJobAgent" -ServerName tncdb-ncus
Write-Output "Creating job credentials..."
$LoginPasswordSecure = (ConvertTo-SecureString -String "<master user password>" -AsPlainText -Force)

$MasterCred = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList "masteruser", $LoginPasswordSecure
$MasterCred = $JobAgent | New-AzSqlElasticJobCredential -Name "masteruser" -Credential $MasterCred

$LoginPasswordSecure = (ConvertTo-SecureString -String '<job user password>' -AsPlainText -Force)

$JobCred = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList "jobuser", $LoginPasswordSecure
$JobCred = $JobAgent | New-AzSqlElasticJobCredential -Name "jobuser" -Credential $JobCred

$ServerGroup = $JobAgent | New-AzSqlElasticJobTargetGroup -Name 'Pool1'
$ServerGroup | Add-AzSqlElasticJobTarget -ElasticPoolName "Pool1"  -ServerName $JobAgent.ServerName -RefreshCredentialName $MasterCred.UserName
