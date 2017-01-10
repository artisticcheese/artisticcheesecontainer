Import-module docker
$config = [Docker.DotNet.Models.Config]::new()
#($config.Env = [System.Collections.Generic.List[string]]::new()).Add("containeradmin=$($env:ContainerAdmin)")
#$config.Env.Add("containerrunpassword=$($env:ContainerPassword)")
($config.ExposedPorts  = [System.Collections.Generic.Dictionary[string,object]]::new()).Add("8080:80", $null)
$hostConfig = [Docker.DotNet.Models.HostConfig]::new()
($hostConfig.Binds = [System.Collections.Generic.List[string]]::New()).Add('d:\docker\content:c:\logs\host')
$hostConfig.NetworkMode = "nat"
$hostConfig.CPUCount = "2"
$hostConfig.CPUQuota = "50000"
#$hostConfig.CPUQuota = 50 
Get-Container | remove-container -Force
#Run-ContainerImage -Isolation HyperV -Name "first" -ImageIdOrName "iis:01_52_19" -HostConfiguration $hostconfig -Configuration $config -Verbose -Detach
<<<<<<< HEAD
Run-ContainerImage -ImageIdOrName "artisticcheese/iis" -Configuration $config -Detach -HostConfiguration $hostConfig -Name "iis"
=======
Run-ContainerImage -ImageIdOrName "mcafee/iis" -Configuration $config -Detach -HostConfiguration $hostConfig -Name "iis"
>>>>>>> ccc841b40e56bf05fbbdcc16eafc92609fddddb5


