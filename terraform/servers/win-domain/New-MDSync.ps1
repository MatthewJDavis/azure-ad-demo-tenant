# Domain join

$dcIP = '10.0.2.4'

Set-DnsClientServerAddress -InterfaceIndex (Get-NetAdapter).ifIndex -ServerAddresses $dcIP
$cred = Get-Credential
Add-Computer -ComputerName $env:COMPUTERNAME -DomainName 'matthewdavis111.com' -OUPath "OU=Servers,OU=MDInc,DC=matthewdavis111,DC=com" -Credential $cred
Restart-Computer -Force

# Donwload latest Azure AD connect from: https://www.microsoft.com/en-us/download/details.aspx?id=47594
# Requires Enterprise Admin from on-premises domain and Global Azure admin to configure.