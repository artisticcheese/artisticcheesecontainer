$pb = new-object Docker.DotNet.Models.PortBinding
$pb.HostPort = "88"
$hostConfig = new-object Docker.DotNet.Models.HostConfig
$hostConfig.PortBindings = [System.Collections.Generic.Dictionary[string, System.Collections.Generic.iList[Docker.DotNet.Models.PortBinding]]]::new()
$hostConfig.PortBindings.Add("80/tcp",[System.Collections.Generic.List[Docker.DotNet.Models.PortBinding]]::new([Docker.DotNet.Models.PortBinding[]]@($pb)))
Run-ContainerImage -HostConfiguration $hostConfig -Name microsoft/iis -Detach
