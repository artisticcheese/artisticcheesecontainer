
$config = [Docker.DotNet.Models.AuthConfig]::new()
$config.Username =$env:DockerUsername
$config.Password = $env:DockerPassword

<<<<<<< HEAD
Submit-ContainerImage -ImageIdOrName artisticcheese/base -Authorization $config
Submit-ContainerImage -ImageIdOrName artisticcheese/iis -Authorization $config

=======
Submit-ContainerImage -ImageIdOrName artisticcheese/base -Authorization $config
>>>>>>> ccc841b40e56bf05fbbdcc16eafc92609fddddb5
