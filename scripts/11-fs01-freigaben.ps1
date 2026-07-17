# Dateiserver FS01: Ordnerstruktur, DL-Gruppen, Freigabe und
# NTFS-Berechtigungen nach dem AGDLP-Prinzip
# Ausführung: innerhalb FS01, PowerShell als ATLASRHEIN\Administrator
# Voraussetzung: Datenfestplatte als D: (NTFS, Label "Daten") eingerichtet
#
# Hinweis aus der Praxis: Auf englischsprachigen Systemen heisst das
# Konto "Everyone", nicht "Jeder". Fehlerunterdrueckung (SilentlyContinue)
# wurde entfernt, damit Fehler sichtbar bleiben.

$OU = "OU=Gruppen,OU=Atlas-Rhein,DC=ad,DC=atlas-rhein,DC=de"
$Abteilungen = "Geschaeftsfuehrung","Vertrieb","Einkauf","Buchhaltung"

# 1. Ordnerstruktur
New-Item -ItemType Directory -Path "D:\Daten" -Force | Out-Null
foreach ($A in $Abteilungen + "Austausch") {
    New-Item -ItemType Directory -Path "D:\Daten\$A" -Force | Out-Null
}

# 2. AD-PowerShell-Modul und domaenenlokale Gruppen
Install-WindowsFeature RSAT-AD-PowerShell | Out-Null
foreach ($A in $Abteilungen) {
    New-ADGroup -Name "DL_${A}_RW" -GroupScope DomainLocal `
        -Path $OU -GroupCategory Security
    Add-ADGroupMember -Identity "DL_${A}_RW" -Members "G_$A"
}
New-ADGroup -Name "DL_Austausch_RW" -GroupScope DomainLocal `
    -Path $OU -GroupCategory Security
Add-ADGroupMember -Identity "DL_Austausch_RW" `
    -Members G_Vertrieb,G_Einkauf,G_Buchhaltung,G_Geschaeftsfuehrung

# 3. SMB-Freigabe (Zugriffssteuerung erfolgt ueber NTFS)
New-SmbShare -Name "Abteilungen$" -Path "D:\Daten" -FullAccess "Everyone"

# 4. NTFS-Berechtigungen: Vererbung kappen, gezielt vergeben
$Ziele = @{}
foreach ($A in $Abteilungen) { $Ziele["D:\Daten\$A"] = "ATLASRHEIN\DL_${A}_RW" }
$Ziele["D:\Daten\Austausch"] = "ATLASRHEIN\DL_Austausch_RW"

foreach ($Pfad in $Ziele.Keys) {
    $Acl = Get-Acl $Pfad
    $Acl.SetAccessRuleProtection($true, $false)
    $Acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule(
        $Ziele[$Pfad],"Modify","ContainerInherit,ObjectInherit","None","Allow")))
    $Acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule(
        "SYSTEM","FullControl","ContainerInherit,ObjectInherit","None","Allow")))
    $Acl.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule(
        "ATLASRHEIN\Domain Admins","FullControl","ContainerInherit,ObjectInherit","None","Allow")))
    Set-Acl $Pfad $Acl
}

# Kontrolle
Get-SmbShare Abteilungen$
Get-ADGroup -Filter 'Name -like "DL_*"' | Format-Table Name