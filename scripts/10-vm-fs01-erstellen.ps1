# Erstellt FS01 (Windows Server 2025, Dateiserver) in der Server-Zone
# Ausführung: Hyper-V-Host, PowerShell als Administrator
# Zweite Festplatte (D:, Daten) wird separat angehaengt - siehe unten

$IsoPfad = "C:\Lab\ISOs\26100.32230.260111-0550.lt_release_svc_refresh_SERVER_EVAL_x64FRE_en-us.iso"

New-VM -Name FS01 -Generation 2 -MemoryStartupBytes 4GB `
    -NewVHDPath "C:\Lab\VMs\FS01.vhdx" -NewVHDSizeBytes 80GB `
    -SwitchName "LAN-Server"

Set-VM -Name FS01 -StaticMemory -ProcessorCount 4 -AutomaticCheckpointsEnabled $false

Add-VMDvdDrive -VMName FS01 -Path $IsoPfad
Set-VMFirmware -VMName FS01 -FirstBootDevice (Get-VMDvdDrive -VMName FS01)

# Datenfestplatte (getrennt von der Systemplatte - Best Practice fuer Dateiserver)
New-VHD -Path "C:\Lab\VMs\FS01-Daten.vhdx" -SizeBytes 40GB -Dynamic
Add-VMHardDiskDrive -VMName FS01 -Path "C:\Lab\VMs\FS01-Daten.vhdx"

# Nach der Installation: ISO auswerfen, damit der Laufwerksbuchstabe D frei wird
# Set-VMDvdDrive -VMName FS01 -ControllerNumber 0 -ControllerLocation 1 -Path $null