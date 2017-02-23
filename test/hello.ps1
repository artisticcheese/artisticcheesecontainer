Configuration IIS {
    Import-DscResource -ModuleName "PSDesiredStateConfiguration" 
    param(

        [string] $sslThumbprint
    )
  
    node localhost {
    
      

    }
}

IIS -sslThumbprint "DDD" -Outputpath (Join-Path $PSScriptRoot "BasicIIS") 

