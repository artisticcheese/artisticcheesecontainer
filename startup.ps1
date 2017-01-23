$VerbosePreference = "Continue"
$ErrorActionPreference =  "Continue"
$ContainerAdmin = $env:ContainerAdmin
$ContainerPassword = $env:ContainerPassword
if ((Get-LocalUser -Name $ContainerAdmin ).Count -eq 1) {
    Write-Verbose "Admin container user already exists, updating password to $ContainerPassword"
    Set-localuser -Name $ContainerAdmin -Password (ConvertTo-SecureString  $ContainerPassword -AsPlainText -Force) 
}
else {
    Write-Verbose "Admin container does not exist, creating user"
    new-LocalUser -Name $ContainerAdmin -Password  (ConvertTo-SecureString  $ContainerPassword -AsPlainText -Force) 
}
if (((Get-LocalGroupMember administrators) -notmatch  $ContainerAdmin)) {
    Write-Verbose "$containeradmin is not part of local Administrator's group, adding it"
    Add-LocalGroupMember -Group Administrators -Member $ContainerAdmin 
}


   
<# Configuration Startup
    {
        param
        (
                [pscredential] $cred
        )
        Import-DscResource -ModuleName  'PSDSCResources'
        node localhost{
                User LocalAdmin   {
                UserName =  $cred.UserName
                Description =  "Customized admin for container"
                Ensure = "Present"
                Password = $cred
        }
    }
    }
    $cd = @{
        AllNodes = @(
            @{
                NodeName = 'localhost'
                PSDscAllowPlainTextPassword = $true
            }
        )
    }
    $cred = [pscredential]::new($ContainerAdmin, (ConvertTo-SecureString  $ContainerPassword -AsPlainText -Force)) 
    Startup -cred $cred -ConfigurationData $cd 
    Start-DscConfiguration -Wait -Verbose -Path .\Startup -Force#>
