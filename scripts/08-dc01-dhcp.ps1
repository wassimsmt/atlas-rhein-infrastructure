# Installiert die DHCP-Rolle auf DC01 und erstellt den Bereich
# fuer die Mitarbeiter-Zone (10.10.20.100 - 10.10.20.200)
# Ausführung: innerhalb der VM DC01, PowerShell als Administrator
#
# Hinweis: DC01 steht in der Server-Zone. Damit DHCP-Broadcasts
# aus der Mitarbeiter-Zone ankommen, ist auf der Firewall (FW01)
# ein DHCP-Relay konfiguriert: Interface MITARBEITER -> 10.10.10.10
# (Services > DHCRelay). Die Gaeste-Zone wird separat von Dnsmasq
# auf FW01 bedient.

Install-WindowsFeature DHCP -IncludeManagementTools

# DHCP-Server im Active Directory autorisieren
Add-DhcpServerInDC -DnsName DC01.ad.atlas-rhein.de -IPAddress 10.10.10.10

# Bereich fuer die Mitarbeiter-Zone anlegen
Add-DhcpServerv4Scope -Name "Mitarbeiter" -StartRange 10.10.20.100 `
    -EndRange 10.10.20.200 -SubnetMask 255.255.255.0

# Gateway, DNS-Server und DNS-Domaene fuer den Bereich setzen
Set-DhcpServerv4OptionValue -ScopeId 10.10.20.0 -Router 10.10.20.1 `
    -DnsServer 10.10.10.10 -DnsDomain "ad.atlas-rhein.de"

# Kontrolle
Get-DhcpServerv4Scope