$ErrorActionPreference = 'Stop';
$files = ""
Write-Host Starting build

if ($isWindows) {
  docker build --pull -t whoami -f Dockerfile.windows .
} else {
  docker build -t whoami --build-arg "arch=$env:ARCH" .
}

docker images
