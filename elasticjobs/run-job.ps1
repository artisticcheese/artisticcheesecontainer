Write-Output "Start a new execution of the job..."
$JobAgent = Get-AzSqlElasticJobAgent -ResourceGroupName "Default-SQL-NorthCentralUS" -Name "ElasticJobAgent" -ServerName "<yourserver>"
$Job = Get-AzSqlElasticJob -AgentName $JobAgent.AgentName -ResourceGroupName $JobAgent.ResourceGroupName -ServerName $JobAgent.ServerName -JobName "Reindex Job Pool 5"
$JobExecution = $Job | Start-AzSqlElasticJob
$JobExecution | Get-AzSqlElasticJobTargetExecution -Count 100