## Starting to work with Windows containers

Containers in nutshell is the similar concept to virtualization as far as abstracting underlying architecture.
In case of virtualization - hardware is being abstracted, while container technology is  abstracting operating system. 
Probably one of the best way to understand this concept is to run your own container and explore how it interacts with underlying OS.


To pull any images you can use either docker CLU or docker powershell module. I will rely on latter for everything.
To pull microsoft/iis module for docker hub execute 

```powershell
Pull-ContainerImage -Repository microsoft/iis
```
This will instruct docker engine to connect to microsoft/iis repository and download latest version of the image. Images have tags and  by default it will try
to download `latest` image, but if you want to download specific version then you can specify specific `tag` which you are requesting.
Images can coexist side by side as long as combination of names/tags are unique.

While image is being downloaded you can spy on process behind the scenes to understand what is happening in background.
Download will in parallel pull all layers of image being asked to Temp Folder, extract them and put in docker images repository folder.

<img src="images\Capture2.PNG" width="1600"> 

Once download is complete you can inspect result of it by checking what container images are available on your system for container instantiation
```
PS C:\WINDOWS\system32> get-containerimage

RepoTags                                 ID                   Created                        Size(MB)
--------                                 --                   -------                        --------
microsoft/iis:latest                     sha256:7d4c79e586... 1/11/2017 8:03:09 PM           9,383.55
```

As you can see you got microsoft/iis:latest version of the image (tag is demoted by colon). This image is based of latest servercore version of Windows. If you want image based of nano server or previous version of the image, say based off
OS version 10.0.14300.1030 then you can execute PS cmdlet below which will give your exact version requested. (You can find different versions at following page (https://hub.docker.com/r/microsoft/iis/tags/)

Pull-ContainerImage -Repository "microsoft/iis" -Tag "windowsservercore-10.0.14300.1030"