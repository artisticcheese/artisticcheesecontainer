Function Send-TCPMessage { 
    Param ( 
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()] 
        [string] 
        $EndPoint
        , 
        [Parameter(Mandatory = $true, Position = 1)]
        [int]
        $Port
        , 
        [Parameter(Mandatory = $true, Position = 2)]
        [string]
        $Message
    ) 
    Process {
        # Setup connection 
        $IP = [System.Net.Dns]::GetHostAddresses($EndPoint) 
        $Address = [System.Net.IPAddress]::Parse($IP) 
        $Socket = New-Object System.Net.Sockets.TCPClient($Address, $Port) 
        $socket.ReceiveTimeout = 2000;
        #$socket.SendTimeout = 2000;
        # Setup stream wrtier 
        $Stream = $Socket.GetStream() 
        $Writer = New-Object System.IO.StreamWriter($Stream)

        # Write message to stream
        $Message | % {
            $Writer.WriteLine($_)
            $Writer.Flush()
            Write-Output "Sending message "
        }
    
        # Close connection and stream
        $Stream.Close()
        $Socket.Close()
    }
}
$start = Get-Date
1..100 | ForEach-Object {Write-Output "Message Nubmber $_" ; Send-TCPMessage -Port 80 -Message $_ -EndPoint www.microsoft.com }
Write-Output "Total Time in seconds: $(((Get-Date).Subtract($start)).TotalSeconds)"