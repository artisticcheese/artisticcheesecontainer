function Convert-Disk {
    [cmdletbinding()]
    param (
        [parameter(ValueFromPipeline=$True)]
        [psobject[]] $VMs
    )
    Begin {}
    Process {
    foreach ($VM in $VMs) {
        $returnObject = New-Object -TypeName psobject -Property @{
            name = $VM.name;
            OSDiskSize = $VM.osDisk.osdiskSize
            OSDiskTier = $VM.osDisk.osDiskTier
            Location = $VM.Location
            DataDisk = @()

        }
        foreach ($datadisk in $VM.datadisk) {
            $returnObject.DataDisk += ([PSCustomObject]@{
             DataDiskName = $datadisk.Name
             DataDiskSize = $datadisk.diskSizeGB
             DataDiskTier = $datadisk.managedDisk.storageAccountType
             
            })
        }
    }
    $returnObject
}
End{}

}
#$results = import-clixml ..\results.xml
#$results | Convert-Disk
