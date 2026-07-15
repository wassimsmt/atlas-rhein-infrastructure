# Erstellt die drei privaten virtuellen Switches (Netzwerkzonen)
# Ausführung: Hyper-V-Host, PowerShell als Administrator

New-VMSwitch -Name "LAN-Server" -SwitchType Private
New-VMSwitch -Name "LAN-Mitarbeiter" -SwitchType Private
New-VMSwitch -Name "LAN-Gaeste" -SwitchType Private

Get-VMSwitch | Format-Table Name, SwitchType