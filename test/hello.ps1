Import-module docker
#$hostConfig = [Docker.DotNet.Models.HostConfig]::new()
#($hostconfig.SecurityOpt  = [System.Collections.Generic.List[string]]::new()).Add("credentialspec=file://Gmsa.json")

Run-ContainerImage -ImageIdOrName "artisticcheese/base:latest" -Detach -Name iis

#Run-ContainerImage -ImageIdOrName "microsoft/iis:latest" -Configuration $config -Detach -HostConfiguration $hostConfig -Name $pb.HostPort he   