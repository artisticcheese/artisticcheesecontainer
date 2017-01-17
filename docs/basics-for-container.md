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
to download `latest` image, but if you want to download specific version then you can spefy specific `tag` which you are requesting.
Images can coexist side by side as long as combination of names/tags are unique.

While image is being downloads you can spy on process behind the scenes to understand what is happening in background.
<img src="images\Capture2.PNG"> 