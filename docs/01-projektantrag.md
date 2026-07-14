\# Projektantrag: IT-Infrastruktur Atlas-Rhein Handel GmbH



\## 1. Projektbezeichnung



Planung und Implementierung einer zentralen IT-Infrastruktur

für ein kleines Handelsunternehmen mit 20 Mitarbeitern.



\## 2. Kurzbeschreibung der Aufgabe



Im Rahmen des Projekts wird eine zentrale IT-Infrastruktur für die

Atlas-Rhein Handel GmbH geplant und implementiert. Es werden mehrere

Komponenten aufgebaut: eine Firewall mit Netzwerksegmentierung, eine

Windows-Domäne mit zentraler Benutzerverwaltung, ein Dateiserver mit

einem Berechtigungskonzept, ein Monitoring aller Systeme sowie eine

Datensicherungsstrategie nach dem 3-2-1-Prinzip.



\## 3. Ist-Analyse



Der Arbeitgeber einer Firma ruft mich an, weil ich gute

Netzwerkkenntnisse habe. Er hätte gerne meine Hilfe bei der

Netzwerkinfrastruktur seiner Firma. In der Firma gibt es viele

Probleme, z. B. nur einen Router und einen Switch, keine Domäne,

alle Mitarbeiter haben Administratorrechte und es gibt kein

Monitoring. Letzte Woche hatte ein Mitarbeiter ein großes Problem:

Er hat eine wichtige Datei gelöscht, und es gab kein Backup.



\## 4. Soll-Konzept und Projektziele



Am Ende des Projekts soll die folgende Infrastruktur produktiv

nutzbar sein:



\- Zentrale Benutzerverwaltung mit Active Directory (Windows Server 2025)

\- Netzwerksegmentierung in drei Zonen: Server, Mitarbeiter und Gäste

\- Firewall (OPNsense) mit einem dokumentierten Regelwerk zwischen den Zonen

\- Zentraler Dateiserver mit Berechtigungskonzept nach dem AGDLP-Prinzip

\- Cloud-Speicher (Nextcloud) mit Anmeldung über Active Directory

\- Monitoring aller Server und Dienste mit CheckMK, inklusive Alarmierung

\- Datensicherung nach dem 3-2-1-Prinzip mit dokumentiertem Wiederherstellungstest

\- Entzug der lokalen Administratorrechte für alle Mitarbeiter



\## 5. Projektumfeld



Das Projekt wird in einer virtuellen Testumgebung umgesetzt

(Microsoft Hyper-V auf Windows 11 Pro, sechs virtuelle Maschinen).



\## 6. Projektphasen und Zeitplanung



| Phase | Inhalt | Dauer |

|---|---|---|

| 1 | Planung (Netzplan, IP-Konzept, AD-Design) | 1 Woche |

| 2 | Firewall und Domänencontroller | 1 Woche |

| 3 | Dateiserver und Client | 1 Woche |

| 4 | Linux-Server mit Nextcloud | 1 Woche |

| 5 | Datensicherung und Monitoring | 1 Woche |

| 6 | Tests und Abschlussdokumentation | 1 Woche |



\## 7. Geplante Dokumentation



Netzplan, IP-Konzept, AD-Design, Betriebshandbuch, Testprotokolle

und eine abschließende Projektdokumentation als PDF.

