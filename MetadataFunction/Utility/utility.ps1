

Function Build-Signature ($customerId, $sharedKey, $date, $contentLength, $method, $contentType, $resource) {
    $xHeaders = "x-ms-date:" + $date
    $stringToHash = $method + "`n" + $contentLength + "`n" + $contentType + "`n" + $xHeaders + "`n" + $resource

    $bytesToHash = [Text.Encoding]::UTF8.GetBytes($stringToHash)
    $keyBytes = [Convert]::FromBase64String($sharedKey)

    $sha256 = New-Object System.Security.Cryptography.HMACSHA256
    $sha256.Key = $keyBytes
    $calculatedHash = $sha256.ComputeHash($bytesToHash)
    $encodedHash = [Convert]::ToBase64String($calculatedHash)
    $authorization = 'SharedKey {0}:{1}' -f $customerId, $encodedHash
    return $authorization
}

Function Post-LogAnalyticsData($customerId, $sharedKey, $body, $logType) {
    $method = "POST"
    $contentType = "application/json"
    $resource = "/api/logs"
    $rfc1123date = [DateTime]::UtcNow.ToString("r")
    $contentLength = $body.Length
    $signature = Build-Signature `
        -customerId $customerId `
        -sharedKey $sharedKey `
        -date $rfc1123date `
        -contentLength $contentLength `
        -method $method `
        -contentType $contentType `
        -resource $resource
    $uri = "https://" + $customerId + ".ods.opinsights.azure.com" + $resource + "?api-version=2016-04-01"

    $headers = @{
        "Authorization"        = $signature;
        "Log-Type"             = $logType;
        "x-ms-date"            = $rfc1123date;
        "time-generated-field" = "";
    }

    $response = Invoke-WebRequest -Uri $uri -Method $method -ContentType $contentType -Headers $headers -Body $body -UseBasicParsing
    return $response.StatusCode

}
function Invoke-AzureCommand {
    [cmdletbinding()]
    param (
        [string] $vmName,
        [string] $resourceGroup,
        [string] $PowerState
    )
    Write-Host "Inside Utility executing via $vmName, $resourceGroup, $powerState"
    if ($powerState -ne "VM Running") { 
        Throw "$vmName is $powerState" 
    }
    $vm = Get-AzVM -Name $vmName -ResourceGroupName $resourceGroup

    If ($vm.StorageProfile.OsDisk.OsType -eq "Linux") {
        $out = Invoke-AzVMRunCommand -VM $vm -CommandId RunshellScript -ScriptPath ./Utility/run.sh 
    }
    elseif ($vm.StorageProfile.OsDisk.OsType -eq "Windows") {
        $out = Invoke-AzVMRunCommand -VM $vm -CommandId RunPowershellScript -ScriptPath ./Utility/run.ps1 
    } 
 
 
 
    $json = $null
    if (($out.value.message | out-string) -match "(?<output>{.*})") {
        $json = $Matches.output
    }
    else {
        $json = $out.Value.message
    }
    return $json
}

Function Add-QueueMessage {
    Write-Host "getting Storage Account info"
    $saContext = New-AzStorageContext -ConnectionString $env:AzureWebJobsStorage
    Write-Host "getting Queue Account info"
    $queue = Get-AzStorageQueue -Name $env:QueueName -Context $saContext.Context
    Write-Host "getting all VM Account info"
    $vms = get-azvm -Status #| Where-Object PowerState -eq "VM running"
    $i = 0
    Write-Host "Generating queue messages"
    foreach ($vm in $vms) {
        $i++
        $message = @"
{
"VMName" : "$($vm.Name)",
"ResourceGroup": "$($vm.ResourceGroupName)",
"State" : "$($vm.PowerState)"
}
"@
        $queueMessage = New-Object -TypeName "Microsoft.Azure.Storage.Queue.CloudQueueMessage, $($queue.CloudQueue.GetType().Assembly.FullName)" -ArgumentList $message
        $queue.CloudQueue.AddMessageAsync($QueueMessage) | Out-Null
        Write-Output "Added $i count $message to queue"
        
    }
    Write-Host "Loop finished"
    return $i
}