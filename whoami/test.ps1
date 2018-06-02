Write-Host Starting test

if ($env:ARCH -ne "amd64") {
  Write-Host "Arch $env:ARCH detected. Skip testing."
  exit 0
}

$ErrorActionPreference = 'SilentlyContinue';
docker kill whoamitest
docker rm -f whoamitest

$ErrorActionPreference = 'Stop';
Write-Host Starting container
docker run --name whoamitest -p 8080:8080 -d whoami
Start-Sleep 10

docker logs whoamitest

$ErrorActionPreference = 'SilentlyContinue';
docker kill whoamitest
docker rm -f whoamitest
