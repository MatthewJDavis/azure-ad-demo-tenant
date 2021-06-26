# Configure test domain
Install-WindowsFeature -Name AD-Domain-Services
$Password = Read-Host -Prompt   'Enter SafeMode Admin Password' -AsSecureString
$Params = @{
  CreateDnsDelegation           = $false
  DatabasePath                  = 'C:\Windows\NTDS'
  DomainMode                    = 'WinThreshold'
  DomainName                    = 'matthewdavis111.com'
  DomainNetbiosName             = 'matthewdavis111'
  ForestMode                    = 'WinThreshold'
  InstallDns                    = $true
  LogPath                       = 'C:\Windows\NTDS'
  SafeModeAdministratorPassword = $Password
  SysvolPath                    = 'C:\Windows\SYSVOL'
  Force                         = $true
}
Install-ADDSForest @Params

Restart-Computer -Force

Install-WindowsFeature -Name 'RSAT-ADDS'

New-ADOrganizationalUnit -Name MDInc -Path "DC=matthewdavis111,DC=com"-PassThru
New-ADOrganizationalUnit -Name Employees -Path "OU=MDInc,DC=matthewdavis111,DC=com" -PassThru
New-ADOrganizationalUnit -Name Servers -Path "OU=MDInc,DC=matthewdavis111,DC=com" -PassThru
New-ADOrganizationalUnit -Name Computers -Path "OU=MDInc,DC=matthewdavis111,DC=com" -PassThru
New-ADOrganizationalUnit -Name Admins -Path "OU=MDInc,DC=matthewdavis111,DC=com" -PassThru

$import_users = Import-Csv -Path sample.csv

$import_users | ForEach-Object {
  $userParams = @{
    Name              = $($_.FirstName + " " + $_.LastName)
    GivenName         = $_.FirstName 
    Surname           = $_.LastName
    Department        = $_.Department
    EmployeeID        = $_.EmployeeID
    DisplayName       = $($_.FirstName + " " + $_.LastName)
    Office            = $_.Office
    UserPrincipalName = $_.UserPrincipalName
    SamAccountName    = $_.SamAccountName
    AccountPassword   = $(ConvertTo-SecureString $_.Password -AsPlainText -Force)
    Path              = "OU=Employees, OU=MDInc,DC=matthewdavis111,DC=com"
    Enabled           = $True
  }
  New-ADUser @userParams
}

Enable-ADOptionalFeature 'Recycle Bin Feature' -Scope ForestOrConfigurationSet -Target matthewdavis111.com