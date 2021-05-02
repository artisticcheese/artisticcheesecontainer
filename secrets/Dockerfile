#escape = ` 
FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8-windowsservercore-ltsc2019
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'Continue'; $verbosePreference='Continue';"]
WORKDIR c:\inetpub\wwwroot
ADD apollo . 
ENTRYPOINT if ($env:ConfigLocation) {New-Item -Path C:\inetpub\wwwroot\Web.config -ItemType SymbolicLink -Value $env:ConfigLocation -force -Verbose}; & "C:\ServiceMonitor.exe" "w3svc"
#RUN install-WindowsFeature 'Web-Http-Errors', 'Web-Server'
#HEALTHCHECK --interval=3s --timeout=30s --start-period=6s --retries=3 CMD powershell -command `  
#   try { `
#   $response = iwr http://localhost/default.aspx -usebasicParsing; `
#   if ($response.StatusCode -eq 200) { return 0} `
#   else {return 1}; `
#   } catch { return 1 }