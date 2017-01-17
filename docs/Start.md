```
$config = [Docker.DotNet.Models.AuthConfig]::new()
$config.Username =$env:DockerUsername
$config.Password = $env:DockerPassword

#Submit-ContainerImage -ImageIdOrName artisticcheese/base -Authorization $config
Submit-ContainerImage -ImageIdOrName artisticcheese/iis:version2 -Authorization $config 
```
![Image of Windows Container] (/docs/Capture.png)
