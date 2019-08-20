#Invoke-RestMethod -Headers @{"Metadata" = "true" } -URI http://169.254.169.254/metadata/scheduledevents?api-version=2017-11-01 -Method get
$request = [System.Net.WebRequest]::Create('http://169.254.169.254/metadata/scheduledevents?api-version=2017-11-01')
$request.Headers["Metadata"] = "true"
(new-object System.IO.StreamReader $request.GetResponse().GetResponseStream()).ReadToEnd() | out-string
