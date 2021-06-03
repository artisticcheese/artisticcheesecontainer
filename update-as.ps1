#Requires -Version 7
#Script below would allow to add VM to availability set after VM was already deployed without it. 
#Process consists of exporting existing VM tempalte, modifying it's parameters and then importing it again
#Availability set shall already exist and be in the same resource group as VM resides
#Following paramters are are required: $vmName -> name of VM, $resourceGroupNam -> Name of resource group where VM and availability set is located, $availabilitySet -> name of availability set
#Once script is run Vm is removed and you are left with .\template.deploy.json file which you need to create a new deployment from with New-AzResourceGroupDeployment
#Example
#.\Update-AvailabilitySet.ps1 -vmName MyVm1 -resourceGroupName MyResourceGroup-RG -availabilitySet myAvailabilitySet
# New-AzResourceGroupDeployment -TemplateFile .\template.deploy.json -ResourceGroupName myResourceGroup-RG



[CmdletBinding()]
param (
   [Parameter(Mandatory = $true)] [string] $vmName,
   [Parameter(Mandatory = $true)] [string] $resourceGroupName,
   [Parameter(Mandatory = $true)] [string] $availabilitySet
)
$VerbosePreference = "Continue"
if ($null -eq (Get-AzContext)) { Login-AzAccount }
$ErrorActionPreference = "Stop"
$resource = Get-AzVM -ResourceGroupName $resourceGroupName -VMName $vmName 
$fileName = Join-Path (Get-Location) ".\template.json"
Export-AzResourceGroup -ResourceGroupName $resource.ResourceGroupName -Resource $resource.Id -IncludeParameterDefaultValue -IncludeComments -Path $fileName -Force
$templateTextFile = [System.IO.File]::ReadAllText($fileName)
$TemplateObject = ConvertFrom-Json $templateTextFile -AsHashtable
$computerObject = $TemplateObject.resources.where{ $_.type -eq "Microsoft.Compute/virtualMachines" }   
$computerObject[0].apiVersion = "2020-06-01"
if ($null -eq $computerObject.properties.availabilitySet) {
   $computerObject.properties.Add("availabilitySet", "")
}
$computerObject.properties.availabilitySet = @{ "id" = "[resourceId('Microsoft.Compute/availabilitySets', '$availabilitySet')]" }      
$computerObject.properties.storageProfile.dataDisks.ForEach{ $_.createOption = "Attach" }
$computerObject.properties.storageProfile.osDisk.createOption = "Attach"
$computerObject.properties.storageProfile.Remove("imageReference")
$computerObject.properties.storageProfile.osDisk.Remove("name")
$computerObject.properties.Remove("osProfile")
$TemplateObject | ConvertTo-Json -Depth 50 | Out-File -Path (Join-path (Get-Location) ".\template.deploy.json")
$resource | Stop-AzVM -Force
$resource | Remove-AzVM -Force
if ($env:POWERSHELL_DISTRIBUTION_CHANNEL -eq "CloudShell") {
   New-AzResourceGroupDeployment -TemplateFile (Join-path (Get-Location) ".\template.deploy.json") -ResourceGroupName $resourceGroupName
}
