# Active-Directory-Design: Atlas-Rhein Handel GmbH



## Domänenname



ad.atlas-rhein.de



Begründung: Es wird eine Subdomäne der offiziellen Firmendomäne

verwendet. Endungen wie .local gelten nicht mehr als Best Practice,

und die Subdomäne vermeidet Konflikte mit der öffentlichen Website.



## OU-Struktur



Atlas-Rhein

├── Benutzer

│   ├── Geschaeftsfuehrung

│   ├── Vertrieb

│   ├── Einkauf

│   └── Buchhaltung

├── Computer

│   └── Arbeitsplaetze

├── Gruppen

└── Server



## Grundsätze



- Jeder Mitarbeiter erhält ein persönliches Benutzerkonto ohne

&#x20; Administratorrechte.

- Berechtigungen werden nur über Gruppen vergeben (AGDLP-Prinzip),

&#x20; nie direkt an Benutzer.

- Die Benutzerkonten werden per PowerShell-Skript aus einer

&#x20; CSV-Liste angelegt.

