# Installiert AD DS und erstellt die neue Gesamtstruktur ad.atlas-rhein.de
# Ausführung: innerhalb der VM DC01, PowerShell als Administrator
# Vorher: Pruefpunkt "DC01-vor-AD-promotion" erstellen

Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

Install-ADDSForest -DomainName "ad.atlas-rhein.de" `
    -DomainNetBIOSName "ATLASRHEIN" -InstallDns
# Es folgt die Abfrage des DSRM-Kennworts, danach automatischer Neustart

# Nach dem Neustart: DNS-Weiterleitungen fuer externe Namensaufloesung
Set-DnsServerForwarder -IPAddress 9.9.9.9, 1.1.1.1