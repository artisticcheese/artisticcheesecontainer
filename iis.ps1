Configuration IIS
{
    Import-DscResource -ModuleName "PSDesiredStateConfiguration" 
    Import-DSCResource -moduleName "xWebAdministration"
    node localhost
    {
        xWebApplication PI
        {
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
