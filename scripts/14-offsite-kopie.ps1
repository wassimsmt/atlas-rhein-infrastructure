# Simuliert die Offsite-Kopie des 3-2-1-Prinzips: Spiegelung des
# Backup-Repositories auf ein zweites Ziel (im Lab ein lokaler Ordner,
# der eine externe Festplatte repraesentiert).
# Ausführung: Hyper-V-Host, PowerShell als Administrator

robocopy C:\Lab\Backup-Repo C:\Lab\Offsite-Sim /MIR /R:2 /W:5 /LOG:C:\Lab\offsite-log.txt