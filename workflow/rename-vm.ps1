[CmdletBinding()]
param (
      [Parameter(Mandatory = $true)] [string] $vmName,
      [Parameter(Mandatory = $true)] [string] $resourceGroupName,
      [Parameter(Mandatory = $true)] [string] $newVMName
)
$ErrorActionPreference = "Stop"
$resource = Get-AzVM -ResourceGroupName $resourceGroupName -VMName $vmName 
Export-AzResourceGroup -ResourceGroupName $resource.ResourceGroupName -Resource $resource.Id -IncludeParameterDefaultValue -IncludeComments -Path .\template.json -Force
$resource | Stop-AzVM -Force
$resource | Remove-AzVM -Force
$templateTextFile = [System.IO.File]::ReadAllText(".\template.json")
$TemplateObject = ConvertFrom-Json $templateTextFile -AsHashtable
$TemplateObject.resources.properties.storageProfile.osDisk.createOption = "Attach"
$TemplateObject.resources.properties.storageProfile.Remove("imageReference")
$TemplateObject.resources.properties.storageProfile.osDisk.Remove("name")
$TemplateObject.resources.properties.Remove("osProfile")
$TemplateObject | ConvertTo-Json -Depth 50 | Out-File (".\template.json")
