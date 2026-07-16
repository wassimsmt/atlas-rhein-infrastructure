# Erstellt CL01 (Windows 11 Enterprise Eval) in der Mitarbeiter-Zone
# Win11 benoetigt ein virtuelles TPM

$IsoPfad = "C:\Lab\ISOs\26200.6584.250915-1905.25h2_ge_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"

New-VM -Name CL01 -Generation 2 -MemoryStartupBytes 4GB `
    -NewVHDPath "C:\Lab\VMs\CL01.vhdx" -NewVHDSizeBytes 60GB `
    -SwitchName "LAN-Mitarbeiter"

Set-VM -Name CL01 -StaticMemory -ProcessorCount 4 -AutomaticCheckpointsEnabled $false
Set-VMKeyProtector -VMName CL01 -NewLocalKeyProtector
Enable-VMTPM -VMName CL01

Add-VMDvdDrive -VMName CL01 -Path $IsoPfad
Set-VMFirmware -VMName CL01 -FirstBootDevice (Get-VMDvdDrive -VMName CL01)