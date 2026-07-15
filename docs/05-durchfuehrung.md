\# Durchführung



\## Woche 2: Firewall und Domänencontroller



\### Übersicht



| Datum | Arbeitsschritt |

|---|---|

| 14.07.2026 | Virtuelle Switches erstellt |

| 14.07.2026 | FW01 installiert und konfiguriert |

| 14.07.2026 | DC01 installiert, Domäne erstellt |

| 15.07.2026 | OPT-Schnittstellen und Gäste-DHCP eingerichtet |



\### Virtuelle Switches



Zuerst habe ich drei virtuelle Switches in Hyper-V erstellt:

LAN-Server, LAN-Mitarbeiter und LAN-Gaeste. Die Switches sind

privat, was bedeutet, dass nur die virtuellen Maschinen auf

diese Netzwerke zugreifen können.



\### FW01 (OPNsense-Firewall)



Danach habe ich die VM FW01 erstellt und OPNsense installiert.

Die vier Schnittstellen (WAN, LAN, OPT1, OPT2) habe ich anhand

der MAC-Adressen zugeordnet. Für die LAN-Schnittstelle habe ich

die IP-Adresse 10.10.10.1 konfiguriert. Über die Weboberfläche

habe ich später die Zonen MITARBEITER (10.10.20.1) und GAESTE

(10.10.30.1) eingerichtet.



\### DC01 (Domänencontroller)



Auf DC01 habe ich Windows Server 2025 installiert. Ich habe die

statische IP-Adresse 10.10.10.10 konfiguriert und den Server in

DC01 umbenannt. Dann habe ich den Server zum Domänencontroller

heraufgestuft; die Domäne heißt ad.atlas-rhein.de. Zum Schluss

habe ich DNS-Weiterleitungen (9.9.9.9 und 1.1.1.1) gesetzt,

damit interne Clients auch externe Namen auflösen können.



\### Probleme und Lösungen



| Problem | Ursache | Lösung |

|---|---|---|

| VM DC01 startete nicht | Nicht bootfähiges ISO (Languages and Optional Features) eingelegt | Auf der Microsoft-Website nach dem richtigen Image gesucht, das Evaluation-ISO heruntergeladen und eingebunden |

| OPNsense startete nicht mit Secure Boot | OPNsense basiert auf FreeBSD; die Standard-Vorlage von Hyper-V akzeptiert den FreeBSD-Bootloader nicht | Secure Boot in den Firmware-Einstellungen der VM deaktiviert (Set-VMFirmware) |

| Dienst ISC DHCPv4 nicht vorhanden | In OPNsense 26.1 entfernt (veraltet) | Den DHCP-Bereich für die Gäste-Zone stattdessen in Dnsmasq konfiguriert |



\### Prüfpunkte (Checkpoints)



| VM | Name | Zeitpunkt |

|---|---|---|

| FW01 | FW01-basiskonfiguration | nach der Konsolen-Grundkonfiguration |

| FW01 | FW01-woche2-abschluss | nach Zonen- und DHCP-Konfiguration |

| DC01 | DC01-vor-AD-promotion | vor der AD-Installation |

| DC01 | DC01-woche2-abschluss | nach Promotion und DNS-Konfiguration |

