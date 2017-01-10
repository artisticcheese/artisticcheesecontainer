new-containerImage -Path D:\docker\baseimage -Repository artisticcheese/base -Tag "latest" -Isolation HyperV -ErrorAction Stop -Verbose
new-containerImage -Path D:\docker\ -Repository artisticcheese/iis -Tag "latest" -Isolation HyperV -Verbose
#docker build . --network Bridged 