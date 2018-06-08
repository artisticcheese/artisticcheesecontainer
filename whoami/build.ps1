docker build -t artisticcheese/whoami:latest --build-arg buildimagetag=2.1-sdk-nanoserver-sac2016 --build-arg runtimeimagetag=2.1.0-aspnetcore-runtime-nanoserver-sac2016 .
#docker build -t artisticcheese/whoami:test .

docker -D manifest create "artisticcheese/whoami:latest" "artisticcheese/whoami:unix-2018060814" "artisticcheese/whoami:nanolts-2018060527"
docker manifest push "artisticcheese/whoami:latest"