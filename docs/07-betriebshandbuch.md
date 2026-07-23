# Betriebshandbuch: Atlas-Rhein Handel GmbH



Dieses Betriebshandbuch beschreibt den laufenden Betrieb der

IT-Infrastruktur der Atlas-Rhein Handel GmbH: Startreihenfolge der

Systeme, Server- und IP-Übersicht, Umgang mit Zugangsdaten,

Datensicherung, Monitoring, Prüfpunkte sowie das Vorgehen bei

Ausfällen.



## 1. Startreihenfolge der Systeme



Die Systeme müssen in der folgenden Reihenfolge gestartet werden:



FW01 → DC01 → FS01 → SRV-LX01 → MON01 → CL01



FW01 muss zuerst starten, da die Firewall für alle drei Netzzonen

(Server, Mitarbeiter, Gäste) das Gateway ist und ohne sie keine

Kommunikation zwischen den Zonen möglich ist. DC01 muss direkt

danach starten, da DC01 den Domänencontroller, DNS und DHCP

bereitstellt: Ohne DC01 können sich weder die übrigen Server per

Namensauflösung finden noch Clients per DHCP eine IP-Adresse

beziehen oder sich an der Domäne anmelden. FS01, SRV-LX01 und MON01

folgen als Server, die DNS und teilweise die Domänenanmeldung von

DC01 benötigen. CL01 startet zuletzt, da der Client für die

Domänenanmeldung sowohl DC01 (Authentifizierung, DNS) als auch DHCP

(Adressvergabe über das Relay auf FW01) benötigt.



| Reihenfolge | System | Rolle |
|---|---|---|
| 1 | FW01 | Firewall (OPNsense), Gateway aller Zonen |
| 2 | DC01 | Domänencontroller, DNS, DHCP |
| 3 | FS01 | Dateiserver |
| 4 | SRV-LX01 | Nextcloud |
| 5 | MON01 | Monitoring (CheckMK) |
| 6 | CL01 | Client (Mitarbeiter-Arbeitsplatz) |



## 2. Server- und IP-Übersicht



Die folgende Übersicht basiert auf dem IP-Konzept

(03-ip-konzept.md).



| Hostname | IP-Adresse | Rolle |
|---|---|---|
| FW01 | 10.10.10.1 | Firewall (OPNsense) |
| DC01 | 10.10.10.10 | Domänencontroller, DNS, DHCP |
| FS01 | 10.10.10.11 | Dateiserver |
| SRV-LX01 | 10.10.10.20 | Nextcloud (Ubuntu Server) |
| MON01 | 10.10.10.30 | Monitoring, CheckMK (Ubuntu Server) |
| CL01 | dynamisch (DHCP-Bereich 10.10.20.100–10.10.20.200) | Client (Mitarbeiter-Zone) |



Die Server-Zone (10.10.10.0/24) verwendet ausschließlich statische

Adressen, die Mitarbeiter-Zone (10.10.20.0/24) und die Gäste-Zone

(10.10.30.0/24) vergeben ihre Adressen per DHCP. Alle internen

Systeme verwenden DC01 (10.10.10.10) als DNS-Server.



## 3. Zugangsdaten



Zugangsdaten (Passwörter für Administrator- und Dienstkonten) sind

nicht Teil dieses Repositorys und werden ausschließlich in einer

separaten, gesicherten Datei außerhalb der Versionskontrolle

verwaltet. Dieses Betriebshandbuch verweist nur auf diese Datei,

enthält selbst aber keine Passwörter.



Ablageort der Zugangsdaten: Separate Datei auf dem Hyper-V-Host außerhalb des Repositorys (PASSWORDS.md).



## 4. Datensicherung



Die Datensicherung erfolgt mit Veeam Backup \& Replication. Da der

Hyper-V-Host unter Windows 11 (Client) läuft und eine hostbasierte

Sicherung dort nicht unterstützt wird, wird eine agentenbasierte

Sicherung eingesetzt: Auf DC01, FS01 und SRV-LX01 läuft jeweils ein

Veeam-Agent, der über den zentralen Veeam-Server verwaltet wird.

CL01 wird nicht gesichert, da ein Client im Fehlerfall neu

installiert und der Domäne wieder hinzugefügt werden kann. FW01

wird als Konfigurationsdatei gesichert, nicht als Abbild.



Die Sicherung folgt dem 3-2-1-Prinzip: drei Kopien der Daten auf

zwei Medientypen, davon eine Kopie an einem externen Ort. Die drei

Kopien sind: das Original auf den produktiven Festplatten, die

Sicherung im Veeam-Repository sowie eine Offsite-Kopie, die im

Labor durch einen zweiten Ordner (stellvertretend für eine externe

Festplatte) simuliert wird.



Zeitplan des Backup-Jobs: Täglich um 22:00 Uhr, es werden sieben Wiederherstellungspunkte vorgehalten.



### Wiederherstellung



Eine Wiederherstellung erfolgt über die Veeam-Konsole: Dort wird der

gewünschte Wiederherstellungspunkt des betroffenen Servers

ausgewählt und die verlorene Datei bzw. das Volume daraus

wiederhergestellt. Die Funktionsfähigkeit dieses Vorgangs wurde im

Rahmen des Projekts bereits getestet: Eine Testdatei auf dem

Laufwerk G: (FS01) wurde gelöscht und anschließend erfolgreich aus

dem Backup wiederhergestellt (siehe 05-durchfuehrung.md, Woche 5).



## 5. Monitoring



Der Zustand aller überwachten Hosts (DC01, FS01, SRV-LX01) wird über

das CheckMK-Webinterface auf MON01 (10.10.10.30) geprüft.



Adresse des CheckMK-Webinterfaces: http://mon01.ad.atlas-rhein.de/atlasrhein/



Die Anmeldedaten für CheckMK sind, wie in Abschnitt 3 beschrieben,

nicht Teil dieses Repositorys und separat gesichert hinterlegt.



## 6. Prüfpunkte (Checkpoints)



Vor jeder größeren Änderung an einer VM (z. B. Rollenwechsel,

größere Konfigurationsänderung, Softwareinstallation) wird in

Hyper-V ein Prüfpunkt (Checkpoint) erstellt. So kann eine VM bei

einem Fehler ohne Datenverlust auf den letzten funktionierenden

Stand zurückgesetzt werden. Beispiele aus dem Projekt (siehe

05-durchfuehrung.md): DC01-vor-AD-promotion vor der

AD-Installation, FS01-woche3-abschluss nach Freigaben und

Reparatur, SRVLX01-ldap nach der LDAPS-Anbindung.



Vorgehen: Vor Beginn der Änderung Prüfpunkt erstellen, Änderung

durchführen und testen, bei Erfolg optional einen weiteren

Abschluss-Prüfpunkt erstellen, bei Fehlschlag auf den vorherigen

Prüfpunkt zurücksetzen.



## 7. Vorgehen bei Ausfällen



Bei Ausfall eines Dienstes oder einer VM wird wie folgt vorgegangen:



1. Status im CheckMK-Webinterface prüfen: Zeigt der betroffene Host

   oder Dienst CRIT oder ist er nicht erreichbar (Status UP fehlt)?



2. Grundlegende Erreichbarkeit prüfen (Ping, DNS-Auflösung über

   DC01), um Netzwerk- von Dienstproblemen zu unterscheiden.



3. Auf dem betroffenen System den Dienststatus bzw. das Ereignisprotokoll

   (Windows) oder die Logs (Linux, z. B. journalctl) prüfen.



4. Die Tabellen "Probleme und Lösungen" in 05-durchfuehrung.md

   konsultieren, da mehrere während des Projekts aufgetretene

   Fehlerbilder bereits dokumentiert sind.



5. Fehlerursache schrittweise eingrenzen, wie im Projekt mehrfach

   praktiziert (z. B. Diagnose des T:-Laufwerk-Problems in Woche 3

   oder der fehlenden TLS-Registrierung der CheckMK-Agenten in

   Woche 5), statt Änderungen ungezielt vorzunehmen.



6. Lässt sich der Fehler nicht kurzfristig beheben, den letzten

   passenden Hyper-V-Prüfpunkt einspielen oder die betroffenen Daten

   über Veeam aus dem Backup wiederherstellen.



Eskalationsweg und Erreichbarkeiten außerhalb der Geschäftszeiten:

Im Laborbetrieb nicht definiert. In einer Produktivumgebung wären hier Rufbereitschaft und Ansprechpartner zu hinterlegen.
