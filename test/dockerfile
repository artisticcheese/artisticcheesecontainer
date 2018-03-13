FROM microsoft/aspnet

RUN mkdir C:\storefront 

RUN powershell -NoProfile -Command \
    Import-module IISAdministration; \
    New-IISSite -Name "Storefront" -PhysicalPath C:\storefront -BindingInformation "*:80:"

EXPOSE 80

ADD storefront/ /storefront