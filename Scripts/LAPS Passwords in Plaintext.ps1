# This script displayed Microsoft Local Administrator Password Solution (LAPS) passwords in a color-coded format.

$computers = Get-ADComputer -Filter * -Properties Name, ms-Mcs-AdmPwd, ms-Mcs-AdmPwdExpirationTime|
$table = $computers | ForEach-Object {
	$computer = $_
	$password = $computer.'ms-Mcs-AdmPwd'|
	$expiration = $computer.'ms-Mcs-AdmPwdExpirationTime'|

if ($password) {
	[PSCustomObject]@{
	'Computer Name' = $computer.Name
	'Computer Password' = $password
	'Expiration Time' = [DateTime]::FromFileTime($expiration)
		}
	}
} | Format-Table -AutoSize -Wrap | Out-String -Stream

$colorIndex = 0
$table | ForEach-Object {
	$line = $_.TrimEnd()

	if ($colorIndex -eq 0) {
		Write-Host $line -ForegroundColor Red
	} else {
		if ($colorIndex % 2 -eq 1) {
			Write-Host $line -ForegroundColor Green
		} else {
			Write-Host $line -ForegroundColor Blue
		}
	}

	if ($colorIndex -eq 0) {
		Write-Host ('-' * ($line.Length - 2)) -ForegroundColor Red
	} else {
		Write-Host ('-' * ($line.Length - 2)) -ForegroundColor Gray
	}

	$colorIndex++
}
