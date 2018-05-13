Function QueryNTP {
    $server = "pool.ntp.org"
    [Byte[]]$NtpData = , 0 * 48
    $NtpData[0] = 0x1B    # NTP Request header in first byte  
    $Socket = New-Object -TypeName Net.Sockets.Socket -ArgumentList ([Net.Sockets.AddressFamily]::InterNetwork,
        [Net.Sockets.SocketType]::Dgram,
        [Net.Sockets.ProtocolType]::Udp)
    $Socket.SendTimeOut = 2000  # ms
    $Socket.ReceiveTimeOut = 2000   # ms

    Try {
        $Socket.Connect($Server, 123)
    }
    Catch {
        Write-Error -Message "Failed to connect to server $Server"
        Throw 
    }

    Try {
        [Void]$Socket.Send($NtpData)      # Send request header
        [Void]$Socket.Receive($NtpData)   # Receive 48-byte NTP response
    }
    Catch {
        Write-Error -Message "Failed to communicate with server $Server"
        Throw
    }
    $Socket.Shutdown('Both') 
    $Socket.Close()
    return $NtpData[0]
}
1..100 | ForEach-Object {Write-Output "Message number $_" ; QueryNTP}
