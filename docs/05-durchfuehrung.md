# Durchführung



## Woche 2: Firewall und Domänencontroller



### Übersicht



| Datum | Arbeitsschritt |
|---|---|
| 14.07.2026 | Virtuelle Switches erstellt |
| 14.07.2026 | FW01 installiert und konfiguriert |
| 14.07.2026 | DC01 installiert, Domäne erstellt |
| 15.07.2026 | OPT-Schnittstellen und Gäste-DHCP eingerichtet |



### Virtuelle Switches



Zuerst habe ich drei virtuelle Switches in Hyper-V erstellt:

LAN-Server, LAN-Mitarbeiter und LAN-Gaeste. Die Switches sind

privat, was bedeutet, dass nur die virtuellen Maschinen auf

diese Netzwerke zugreifen können.



### FW01 (OPNsense-Firewall)



Danach habe ich die VM FW01 erstellt und OPNsense installiert.

Die vier Schnittstellen (WAN, LAN, OPT1, OPT2) habe ich anhand

der MAC-Adressen zugeordnet. Für die LAN-Schnittstelle habe ich

die IP-Adresse 10.10.10.1 konfiguriert. Über die Weboberfläche

habe ich später die Zonen MITARBEITER (10.10.20.1) und GAESTE

(10.10.30.1) eingerichtet.



### DC01 (Domänencontroller)



Auf DC01 habe ich Windows Server 2025 installiert. Ich habe die

statische IP-Adresse 10.10.10.10 konfiguriert und den Server in

DC01 umbenannt. Dann habe ich den Server zum Domänencontroller

heraufgestuft; die Domäne heißt ad.atlas-rhein.de. Zum Schluss

habe ich DNS-Weiterleitungen (9.9.9.9 und 1.1.1.1) gesetzt,

damit interne Clients auch externe Namen auflösen können.



### Probleme und Lösungen



| Problem | Ursache | Lösung |
|---|---|---|
| VM DC01 startete nicht | Nicht bootfähiges ISO (Languages and Optional Features) eingelegt | Auf der Microsoft-Website nach dem richtigen Image gesucht, das Evaluation-ISO heruntergeladen und eingebunden |
| OPNsense startete nicht mit Secure Boot | OPNsense basiert auf FreeBSD; die Standard-Vorlage von Hyper-V akzeptiert den FreeBSD-Bootloader nicht | Secure Boot in den Firmware-Einstellungen der VM deaktiviert (Set-VMFirmware) |
| Dienst ISC DHCPv4 nicht vorhanden | In OPNsense 26.1 entfernt (veraltet) | Den DHCP-Bereich für die Gäste-Zone stattdessen in Dnsmasq konfiguriert |



### Prüfpunkte (Checkpoints)



| VM | Name | Zeitpunkt |
|---|---|---|
| FW01 | FW01-basiskonfiguration | nach der Konsolen-Grundkonfiguration |
| FW01 | FW01-woche2-abschluss | nach Zonen- und DHCP-Konfiguration |
| DC01 | DC01-vor-AD-promotion | vor der AD-Installation |
| DC01 | DC01-woche2-abschluss | nach Promotion und DNS-Konfiguration |



## Woche 3 (Teil 1): Benutzer, DHCP und Client



### Übersicht



| Datum | Arbeitsschritt |
|---|---|
| 15.07.2026 | OU-Struktur und 20 Benutzer per Skript angelegt |
| 15.07.2026 | DHCP-Rolle auf DC01, Bereich Mitarbeiter, DHCP-Relay auf FW01 |
| 15.07.2026 | Firewall-Regeln für die Mitarbeiter-Zone |
| 15.07.2026 | CL01 installiert und in die Domäne aufgenommen |



### OU-Struktur und Benutzer



Ich habe die OU-Struktur laut AD-Design per PowerShell-Skript

erstellt. Das Skript hilft mir sehr, weil ich es nur einfügen

muss und PowerShell es von oben nach unten ausführt. Danach habe

ich vier Abteilungsgruppen und 20 Benutzer aus einer CSV-Datei

angelegt. Wichtig ist: Jeder Benutzer muss das Startpasswort beim

ersten Login ändern.



### DHCP für die Mitarbeiter-Zone



Auf DC01 habe ich die DHCP-Rolle installiert und einen Bereich

für die Mitarbeiter-Zone (10.10.20.100 bis 10.10.20.200)

erstellt. Da sich der DHCP-Server (DC01) in der Server-Zone

befindet und DHCP-Anfragen als Broadcast das eigene Netz nicht

verlassen, habe ich auf der Firewall ein DHCP-Relay eingerichtet,

das die Anfragen aus der Mitarbeiter-Zone an DC01 (10.10.10.10)

weiterleitet. Die Gäste-Zone bekommt ihre Adressen dagegen direkt

von Dnsmasq auf der Firewall.



### Firewall-Regeln



Standardmäßig blockiert OPNsense allen Verkehr auf optionalen

Schnittstellen. Ich habe zwei Pass-Regeln für die

Mitarbeiter-Zone erstellt: Die erste erlaubt Verkehr von der

Mitarbeiter-Zone in die Server-Zone (AD, DNS, Dateiserver), die

zweite erlaubt Verkehr von der Mitarbeiter-Zone ins Internet. Die

Gäste-Zone hat keine Regeln und bleibt deshalb vollständig von

den internen Netzen isoliert.



### CL01 (Windows-11-Client)



Ich habe CL01 mit Windows 11 Enterprise installiert. Der Client

hat automatisch die IP-Adresse 10.10.20.100 vom DHCP-Server

bekommen. Danach habe ich den Client in die Domäne aufgenommen.

Zum Test habe ich mich als sara.bennani angemeldet und musste

sofort das Passwort ändern.



### Probleme und Lösungen



| Problem | Ursache | Lösung |
|---|---|---|
| CL01 startete nicht (Fehler 0xC000A002), fünf DVD-Laufwerke vorhanden | Das Erstellungsskript wurde mehrfach ausgeführt; dadurch entstanden doppelte DVD-Laufwerke und der vTPM-Zustand wurde beschädigt | VM vollständig entfernt und einmalig neu erstellt |
| CL01: "The boot loader failed" beim ersten Start | Die Aufforderung "Press any key to boot from CD or DVD" wurde verpasst | VM neu gestartet, Fenster fokussiert und die Taste rechtzeitig gedrückt |



Aus dem ersten Problem habe ich gelernt: Ein Skript sollte

idempotent sein oder nur einmal ausgeführt werden. Bei einem

Fehler lese ich zuerst die Meldung, bevor ich etwas erneut

ausführe.



### Prüfpunkte (Checkpoints)



| VM | Name | Zeitpunkt |
|---|---|---|
| DC01 | DC01-woche3-teil1 | nach DHCP, OUs und Benutzern |
| FW01 | FW01-woche3-teil1 | nach Regeln und Relay |
| CL01 | CL01-domaenenbeitritt | direkt nach dem Domänenbeitritt |





## Woche 3 (Teil 2): Dateiserver, Berechtigungen und Gruppenrichtlinien



### Übersicht



| Datum | Arbeitsschritt |
|---|---|
| 16.07.2026 | FS01 installiert und in die Domäne aufgenommen |
| 16.07.2026 | Datenfestplatte, Freigabe und AGDLP-Berechtigungen |
| 16.07.2026 | GPOs: Laufwerkszuordnung und Client-Sicherheit |
| 16.07.2026 | Abnahmetest als Standardbenutzerin |



### FS01 (Dateiserver)



Ich habe FS01 mit Windows Server 2025 installiert und in die

Domäne aufgenommen. Für die Daten habe ich eine zweite virtuelle

Festplatte angehängt und als Laufwerk D: (NTFS, Label "Daten")

eingerichtet. System und Daten liegen damit getrennt, was

Sicherung und Neuinstallation erleichtert.



### Freigabe und AGDLP-Berechtigungen



Nach dem AGDLP-Prinzip erhalten Benutzer ihre Berechtigungen

niemals direkt, sondern über eine Gruppenkette: Der Benutzer ist

Mitglied einer globalen Abteilungsgruppe (z. B. G\_Vertrieb), diese

ist in einer domänenlokalen Gruppe verschachtelt (z. B.

DL\_Vertrieb\_RW), und nur die domänenlokale Gruppe bekommt

NTFS-Berechtigungen auf dem Ordner. Ich habe die Freigabe

Abteilungen$ auf D:\\Daten erstellt. Jede Abteilung hat einen

eigenen Ordner, dazu gibt es den gemeinsamen Ordner Austausch.

Die NTFS-Berechtigungen habe ich per PowerShell-Skript gesetzt.



### Gruppenrichtlinien



Die erste GPO (GPO-Laufwerkszuordnung) verbindet für jede

Abteilung automatisch das Laufwerk G: mit dem eigenen

Abteilungsordner sowie für alle Benutzer das Laufwerk T: mit dem

Ordner Austausch. Die zweite GPO (GPO-Client-Sicherheit) entzieht

den Mitarbeitern die lokalen Administratorrechte: Über Restricted

Groups sind auf allen Arbeitsplätzen nur noch die Domain Admins

Mitglied der lokalen Administratorengruppe.



### Abnahmetest



Zum Abschluss habe ich mich auf CL01 als sara.bennani angemeldet.

Die Netzlaufwerke G: (Vertrieb) und T: (Austausch) wurden

automatisch verbunden, und ich konnte auf beiden eine Testdatei

erstellen. Der Zugriff auf den Ordner der Buchhaltung wurde

verweigert. Der Versuch, ein Terminal als Administrator zu

öffnen, scheiterte ebenfalls: Die Benutzerin hat durch die GPO

keine lokalen Administratorrechte mehr.



### Probleme und Lösungen



| Problem | Ursache | Lösung |
|---|---|---|
| FS01 startete nicht ("hash is not allowed") | Falsches ISO eingelegt (Ubuntu statt Windows Server); Secure Boot lehnte den Bootloader korrekt ab | Richtiges SERVER\_EVAL-Image eingelegt, Secure Boot wieder aktiviert |
| Laufwerksbuchstabe D war belegt | Erst durch das Installations-ISO, dann durch das leere DVD-Laufwerk | ISO ausgeworfen, Buchstaben freigegeben, Datenpartition als D: erstellt |
| Freigabe wurde nicht erstellt | Konto "Jeder" existiert nur auf deutschen Systemen; der Server läuft auf Englisch | Freigabe mit dem Konto "Everyone" erstellt; Fehlerunterdrückung aus dem Skript entfernt |
| Anmeldung als Standardbenutzerin schlug fehl | Die Enhanced Session ist technisch eine RDP-Verbindung; Standardbenutzer haben kein RDP-Recht | In der Basiskonsole (Enhanced Session deaktiviert) angemeldet |
| Laufwerk T: wurde nicht verbunden | Die Gruppe DL\_Austausch\_RW existierte nicht mehr im AD; ohne NTFS-Rechte schlug die Zuordnung stumm fehl | Gruppe neu erstellt, Mitglieder hinzugefügt, NTFS-Berechtigungen erneuert |



Das T:-Problem habe ich schrittweise eingegrenzt: net use zeigte,

dass die Zuordnung fehlte; gpresult bestätigte, dass die GPO

angewendet wurde, aber die Gruppe DL\_Austausch\_RW nicht im Token

der Benutzerin war; der GPO-Bericht zeigte einen korrekten

Eintrag; Get-ADGroupMember ergab schließlich, dass die Gruppe im

AD gar nicht existierte. Nach dem Neuerstellen musste ich auch die

NTFS-Berechtigungen erneuern, denn eine neu erstellte Gruppe hat

eine neue SID — die alte Berechtigung zeigte nur noch auf eine

verwaiste SID.



### Prüfpunkte (Checkpoints)



| VM | Name | Zeitpunkt |
|---|---|---|
| DC01 | DC01-woche3-abschluss | nach GPOs |
| FS01 | FS01-woche3-abschluss | nach Freigaben und Reparatur |
| CL01 | CL01-woche3-abschluss | nach bestandenem Abnahmetest |





## Woche 4: Linux-Server mit Nextcloud und AD-Anmeldung



### Übersicht



| Datum | Arbeitsschritt |
|---|---|
| 17.07.2026 | Ubuntu Server installiert, Netzwerk und DNS eingerichtet |
| 17.07.2026 | LAMP-Stack und Nextcloud installiert |
| 17.07.2026 | Zertifizierungsstelle installiert, LDAPS-Anbindung ans AD |
| 18.07.2026 | HTTPS mit eigenem Zertifikat, Abnahmetest von CL01 |



### Ubuntu-Server (SRV-LX01)



Ich habe SRV-LX01 mit Ubuntu Server 26.04 installiert und die

statische IP-Adresse 10.10.10.20/24 konfiguriert (Gateway

10.10.10.1, DNS 10.10.10.10, laut IP-Konzept). Außerdem habe ich

den SSH-Server installiert. Die weitere Administration erfolgte

per SSH von DC01 aus, weil dort Copy-and-paste zuverlässig

funktioniert und das dem Arbeitsalltag entspricht.



### Nextcloud-Installation



Für Nextcloud habe ich Apache (Webserver), MariaDB (Datenbank)

und PHP mit den benötigten Modulen installiert. Ich habe

Nextcloud bewusst manuell eingerichtet statt über das Snap-Paket,

damit jede Komponente sichtbar und konfigurierbar bleibt.

Nextcloud liegt unter /var/www/nextcloud und gehört dem

Apache-Benutzer www-data.



### LDAPS-Anbindung an Active Directory



Damit sich Mitarbeiter mit ihrem Domänenkonto anmelden können,

habe ich Nextcloud an das Active Directory angebunden. Die

Benutzer werden dabei nicht kopiert oder hochgeladen: Sie bleiben

im AD, und Nextcloud fragt das Verzeichnis bei jeder Anmeldung

live an. Dafür habe ich das Dienstkonto svc-nextcloud mit reinen

Leserechten angelegt. Windows Server 2025 lehnt unverschlüsselte

LDAP-Binds ab, deshalb habe ich eine Enterprise-Zertifizierungs-

stelle (Atlas-Rhein-CA) installiert und die Anbindung auf LDAPS

(Port 636) umgestellt. Als Anmeldename dient der sAMAccountName,

sodass die Benutzer denselben Namen wie am Windows-PC verwenden.

Das lokale Konto ncadmin bleibt als Notfall-Administrator

unabhängig vom AD bestehen.



### HTTPS mit eigener Zertifizierungsstelle



Für die Cloud habe ich ein Zertifikat erstellt, das von der

eigenen Zertifizierungsstelle signiert wurde. Zusätzlich leitet

eine Apache-Regel alle HTTP-Anfragen dauerhaft auf HTTPS um.

DC01 und CL01 zeigen keine Zertifikatswarnung, weil

Domänenmitglieder dem Zertifikat der Enterprise-CA automatisch

über Gruppenrichtlinien vertrauen. Ubuntu habe ich das

CA-Zertifikat manuell in den Trust-Store gelegt und danach die

Zertifikatsprüfung der LDAP-Verbindung wieder aktiviert.



### Abnahmetest



Zum Schluss habe ich mich von CL01 aus als sara.bennani

angemeldet und bin auf https://cloud.ad.atlas-rhein.de gegangen.

Der Browser zeigt das Schloss-Symbol ohne Warnung, und im Profil

erscheint der Name sara.bennani. Damit funktionieren

AD-Anmeldung, Verschlüsselung und Firewall-Weg aus der

Mitarbeiter-Zone zusammen.



### Probleme und Lösungen



| Problem | Ursache | Lösung |
|---|---|---|
| Entpacken von Nextcloud schlug fehl | bzip2 fehlt im minimalen Ubuntu-Server-Image | Paket bzip2 nachinstalliert |
| LDAP-Bind: "Strong(er) authentication required" | Windows Server 2025 verlangt signierte bzw. verschlüsselte LDAP-Verbindungen | Enterprise-CA installiert, Anbindung auf LDAPS (636) umgestellt |
| LDAP-Wizard überschrieb den Benutzerfilter | FilterMode 0: GUI regeneriert den Filter bei jedem Tab-Besuch | FilterMode 1 gesetzt, Filter per occ fixiert |
| Benutzerzähler zeigte dauerhaft 0 | Fehler im Zähler-Widget der GUI | Funktion per occ ldap:search verifiziert (20 Konten), Widget als kosmetisch eingestuft |
| Apache startete nicht | Zertifikatsdatei war leer (Paste in der Basiskonsole fehlgeschlagen) | Zertifikat per SSH erneut eingefügt, Prüfroutine etabliert |
| Zertifikat unlesbar | Doppelte Base64-Kodierung (certutil -encode auf bereits PEM-formatierte certreq-Ausgabe) | Innere Schicht per base64 -d extrahiert |



Bei der LDAP-Diagnose habe ich unterhalb von Nextcloud direkt mit

ldapsearch getestet: Das AD lieferte alle 20 Konten, also lag der

Fehler in Nextcloud selbst. Konfiguriert habe ich danach per

occ-Kommandozeile statt über die GUI, weil der Wizard eigene

Werte überschreibt. Der defekte Zähler war rein kosmetisch; die

Funktion war nachweislich intakt.



### Prüfpunkte (Checkpoints)



| VM | Name | Zeitpunkt |
|---|---|---|
| SRV-LX01 | SRVLX01-grundinstallation | nach Ubuntu-Setup |
| SRV-LX01 | SRVLX01-nextcloud-basis | nach Nextcloud-Einrichtung |
| SRV-LX01 | SRVLX01-ldap | nach LDAPS-Anbindung |
| SRV-LX01 | SRVLX01-woche4-abschluss | nach HTTPS und Abnahmetest |





## Woche 5: Datensicherung und Monitoring



### Übersicht



| Datum | Arbeitsschritt |
|---|---|
| 19.07.2026 | Veeam installiert, Agent-basierte Sicherung eingerichtet |
| 20.07.2026 | Backup-Job und Wiederherstellungstest durchgeführt |
| 21.07.2026 | MON01 erstellt, CheckMK-Monitoring eingerichtet |
| 21.07.2026 | Alarmtest durchgeführt |



### Datensicherung nach dem 3-2-1-Prinzip



Für die Datensicherung habe ich Veeam Backup \& Replication

installiert. Eine hostbasierte Sicherung der virtuellen Maschinen

war nicht möglich, da der Hyper-V-Host unter Windows 11 (Client)

läuft und Veeam dies nur auf Windows Server unterstützt. Deshalb

habe ich stattdessen die Agent-basierte Sicherung gewählt: Auf

jedem Server läuft ein Veeam-Agent, der über den zentralen

Veeam-Server verwaltet wird. Gesichert werden die drei Server

DC01, FS01 und SRV-LX01; CL01 wird nicht gesichert, da ein Client

im Fehlerfall einfach neu installiert und der Domäne wieder

hinzugefügt werden kann. Nach dem 3-2-1-Prinzip gibt es drei

Kopien der Daten auf zwei Medientypen, davon eine Kopie an einem

externen Ort: das Original auf den produktiven Festplatten, die

Sicherung im Veeam-Repository und eine Offsite-Kopie, die im Labor

durch einen zweiten Ordner (stellvertretend für eine externe

Festplatte) simuliert wird. Die Firewall FW01 wird zusätzlich als

Konfigurationsdatei gesichert, da eine Firewall nicht als Abbild,

sondern über ihre Konfiguration gesichert wird.



### Wiederherstellungstest



Ein Backup ohne Test ist wertlos, deshalb habe ich die

Wiederherstellung geprüft. Ich habe eine Testdatei auf dem

Laufwerk G: gelöscht und sie anschließend über Veeam aus dem

Backup von FS01 wiederhergestellt. Danach war die Datei wieder

vorhanden – die Sicherung ist damit nachweislich funktionsfähig.



### Monitoring mit CheckMK



Für das Monitoring habe ich die neue VM MON01 (Ubuntu Server)

erstellt und CheckMK installiert. Ich habe drei Hosts eingebunden:

DC01, FS01 und SRV-LX01. Auf jedem Host läuft ein Agent, der die

Daten über den Port 6556 an den Monitoring-Server sendet. Die

Windows-Agenten mussten sich zusätzlich per TLS beim Server

registrieren, bevor sie ihre Dienstdaten übermittelten.



### Alarmtest



Monitoring beweist man nicht durch grüne Anzeigen, sondern durch

einen erkannten Fehler. Ich habe auf SRV-LX01 einen überwachten

Dienst gestoppt, und CheckMK hat den Ausfall innerhalb von

Sekunden als CRIT (kritisch) angezeigt. Nachdem ich den Dienst

wieder gestartet hatte, wechselte der Status automatisch zurück

auf OK – der vollständige Zyklus aus Ausfall, Erkennung und

Behebung war damit nachgewiesen.



### Probleme und Lösungen



| Problem | Ursache | Lösung |
|---|---|---|
| Dienst VeeamNFSSvc startete bei der Installation nicht | Ein Drittanbieter-Virenscanner blockierte den Dienststart | Smart App Control deaktiviert, Veeam-Ordner in die Ausnahmeliste aufgenommen, Neustart |
| Hostbasierte Sicherung nicht möglich | Der Hyper-V-Host läuft unter Windows 11 (Client), nicht Windows Server | Umstellung auf Agent-basierte Sicherung |
| SSH-Anmeldung von SRV-LX01 in Veeam schlug fehl | SSH-Dienst- und Firewall-Zustand auf dem Ubuntu-Server | SSH-Dienst und Firewall korrigiert, danach wurde die Verbindung erfolgreich hergestellt |
| SRV-LX01 ließ sich nicht als Agent sichern | Konflikt zwischen der Snapshot-Methode und Secure Boot | Secure Boot für diese VM deaktiviert, Agent-Sicherung getrennt eingerichtet |
| CheckMK-Paket ließ sich nicht installieren | Falsche Ubuntu-Version des Pakets (noble/24.04 statt resolute/26.04); zudem lieferte der Download nur eine HTML-Seite statt der .deb-Datei | Passendes Paket über DC01 heruntergeladen und per PowerShell/SCP auf SRV-LX01 übertragen |
| Windows-Agenten sendeten keine Dienstdaten | Die Agenten waren erreichbar, aber nicht per TLS am Server registriert | Agenten mit cmk-agent-ctl registriert und Port 6556 in der Firewall freigegeben |



Bei den Windows-Agenten habe ich die Ursache schrittweise

eingegrenzt: Der Agent war per telnet auf Port 6556 erreichbar,

sendete aber nur wenige Bytes statt der erwarteten Dienstdaten.

Das zeigte, dass nicht die Verbindung, sondern die fehlende

TLS-Registrierung das Problem war. Nach der Registrierung

lieferten beide Windows-Hosts ihre Dienste vollständig.



### Prüfpunkte (Checkpoints)



| VM | Name | Zeitpunkt |
|---|---|---|
| MON01 | MON01-grundinstallation | nach Ubuntu-Setup |
| MON01 | MON01-woche5-abschluss | nach CheckMK und Alarmtest |



## Woche 6: Abnahmetests und Abschluss



Im Rahmen der Abnahmetests wurde die Gäste-Zone mit einem

Testgerät geprüft. Dabei zeigte sich, dass die Zone zwar

vollständig isoliert war, aber auch keinen Internetzugang hatte,

da für die Schnittstelle GAESTE noch keine Firewall-Regeln

existierten. Deshalb habe ich das Regelwerk vervollständigt: zwei

Block-Regeln verhindern den Zugriff auf die Server- und die

Mitarbeiter-Zone, eine nachgelagerte Pass-Regel erlaubt den

Internetzugang. Die Reihenfolge ist entscheidend, da OPNsense die

Regeln von oben nach unten nach dem ersten Treffer auswertet. Der

anschließende Test bestätigte das gewünschte Verhalten: interne

Systeme waren nicht erreichbar, der Internetzugang funktionierte.

