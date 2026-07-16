# Erstellt die OU-Struktur laut AD-Design (docs/04-ad-design.md)
# Ausführung: innerhalb DC01, PowerShell als Administrator

$Basis = "DC=ad,DC=atlas-rhein,DC=de"

New-ADOrganizationalUnit -Name "Atlas-Rhein" -Path $Basis
$OU = "OU=Atlas-Rhein,$Basis"

foreach ($Name in "Benutzer","Computer","Gruppen","Server") {
    New-ADOrganizationalUnit -Name $Name -Path $OU
}

foreach ($Abt in "Geschaeftsfuehrung","Vertrieb","Einkauf","Buchhaltung") {
    New-ADOrganizationalUnit -Name $Abt -Path "OU=Benutzer,$OU"
}

New-ADOrganizationalUnit -Name "Arbeitsplaetze" -Path "OU=Computer,$OU"

Get-ADOrganizationalUnit -Filter * -SearchBase $OU | Format-Table Name, DistinguishedName