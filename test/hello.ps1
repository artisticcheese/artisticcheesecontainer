Import-module docker
$config = [Docker.DotNet.Models.Config]::new()
($config.ExposedPorts  = [System.Collections.Generic.Dictionary[string,object]]::new()).Add("80/tcp", $null)
$hostConfig = [Docker.DotNet.Models.HostConfig]::new()
$pb = new-object Docker.DotNet.Models.PortBinding
$pb.HostPort = "8080"
$hostConfig.PortBindings = [System.Collections.Generic.Dictionary[string, System.Collections.Generic.iList[Docker.DotNet.Models.PortBinding]]]::new()
$hostConfig.PortBindings.Add("80/tcp",[System.Collections.Generic.List[Docker.DotNet.Models.PortBinding]]::new([Docker.DotNet.Models.PortBinding[]]@($pb)))
$hostconfig.CPUPercent = 33
Run-ContainerImage -ImageIdOrName "artisticcheese/iis:latest" -Configuration $config -Detach -HostConfiguration $hostConfig -Name $pb.HostPort 