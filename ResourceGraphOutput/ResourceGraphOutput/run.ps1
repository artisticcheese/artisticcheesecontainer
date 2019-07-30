using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

#Import-module Az.ResourceGraph -MinimumVersion 0.7.2
$status = [HttpStatusCode]::OK
$subscriptions = Get-AzSubscription | Where-Object state -eq Enabled | Select-Object -ExpandProperty ID
$results = Search-AzGraph -Subscription $subscriptions -Query @"
where type =~ 'Microsoft.Compute/virtualmachines' 
| extend disk = properties.storageProfile.osDisk 
| extend osDisk = pack("osdiskSize", properties.storageProfile.osDisk.diskSizeGB, "osDiskTier",properties.storageProfile.osDisk.managedDisk.storageAccountType )
| extend datadisk = properties.storageProfile.dataDisks
|project name, osDisk, datadisk, location
"@
$body = $results | convert-disk

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = $status
        Body       = $body
    })

