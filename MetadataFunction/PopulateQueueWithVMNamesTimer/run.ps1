# Input bindings are passed in via param block.
param($Timer)

# Get the current universal time in the default string format
$currentUTCtime = (Get-Date).ToUniversalTime()
Write-Host "Starting executing Timerfunctino at $currentUTCtime"
# Write an information log with the current time.
Add-QueueMessage
