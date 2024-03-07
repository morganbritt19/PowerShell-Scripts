Import-Module ActiveDirectory

$username = Read-Host -Prompt "Enter the username you want to search for"

$user = Get-ADUser -Filter {SamAccountName -eq $username} -Properties GivenName, Surname, EmailAddress

if ($user) {
  $firstName = $user.GivenName
  $lastName = $user.Surname
  $emailAddress = $user.EmailAddress

  Write-Host "First name: $firstName"
  Write-Host "Last name: $lastName"
  Write-Host "Email address: $emailAddress"
} else {
  Write-Host "No user was found with username $username"
}
