FROM openjdk:windowsservercore-1809

WORKDIR /app

ADD https://selenium-release.storage.googleapis.com/3.141/selenium-server-standalone-3.141.59.jar ./

ADD https://chromedriver.storage.googleapis.com/75.0.3770.140/chromedriver_win32.zip ./

ADD https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7BF323943E-48A3-7523-6A9C-EEDE6B337071%7D%26lang%3Den%26browser%3D4%26usagestats%3D1%26appname%3DGoogle%2520Chrome%26needsadmin%3Dprefers%26ap%3Dx64-stable-statsdef_1%26installdataindex%3Dempty/update2/installers/ChromeSetup.exe ./

RUN powershell expand-archive .\chromedriver_win32.zip . ; .\ChromeSetup.exe /silent /install

EXPOSE 4444

CMD [ "java -jar ./selenium-server-standalone-3.141.59.jar"]