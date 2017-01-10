# escape=`
FROM artisticcheese/base
<<<<<<< HEAD
<<<<<<< HEAD
=======
#ENV containeradmin contadmin
#ENV containerpassword A123456!
>>>>>>> ccc841b40e56bf05fbbdcc16eafc92609fddddb5
=======
#ENV containeradmin contadmin
#ENV containerpassword A123456!
>>>>>>> ccc841b40e56bf05fbbdcc16eafc92609fddddb5
ADD startup.ps1 ./startup.ps1
ADD iis.ps1 ./iisconfig.ps1
COPY /content/ c:/inetpub/wwwroot/content/
RUN powershell.exe .\iisconfig.ps1
ENTRYPOINT powershell.exe c:\startup.ps1; del c:\startup.ps1; C:\ServiceMonitor.exe w3svc
<<<<<<< HEAD
<<<<<<< HEAD

=======
#CMD powershell.exe .\startup.ps1;C:\ServiceMonitor.exe w3svc
>>>>>>> ccc841b40e56bf05fbbdcc16eafc92609fddddb5
=======
#CMD powershell.exe .\startup.ps1;C:\ServiceMonitor.exe w3svc
>>>>>>> ccc841b40e56bf05fbbdcc16eafc92609fddddb5
#EXPOSE 80