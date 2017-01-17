```
$config = [Docker.DotNet.Models.AuthConfig]::new()
$config.Username =$env:DockerUsername
$config.Password = $env:DockerPassword

#Submit-ContainerImage -ImageIdOrName artisticcheese/base -Authorization $config
Submit-ContainerImage -ImageIdOrName artisticcheese/iis:version2 -Authorization $config 
```
<<<<<<< HEAD
![Image of Windows Container] (capture.png)
=======
![Image of Windows Container] (/docs/Capture.png)
>>>>>>> a1039e9318b3d42a938b4158c1395e9893665218
