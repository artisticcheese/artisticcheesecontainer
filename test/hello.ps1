Import-module docker
$hostConfig = [Docker.DotNet.Models.HostConfig]::new()
$hostconfig.CPUCount = 3
Run-ContainerImage -ImageIdOrName "microsoft/iis" -Detach -name "3CPUs"  -HostConfiguration $hostConfig