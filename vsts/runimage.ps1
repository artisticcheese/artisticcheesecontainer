Import-module docker
$config = [Docker.DotNet.Models.Config]::new()
($config.Env = [System.Collections.Generic.List[string]]::new()).Add("VSTS_ACCOUNT=$($env:VSTS_ACCOUNT)")
$config.Env.Add("VSTS_TOKEN=$($env:VSTS_TOKEN)")
$hostConfig = [Docker.DotNet.Models.HostConfig]::new()
#($hostConfig.Binds = [System.Collections.Generic.List[string]]::New()).Add('d:\docker\content:c:\logs\host')

Run-ContainerImage -ImageIdOrName "artisticcheese/vsts" -Configuration $config -name "vsts"  -HostConfiguration $hostConfig -RemoveAutomatically