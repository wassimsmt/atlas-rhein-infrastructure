# Erstellt MON01 (Ubuntu Server 26.04, CheckMK-Monitoring) in der Server-Zone
# Ausführung: Hyper-V-Host, PowerShell als Administrator

$IsoPfad = "C:\Lab\ISOs\ubuntu-26.04-live-server-amd64.iso"

New-VM -Name MON01 -Generation 2 -MemoryStartupBytes 3GB `
    -NewVHDPath "C:\Lab\VMs\MON01.vhdx" -NewVHDSizeBytes 40GB `
    -SwitchName "LAN-Server"

Set-VM -Name MON01 -StaticMemory -ProcessorCount 2 -AutomaticCheckpointsEnabled $false
Set-VMFirmware -VMName MON01 -SecureBootTemplate MicrosoftUEFICertificateAuthority

Add-VMDvdDrive -VMName MON01 -Path $IsoPfad
Set-VMFirmware -VMName MON01 -FirstBootDevice (Get-VMDvdDrive -VMName MON01)