Import-Module -Name az
$name = 'terraform-azuread'

$credentials = New-Object -TypeName Microsoft.Azure.Commands.ActiveDirectory.PSADPasswordCredential -Property @{
  StartDate=Get-Date; EndDate=Get-Date -Year 2022; Password=$password}

$sp = New-AzAdServicePrincipal -DisplayName $name -PasswordCredential $credentials

