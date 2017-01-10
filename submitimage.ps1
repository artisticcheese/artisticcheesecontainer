
$config = [Docker.DotNet.Models.AuthConfig]::new()
$config.Username =$env:DockerUsername
$config.Password = $env:DockerPassword

Submit-ContainerImage -ImageIdOrName artisticcheese/base -Authorization $config
Submit-ContainerImage -ImageIdOrName artisticcheese/iis -Authorization $config