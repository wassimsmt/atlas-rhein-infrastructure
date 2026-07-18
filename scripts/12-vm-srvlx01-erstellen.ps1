# Erstellt SRV-LX01 (Ubuntu Server 26.04, Nextcloud) in der Server-Zone
# Ausführung: Hyper-V-Host, PowerShell als Administrator
#
# Wichtig: Fuer Linux-Gaeste bleibt Secure Boot AKTIV, aber mit der
# Vorlage "Microsoft UEFI Certificate Authority" (signierte Linux-Bootloader).
# Die Vorlage "Microsoft Windows" wuerde den Ubuntu-Bootloader ablehnen.

$IsoPfad = "C:\Lab\ISOs\ubuntu-26.04-live-server-amd64.iso"

New-VM -Name SRV-LX01 -Generation 2 -MemoryStartupBytes 4GB `
    -NewVHDPath "C:\Lab\VMs\SRV-LX01.vhdx" -NewVHDSizeBytes 60GB `
    -SwitchName "LAN-Server"

Set-VM -Name SRV-LX01 -StaticMemory -ProcessorCount 2 -AutomaticCheckpointsEnabled $false
Set-VMFirmware -VMName SRV-LX01 -SecureBootTemplate MicrosoftUEFICertificateAuthority

Add-VMDvdDrive -VMName SRV-LX01 -Path $IsoPfad
Set-VMFirmware -VMName SRV-LX01 -FirstBootDevice (Get-VMDvdDrive -VMName SRV-LX01)

# Nach der Installation: ISO auswerfen
# Set-VMDvdDrive -VMName SRV-LX01 -ControllerNumber 0 -ControllerLocation 1 -Path $null