# Input bindings are passed in via param block.
param([string] $QueueItem, $TriggerMetadata)
# Write out the queue message and insertion time to the information log.
Write-Host "PowerShell queue trigger function processed work item: $($TriggerMetadata["VMName"])"
Write-Host "Queue item insertion time: $($TriggerMetadata.InsertionTime)"
Write-Host "Starting executing Invoke-AzureRMCommand with parameters $($TriggerMetadata["VMName"]), $($TriggerMetadata["ResourceGroup"]), $($TriggerMetadata["State"]))"
$returnederror = $null
try {
    $return = Invoke-AzureCommand -vmName $TriggerMetadata["VMName"] -resourceGroup $TriggerMetadata["ResourceGroup"] -PowerState $TriggerMetadata["State"] -ErrorAction Stop  
}
catch {
    #$_ -match "ErrorMessage: (?<output>(.*))" | out-null
    #$returnederror = $Matches.Output.Trim()
    $returnederror = $_
    Write-Host "Error retruned from call $_"   
}

Write-Host "Finished executing Invoke-AzureRMCommand with parameters $($TriggerMetadata["VMName"]), $($TriggerMetadata["ResourceGroup"]), $($TriggerMetadata["State"]), return is $return )"

If ($null -ne $returnederror) {
    Write-Error "Returned Error $returnedError"
    $vmName = $TriggerMetadata["VMName"]
    #Have to add additional number to name since Log Analytics by default cast GUID looking numbers into GUID columns which we don't want
    If ( [bool]($vmName -as [guid])) {
        $vmName = "$($vmName)1"
    }

    $json = @"
[
    {
        "VMName" : "$vmName",
        "ResourceGroup" : "$($TriggerMetadata["ResourceGroup"])",
        "Error": "$returnederror"
    }
]
"@
    
}
else {
    
    $json = @"
[
    {
        "Return" : $($return | convertto-json),
        "VMName" : "$($TriggerMetadata["VMName"])",
        "ResourceGroup" : "$($TriggerMetadata["ResourceGroup"])"

    }
]
"@

}
Write-Host "Outputing following to Log Analytics $json"
Post-LogAnalyticsData -customerId $env:LogAnalyticsWorkspaceID -SharedKey $env:LogAnalyticsSharedKey -body ([System.Text.Encoding]::UTF8.GetBytes($json)) -logType "MetaDataLog" -Verbose