#new-containerImage -Path D:\docker\baseimage -Repository artisticcheese/base -Tag "latest" -Isolation HyperV -ErrorAction Stop -Verbose
new-containerImage -Path D:\docker\ -Repository artisticcheese/iis -Tag "Version2" -Isolation HyperV -Verbose 
#| Add-ContainerImageTag -Repository artisticcheese/iis  -Tag "latest" 

