# Erstellt die VM FW01 (OPNsense-Firewall)
# WAN ueber Default Switch (NAT), drei interne Zonen als weitere Adapter
# Secure Boot muss deaktiviert werden, da OPNsense auf FreeBSD basiert
# Ausführung: Hyper-V-Host, PowerShell als Administrator

$IsoPfad = "C:\Lab\ISOs\OPNsense-26.1.6-dvd-amd64.iso"

New-VM -Name FW01 -Generation 2 -MemoryStartupBytes 2GB `
    -NewVHDPath "C:\Lab\VMs\FW01.vhdx" -NewVHDSizeBytes 20GB `
    -SwitchName "Default Switch"

Set-VM -Name FW01 -StaticMemory -ProcessorCount 2 -AutomaticCheckpointsEnabled $false
Set-VMFirmware -VMName FW01 -EnableSecureBoot Off

Add-VMNetworkAdapter -VMName FW01 -SwitchName "LAN-Server"
Add-VMNetworkAdapter -VMName FW01 -SwitchName "LAN-Mitarbeiter"
Add-VMNetworkAdapter -VMName FW01 -SwitchName "LAN-Gaeste"

Add-VMDvdDrive -VMName FW01 -Path $IsoPfad
Set-VMFirmware -VMName FW01 -FirstBootDevice (Get-VMDvdDrive -VMName FW01)

# MAC-Adressen zur Interface-Zuordnung anzeigen (nach dem ersten Start erneut ausfuehren)
Get-VMNetworkAdapter -VMName FW01 | Format-Table SwitchName, MacAddress