# escape=`
FROM microsoft/aspnet
WORKDIR prep
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'Continue'; $verbosePreference='Continue';"]
RUN Install-Windowsfeature 'NET-WCF-HTTP-Activation45'
COPY /content/ c:/inetpub/wwwroot/
RUN Invoke-WebRequest "https://go.microsoft.com/fwlink/?linkid=517856" -UseBasicParsing -OutFile appinsights.msi; `
    Start-Process -filepath "appinsights.msi" -ArgumentList "/quiet" -PassThru | Wait-Process; `
    Remove-Item .\* -recurse -force -Verbose
RUN Import-Module 'C:\Program Files\Microsoft Application Insights\Status Monitor\PowerShell\Microsoft.Diagnostics.Agent.StatusMonitor.PowerShell.dll'; `
    Start-ApplicationInsightsMonitoring -Name 'default web site' -InstrumentationKey '3c069cb6-fc1a-4bab-974c-0a4245ae7f1b'