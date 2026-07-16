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



\## Woche 3 (Teil 1): Benutzer, DHCP und Client



\### Übersicht



| Datum | Arbeitsschritt |

|---|---|

| 15.07.2026 | OU-Struktur und 20 Benutzer per Skript angelegt |

| 15.07.2026 | DHCP-Rolle auf DC01, Bereich Mitarbeiter, DHCP-Relay auf FW01 |

| 15.07.2026 | Firewall-Regeln für die Mitarbeiter-Zone |

| 15.07.2026 | CL01 installiert und in die Domäne aufgenommen |



\### OU-Struktur und Benutzer



Ich habe die OU-Struktur laut AD-Design per PowerShell-Skript

erstellt. Das Skript hilft mir sehr, weil ich es nur einfügen

muss und PowerShell es von oben nach unten ausführt. Danach habe

ich vier Abteilungsgruppen und 20 Benutzer aus einer CSV-Datei

angelegt. Wichtig ist: Jeder Benutzer muss das Startpasswort beim

ersten Login ändern.



\### DHCP für die Mitarbeiter-Zone



Auf DC01 habe ich die DHCP-Rolle installiert und einen Bereich

für die Mitarbeiter-Zone (10.10.20.100 bis 10.10.20.200)

erstellt. Da sich der DHCP-Server (DC01) in der Server-Zone

befindet und DHCP-Anfragen als Broadcast das eigene Netz nicht

verlassen, habe ich auf der Firewall ein DHCP-Relay eingerichtet,

das die Anfragen aus der Mitarbeiter-Zone an DC01 (10.10.10.10)

weiterleitet. Die Gäste-Zone bekommt ihre Adressen dagegen direkt

von Dnsmasq auf der Firewall.



\### Firewall-Regeln



Standardmäßig blockiert OPNsense allen Verkehr auf optionalen

Schnittstellen. Ich habe zwei Pass-Regeln für die

Mitarbeiter-Zone erstellt: Die erste erlaubt Verkehr von der

Mitarbeiter-Zone in die Server-Zone (AD, DNS, Dateiserver), die

zweite erlaubt Verkehr von der Mitarbeiter-Zone ins Internet. Die

Gäste-Zone hat keine Regeln und bleibt deshalb vollständig von

den internen Netzen isoliert.



\### CL01 (Windows-11-Client)



Ich habe CL01 mit Windows 11 Enterprise installiert. Der Client

hat automatisch die IP-Adresse 10.10.20.100 vom DHCP-Server

bekommen. Danach habe ich den Client in die Domäne aufgenommen.

Zum Test habe ich mich als sara.bennani angemeldet und musste

sofort das Passwort ändern.



\### Probleme und Lösungen



| Problem | Ursache | Lösung |

|---|---|---|

| CL01 startete nicht (Fehler 0xC000A002), fünf DVD-Laufwerke vorhanden | Das Erstellungsskript wurde mehrfach ausgeführt; dadurch entstanden doppelte DVD-Laufwerke und der vTPM-Zustand wurde beschädigt | VM vollständig entfernt und einmalig neu erstellt |

| CL01: "The boot loader failed" beim ersten Start | Die Aufforderung "Press any key to boot from CD or DVD" wurde verpasst | VM neu gestartet, Fenster fokussiert und die Taste rechtzeitig gedrückt |



Aus dem ersten Problem habe ich gelernt: Ein Skript sollte

idempotent sein oder nur einmal ausgeführt werden. Bei einem

Fehler lese ich zuerst die Meldung, bevor ich etwas erneut

ausführe.



\### Prüfpunkte (Checkpoints)



| VM | Name | Zeitpunkt |

|---|---|---|

| DC01 | DC01-woche3-teil1 | nach DHCP, OUs und Benutzern |

| FW01 | FW01-woche3-teil1 | nach Regeln und Relay |

| CL01 | CL01-domaenenbeitritt | direkt nach dem Domänenbeitritt |

