Import-module docker
$config = [Docker.DotNet.Models.Config]::new()
($config.Env = [System.Collections.Generic.List[string]]::new()).Add("containeradmin=$($env:ContainerAdmin)")
$config.Env.Add("containerpassword=$($env:ContainerPassword)")
#($config.ExposedPorts  = [System.Collections.Generic.Dictionary[string,object]]::new()).Add("80/tcp", $null)
#$hostConfig = [Docker.DotNet.Models.HostConfig]::new()
#($hostConfig.Binds = [System.Collections.Generic.List[string]]::New()).Add('d:\docker\content:c:\logs\host')

#$pb = new-object Docker.DotNet.Models.PortBinding
#$pb.HostPort = "443"
#$hostConfig.PortBindings = [System.Collections.Generic.Dictionary[string, System.Collections.Generic.iList[Docker.DotNet.Models.PortBinding]]]::new()
#$hostConfig.PortBindings.Add("80/tcp",[System.Collections.Generic.List[Docker.DotNet.Models.PortBinding]]::new([Docker.DotNet.Models.PortBinding[]]@($pb)))
#$hostConfig.NetworkMode = "nat"
#$hostconfig.CPUPercent = 33

#$hostConfig.CPUQuota = 50 

#Run-ContainerImage -Isolation HyperV -Name "first" -ImageIdOrName "iis:01_52_19" -HostConfiguration $hostconfig -Configuration $config -Verbose -Detach
#Run-ContainerImage -ImageIdOrName "artisticcheese/iis:latest" -Configuration $config -Detach -HostConfiguration $hostConfig -Name $pb.HostPort  
Run-ContainerImage -ImageIdOrName "artisticcheese/iis:latest" -Configuration $config -Detach -name "iis" 