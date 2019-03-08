#escape = ` 
FROM mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2019
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'Continue'; $verbosePreference='Continue';"]
WORKDIR c:\inetpub\wwwroot
RUN install-WindowsFeature 'Web-ASP', 'Web-Http-Errors', 'Web-Asp-Net45', 'Web-Http-Errors'
RUN Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST'  -filter "system.webServer/asp" -name "scriptErrorSentToBrowser" -value "True"; `
Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST'  -filter "system.applicationHost/applicationPools/add[@name='DefaultAppPool']/failure" -name "rapidFailProtectionMaxCrashes" -value 2; `
Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST'  -filter "system.applicationHost/applicationPools/add[@name='DefaultAppPool']/failure" -name "rapidFailProtectionInterval" -value "00:01:00"
ENV COMPLUS_NGenProtectedProcess_FeatureEnabled 0
RUN Start-Process "c:\Windows\Microsoft.NET\Framework64\v4.0.30319\ngen.exe" -ArgumentList "update" -Wait; `
    Start-Process "c:\Windows\Microsoft.NET\Framework\v4.0.30319\ngen.exe" -ArgumentList "update" -Wait
ADD website .
RUN icacls .\content /grant IUSR:F /T
HEALTHCHECK --interval=3s --timeout=30s --start-period=6s --retries=3 CMD powershell -command `  
    try { `
     $response = iwr http://localhost/default.aspx -usebasicParsing; `
     if ($response.StatusCode -eq 200) { return 0} `
     else {return 1}; `
    } catch { return 1 }

