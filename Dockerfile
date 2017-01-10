# escape=`
FROM artisticcheese/base
#ENV containeradmin contadmin
#ENV containerpassword A123456!
ADD startup.ps1 ./startup.ps1
ADD iis.ps1 ./iisconfig.ps1
COPY /content/ c:/inetpub/wwwroot/content/
RUN powershell.exe .\iisconfig.ps1
ENTRYPOINT powershell.exe c:\startup.ps1; del c:\startup.ps1; C:\ServiceMonitor.exe w3svc
#CMD powershell.exe .\startup.ps1;C:\ServiceMonitor.exe w3svc
#EXPOSE 80