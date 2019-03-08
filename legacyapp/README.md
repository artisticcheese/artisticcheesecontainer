# Legacy app details

* **Buggy code** <BR>
This URL will crash server if executed more then 2 times in a row http://gregwin2008.eastus.cloudapp.azure.com/crash.aspx
* **Memory leak code** <BR>
This URL will leak about 1 MB on each execution http://gregwin2008.eastus.cloudapp.azure.com/leak.aspx. To see leak use execute apache bench against server with code below and see private memory climb above 1 GB<BR>
`docker run --rm -t jordi/ab -k -c 100 -n 5000 -r http://gregwin2008.eastus.cloudapp.azure.com/leak.aspx`

* **Runaway CPU app** <BR>
Executing http://gregwin2008.eastus.cloudapp.azure.com/load.aspx will cause 100% CPU utilization for 5 minutes

* **Poor scalability app** <BR>
Application running at http://gregwin2008.eastus.cloudapp.azure.com/singlethread.asp serializing all processing on single thread and hence can not produce more then 1 Req/s throuhgput regardless of CPU/mem allocation on host. To demonstrate run apache bench tool below which will simulate 10 clients for 30 seconds hitting website at fast as possible<BR>
`docker run --rm -t jordi/ab -k -c 10 -t 30 gregwin2008.eastus.cloudapp.azure.com/singlethread.asp`

* **Lost knowledge challenge**<BR>
Application running at http://gregwin2008.eastus.cloudapp.azure.com/lostknowledge.aspx writes a text file to subfolder `content`. By default IIS will not allow to write to work directory and manual change of permissions is required. Difficult to troubleshoot and maintain.
* **Inefficient use of resources**<BR>
Every virtual machine will usually require dedicated CPUs, memory, disk, network card etc. In addition to hardware requirements they will also require provision and ongoing operation support (procure VM, join to domain, procure monitoring/backup/configuration software/patching software/anti-virus)

# Windows Container solution

## Buggy code solution
Application failures in traditional setup will require expensive tools and procedures to bring servers back online (manual or automatic). Docker container provide `HEALTHCHECK` platform construct to verify if container is healthy.
* **Demonstration** <BR>
`docker ps` output have a `STATUS` column now identifying health of running container. Executing `http://localhost:8080/crash.aspx` 2 times in a row will crash application pool and hence `HEALTCHECK` will fail as well which will cause change of `STATUS` field.
When service deployed to swarm this field informs orchestrator about health of container. <BR>
Execute following against swarm `docker run --rm -t jordi/ab -k -c 10 -t 30 -r http://gregvm.eastus.cloudapp.azure.com/crash.aspx` and monitor `docker ps` output showing containers being recycled by orchestrator after crash.
## Memory leak solution
Containers on Windows can run in 2 different isolation modes: `process` and `hyperv`. 
* **Demonstration**<BR>
    In `process` isolation container using resources straight from parent OS system so container RAM usage is significantly smaller compares to `hyper` isolation
    Compare execution of code below
    ```powershell
    1..2 | %{start-job -scriptblock {docker run --rm --isolation=process -d -p 80 artisticcheese/legacyapp}}; Get-Job | wait-job | remove-job
    ```
    vs
    ```powershell
    1..2 | %{start-job -scriptblock {docker run --rm --isolation=hyperv -d -p 80 artisticcheese/legacyapp}}; Get-Job | wait-job | remove-job
    ```
    See output of `docker stats` for comparison of memory consumption
    Docker allows you to specify limit on both CPU and memory use. 
    Example below `docker run --rm -d -p 8080:80 -m 1GB --isolation=hyperv artisticcheese/legacyapp` will limit memory utilization of container to 1 GB. Execute 10000 times http://localhost:8080/leak.aspx and compare to results of 10000 requests against local IIS server earlier (~2GB memory utilization).
## CPU limit solution 
    
Similar to limiting memory on running containers it's possible to limit both CPU and as well number of processors available to container. Example below will limit CPU usage of container to 10% max `docker run --rm -d -p 8080:80 --cpu-percent 10 --isolation=hyperv artisticcheese/legacyapp`. Execute http://localhost:8080/load.aspx which will tax CPU for 5 minutes. Examing `docker stats` for limits enforced by container runtime

## Solution to poor scalability

Container start up time is miniscule compared to VM. Example below measures start up time of 10 containers. After containers started examine `docker ps` showing containers are `healthy` after started.

```powershell
measure-command { 1..10 | %{start-job -scriptblock {docker run --rm --isolation=process -d -p 80 artisticcheese/legacyapp}}; Get-Job | wait-job | remove-job}
```
Scaling container is very simple. <BR>
Command below deploying single instance of application in docker swarm <BR>
`docker service create --publish 80:80 --replicas 1 --name legacyapp artisticcheese/legacyapp`<BR>
Siege against swarm in such case yields the same poor perfomance (about 1 Req/s)<BR>
`docker run --rm -t jordi/ab -k -c 10 -t 30 http://gregvm.eastus.cloudapp.azure.com/singlethread.asp`<BR>
Scale service <BR>
` docker service scale legacyapp=10`<BR>
Rerun apache benche again which shall show 10x increase in perfomance


## Solution to lost knowledge

`DOCKERFILE` provides single solution for both lost knowledge and lack of documentation for any possible upgrades and troubleshooting of image

## Solution to inefficient use of resources
In addition to much lower footprint to VM for both VM, RAM, disk space usage - containers do not require common IT software: backup, dedicated monitoring, configuration management, operational support, patching etc.<BR>
Example of size of entire container on disk can be examined via `docker images artisticcheese/legacyapp` is about 5 GB. <BR>
Containers are rebuilt monthly, you can examine layer by `docker history artisticcheese/legacyapp` which is showing layer on top of base image updated monthly.