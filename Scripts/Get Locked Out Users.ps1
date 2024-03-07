# Import required modules
Import-Module ActiveDirectory

# Get all domain controllers
$domainControllers = Get-ADDomainController -Filter *

# Function to get lockout events from a domain controller
function Get-LockoutEvents {
    param (
        [Parameter(Mandatory=$true)]
        [string]$DCName
    )

    # Fetch lockout events (Event ID 4740) from the security log
    $events = Get-WinEvent -ComputerName $DCName -FilterHashtable @{LogName='Security';ID=4740} -ErrorAction SilentlyContinue

    return $events
}

# Loop through each domain controller and fetch lockout events
$allLockoutEvents = @()
foreach ($dc in $domainControllers) {
    $allLockoutEvents += Get-LockoutEvents -DCName $dc.HostName
}

# Display locked-out users and the source of their lockouts
foreach ($event in $allLockoutEvents) {
    $userName = $event.Properties[0].Value
    $source = $event.Properties[1].Value
    Write-Host "User $userName was locked out from $source."
}
