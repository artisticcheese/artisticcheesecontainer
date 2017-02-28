
Configuration IIS {
    # SSL Thumbprint to bind
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $sslThumbprint
    )
    Import-DscResource -ModuleName "PSDesiredStateConfiguration"
    Import-DSCResource -moduleName "xWebAdministration", "cNtfsAccessControl"
    node localhost {
        WindowsFeature Web-DAV-Publishing {
            Ensure = "Present"
            Name = "Web-DAV-Publishing"
            IncludeAllSubFeature = $true
            
        }
        WindowsFeature  Web-Net-Ext45 {
            Ensure = "Present"
            Name = "Web-Net-Ext45"
            IncludeAllSubFeature = $true   
        }
       
        Service WebManagementService {    
            Name = "WMSVC"
            StartupType = "Automatic"
            State = "Running"
            DependsOn = "[Registry]EnableIISManagerAuthentication"
            
        }
        Registry EnableIISManagerAuthentication {
            Key = "HKLM:\SOFTWARE\Microsoft\WebManagement\Server"
            ValueName =  "RequiresWindowsCredentials"
            ValueData = 0
            ValueType = "Dword"
            
        }
        cNtfsPermissionEntry 'FilePermissionDirectory' {
            Ensure = 'Present'
            Principal = 'builtin\IIS_IUSRS'
            Path = 'C:\Windows\System32\inetsrv\config'
            ItemType = 'Directory'
            AccessControlInformation = @(
                cNtfsAccessControlInformation {
                    AccessControlType = 'Allow'
                    FileSystemRights = 'Read'
                    Inheritance = 'ThisFolderOnly'
                    #NoPropagateInherit = $true
                }
            )
        }
        cNtfsPermissionEntry 'FilePermissionGetClean' {
            Ensure = 'Present'
            Principal = 'builtin\IIS_IUSRS'
            Path = 'C:\inetpub\wwwroot\getclean\'
            ItemType = 'Directory'
            AccessControlInformation = @(
                cNtfsAccessControlInformation {
                    AccessControlType = 'Allow'
                    FileSystemRights = 'Modify'
                }
            )
        }
        cNtfsPermissionEntry 'FilePermissionFiles' {
            Ensure = 'Present'
            Principal = 'builtin\IIS_IUSRS'
            Path = 'C:\Windows\System32\inetsrv\config\administration.config'
            ItemType = 'File'
            AccessControlInformation = @(
                cNtfsAccessControlInformation {
                    AccessControlType = 'Allow'
                    FileSystemRights = 'Read'
                    Inheritance = 'None'
                    #NoPropagateInherit = $true
                }
            )
        }
        cNtfsPermissionEntry 'FilePermissionFiles1' {
            Ensure = 'Present'
            Principal = 'builtin\IIS_IUSRS'
            Path = 'C:\Windows\System32\inetsrv\config\redirection.config'
            ItemType = 'File'
            AccessControlInformation = @(
                cNtfsAccessControlInformation {
                    AccessControlType = 'Allow'
                    FileSystemRights = 'Read'
                    Inheritance = 'None'
                    #NoPropagateInherit = $true
                }
            )
        }
        xWebsite RemoveDefaultWebsite {
            Name ="Default Web Site"
            Ensure = 'Absent'
        }
        File GetCleanFolder {
            Type= 'Directory'
            DestinationPath = "C:\inetpub\wwwroot\getclean"
            Ensure = 'Present'
        }
 
        xWebSite GetClean {
            Name="GetClean"
            State ='Started'
            Ensure = "Present"
            PhysicalPath = "C:\inetpub\wwwroot\GetClean"
            BindingInfo = @(
                MSFT_xWebBindingInformation {
                    Protocol              = 'HTTP' 
                    Port                  = '80'
                    IPAddress             = '*'

                };
                MSFT_xWebBindingInformation {
                    Protocol              = 'HTTPS' 
                    Port                  = '443' 
                    CertificateThumbprint = $sslThumbprint
                    CertificateStoreName  = 'My'
                    IPAddress             = '*'
                })  

        }
      
        <#xWebApplication PI {
            Name = "PI"
            Website = "Default Web Site"
            WebAppPool = "DefaultAppPool"
            PhysicalPath = "c:\inetpub\wwwroot\content\"
            Ensure = "Present"
        }#>
    }
}

$iisusers = @{"aa" = "sadsad"}
IIS -sslThumbprint (Get-ChildItem Cert:\LocalMachine\My\)[0].Thumbprint -Outputpath (Join-Path $PSScriptRoot "BasicIIS") 
Start-DscConfiguration -Wait -Verbose -Path (Join-Path $PSScriptRoot "BasicIIS") -Force 
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.Web.Management") | Out-Null
foreach ($user in $IISusers.Keys){
    [Microsoft.Web.Management.Server.ManagementAuthentication]::CreateUser($user, $IISusers[$user]) 
}
Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -location 'GetClean' -filter "system.webServer/webdav/authoring" -name "enabled" -value "True"
Add-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST'  -filter "system.webServer/modules" -name "." -value @{name='IISManagerAuthentication';type='Microsoft.Web.Management.Server.WebManagementBasicAuthenticationModule, Microsoft.Web.Management, Version=7.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'}
Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST'  -filter "system.webServer/modules" -name "runManagedModulesForWebDavRequests" -value "True"
foreach ($user in $IISusers.Keys){
    Add-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -location 'GetClean' -filter "system.webServer/webdav/authoringRules" -name "." -value @{users="$user";path='*';access='Read,Write'}
}

