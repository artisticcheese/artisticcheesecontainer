$ContainerAdmin = "contadmin"
$ContainerPassword = "A123456!"

if ((Get-LocalUser -Name $ContainerAdmin) -eq $true) {
    Set-localuser -Name $ContainerAdmin -Password (ConvertTo-SecureString  $ContainerPassword -AsPlainText -Force) -ErrorAction Stop

}
else
{
    new-LocalUser -Name $ContainerAdmin -Password  (ConvertTo-SecureString  $ContainerPassword -AsPlainText -Force) -ErrorAction Stop
}
Add-LocalGroupMember -Group Administrators -Member $ContainerAdmin
<#
    param(
    [string] $containerAdmin = $env:ContainerAdmin,
    [string] $containerPassword =$env:ContainerPassword
    )
    Configuration Startup
    {
        param
        (
                [pscredential] $cred
        )
        Import-DscResource -ModuleName 'PSDesiredStateConfiguration' 
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
    Start-DscConfiguration -Wait -Verbose -Path .\Startup -Force
#>