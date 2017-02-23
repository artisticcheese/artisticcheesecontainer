Configuration IIS {
    Import-DscResource -ModuleName "PSDesiredStateConfiguration" 
    Import-DSCResource -moduleName "xWebAdministration"
    
    node localhost {
        WindowsFeature Web-DAV-Publishing {
            Ensure = "Present"
            Name = "Web-DAV-Publishing"
            IncludeAllSubFeature = $true
        }
        WindowsFeature Web-Basic-Auth {
            Ensure = "Present"
            Name = "Web-Basic-Auth"
            IncludeAllSubFeature = $true
        }
        xWebApplication PI {
            Name = "PI"
            Website = "Default Web Site"
            WebAppPool = "DefaultAppPool"
            PhysicalPath = "c:\inetpub\wwwroot\content\"
            Ensure = "Present"
        }
    }
}
IIS -Outputpath .\BasicIIS
Start-DscConfiguration -Wait -Verbose -Path .\BasicIIS -Force