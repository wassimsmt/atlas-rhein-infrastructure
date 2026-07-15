# Netzwerkkonfiguration fuer DC01: statische IP laut IP-Konzept, Umbenennung
# Ausführung: innerhalb der VM DC01, PowerShell als Administrator

New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress 10.10.10.10 `
    -PrefixLength 24 -DefaultGateway 10.10.10.1

# DNS zeigt auf den Server selbst, da er gleich zum DNS-Server wird
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses 10.10.10.10

Rename-Computer -NewName DC01 -Restart