# Erstellt Abteilungsgruppen und legt 20 Benutzer aus der CSV an
# Ausführung: innerhalb DC01, CSV vorher nach C:\skripte kopieren

$OU = "OU=Atlas-Rhein,DC=ad,DC=atlas-rhein,DC=de"

foreach ($Abt in "Geschaeftsfuehrung","Vertrieb","Einkauf","Buchhaltung") {
    New-ADGroup -Name "G_$Abt" -GroupScope Global `
        -Path "OU=Gruppen,$OU" -GroupCategory Security
}

$StartPw = ConvertTo-SecureString "Start!2026#AR" -AsPlainText -Force
$Benutzer = Import-Csv -Path "C:\skripte\benutzer.csv"

foreach ($B in $Benutzer) {
    $Sam = ("$($B.Vorname).$($B.Nachname)").ToLower()
    New-ADUser -Name "$($B.Vorname) $($B.Nachname)" `
        -GivenName $B.Vorname -Surname $B.Nachname `
        -SamAccountName $Sam `
        -UserPrincipalName "$Sam@ad.atlas-rhein.de" `
        -Path "OU=$($B.Abteilung),OU=Benutzer,$OU" `
        -AccountPassword $StartPw -Enabled $true `
        -ChangePasswordAtLogon $true
    Add-ADGroupMember -Identity "G_$($B.Abteilung)" -Members $Sam
}

Get-ADUser -Filter * -SearchBase "OU=Benutzer,$OU" |
    Measure-Object | Select-Object Count