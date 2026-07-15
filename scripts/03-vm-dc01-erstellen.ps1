# Erstellt die VM DC01 (Windows Server 2025, Domaenencontroller)
# Ausführung: Hyper-V-Host, PowerShell als Administrator
# Hinweis: Den ISO-Dateinamen an das tatsaechliche SERVER_EVAL-Image anpassen

$IsoPfad = "C:\Lab\ISOs\26100.32230.260111-0550.lt_release_svc_refresh_SERVER_EVAL_x64FRE_en-us.iso"

New-VM -Name DC01 -Generation 2 -MemoryStartupBytes 4GB `
    -NewVHDPath "C:\Lab\VMs\DC01.vhdx" -NewVHDSizeBytes 60GB `
    -SwitchName "LAN-Server"

Set-VM -Name DC01 -StaticMemory -ProcessorCount 4 -AutomaticCheckpointsEnabled $false

Add-VMDvdDrive -VMName DC01 -Path $IsoPfad
Set-VMFirmware -VMName DC01 -FirstBootDevice (Get-VMDvdDrive -VMName DC01)