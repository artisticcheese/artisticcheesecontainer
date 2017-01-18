## Launching Container

You can launch container from powershell prompt with all default settings as simple as running following cmdlet

```powershell
Invoke-ContainerImage -ImageIdOrName microsoft/iis -detach
```

This informs docker daemon to launch image `microsoft\iis` and not to attach to output of the image. 
You can verify next that your container is in fact running by executing below

```powershell
PS C:\Users\Administrator> get-container

ID                   Image           Command              Created                Status               Names
--                   -----           -------              -------                ------               -----
a9f94817aa5aba4da... microsoft/iis   C:\ServiceMonitor... 1/18/2017 2:51:55 AM   Up 7 seconds         modest_torvalds
```
Output shows that you have container with ID of `a9f94817aa5aba4da...` based of `microsoft/iis` image running. If you don't provide
explicit name then docker daemon will create random one for you as well (`modest_torvalds` in this case)
You can in fact verify that you have running IIS by pulling default page off running container.
For this you need to find what IP address of container is.
Docker by default is using "nat" network it creates when installed (172.x subnet) to host all your container images and using reverse NAT to tunnel requests to your images.
To get IP address of running container you can execute following cmdlet

```powershell
PS C:\Users\Administrator> (get-containerdetail modest_torvalds).NetworkSettings.Networks["nat"].IPAddress
172.28.23.14
```
To verify IIS is in fact running and working issue GET / to container

```powershell
PS C:\Users\Administrator> Invoke-WebRequest 172.28.23.14 | select -ExpandProperty headers

Key            Value
---            -----
Accept-Ranges  bytes
Content-Length 703
Content-Type   text/html
Date           Wed, 18 Jan 2017 03:05:24 GMT
ETag           "ccd6e68e456cd21:0"
Last-Modified  Wed, 11 Jan 2017 20:01:55 GMT
Server         Microsoft-IIS/10.0
```

This is full blown OS with vanilla IIS installation running on your OS.

To make things interesting check how much time it takes to launch 10 instances of IIS on your dev environment

```
PS C:\Users\Administrator> measure-command {1..10 | foreach-object {Invoke-ContainerImage -ImageIdOrName microsoft/iis -Detach}}


Days              : 0
Hours             : 0
Minutes           : 0
Seconds           : 50
Milliseconds      : 903
Ticks             : 509032196
TotalDays         : 0.000589157634259259
TotalHours        : 0.0141397832222222
TotalMinutes      : 0.848386993333333
TotalSeconds      : 50.9032196
TotalMilliseconds : 50903.2196
```

It took 50s on my machine. This is real OS with IIS which are completely independent from each other. Find IP address of one of those using steps above and use GET / request to verify

```powershell
PS C:\Users\Administrator> (get-containerdetail serene_austin).NetworkSettings.Networks["nat"].IPAddress
172.28.23.230
PS C:\Users\Administrator> Invoke-WebRequest 172.28.23.230 | select -ExpandProperty headers

Key            Value
---            -----
Accept-Ranges  bytes
Content-Length 703
Content-Type   text/html
Date           Wed, 18 Jan 2017 03:14:24 GMT
ETag           "ccd6e68e456cd21:0"
Last-Modified  Wed, 11 Jan 2017 20:01:55 GMT
Server         Microsoft-IIS/10.0
```

Next section will involve logging into invidual container and looking around