Configuration BasicIIS
{
   Import-DscResource -ModuleName 'PSDesiredStateConfiguration' 
   node localhost {
         WindowsFeature IIS
        {
            Ensure = "Present"
            Name = "Web-Mgmt-Service"
        }
        WindowsFeature HTTPWCF
        {
            Ensure = "Present"
            Name = "net-wcf-http-Activation45"
        } 
         WindowsFeature Web-Http-Tracing
        {
            Ensure = "Present"
            Name = "Web-Http-Tracing"
        } 
         WindowsFeature Web-Request-Monitor
        {
            Ensure = "Present"
            Name = "Web-Request-Monitor"
        } 
        Service WebManagementService
        {    
            Name = "WMSVC"
            StartupType = "Automatic"
            State = "Running"
            DependsOn = "[WindowsFeature]IIS"
        }
        Registry RemoteManagement
        {
            Key = "HKLM:\SOFTWARE\Microsoft\WebManagement\Server"
            ValueName =  "EnableRemoteManagement"
            ValueData = 1
            ValueType = "Dword"
            DependsOn = "[WindowsFeature]IIS"
        }
        Script NugetPackageProvider   
        {
            SetScript = {Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force}
            TestScript =  {if ((Get-PackageProvider -listavailable -name nuget -erroraction SilentlyContinue).Count -eq 0) {return $false} else {return $true}}
            GetScript = {@{Result = "true"}}       
        }
        Script ChocolateyPackageProvider   
        {
            SetScript = {Register-PackageSource -Name chocolatey -ProviderName Chocolatey -Location http://chocolatey.org/api/v2/ -force}
            TestScript =  {if ((Get-PackageProvider -listavailable -name Chocolatey -erroraction SilentlyContinue).Count -eq 0) {return $false} else {return $true}}
            GetScript = {@{Result = "true"}}       
        }
        Script xWebAdministration
        { 
            SetScript = {Install-Module xWebAdministration}
            TestScript =  {if ((get-module xwebadminstration -ListAvailable).Count -eq 0){return $false}else {return $true}}
            GetScript = {@{Result = "true"}}
            DependsOn = "[Script]NugetPackageProvider"
        }
        WindowsFeature WindowsDefenderFeatures
        {
            Ensure = "Absent"
            Name = "Windows-Defender-Features"
            IncludeAllSubFeature = $true
        }
        File IISLogFolder
        {
            Type = 'Directory'
            DestinationPath = 'c:\logs'
            Ensure = 'Present'
        }

    }
}

BasicIIS -OutputPath .\BasicIIS
Start-DscConfiguration -Wait -Verbose -Path .\BasicIIS -Force





