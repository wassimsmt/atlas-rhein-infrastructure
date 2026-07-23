# Testprotokoll



Dieses Dokument enthält das Testprotokoll der Abnahmetests für die

gesamte IT-Infrastruktur der Atlas-Rhein Handel GmbH. Geprüft wird,

ob die im Soll-Konzept festgelegten Anforderungen aus den Bereichen

Netzwerk, Active Directory, Dateiserver, Cloud-Speicher,

Datensicherung und Monitoring tatsächlich erfüllt werden.



| Nr. | Testfall | Erwartetes Ergebnis | Tatsächliches Ergebnis | Status |
|---|---|---|---|---|
| 1 | DHCP in der Mitarbeiter-Zone: Ein Client in der Mitarbeiter-Zone wird gestartet und bezieht automatisch eine IP-Adresse per DHCP. | Der Client erhält eine IP-Adresse aus dem Bereich 10.10.20.100 bis 10.10.20.200. | Der Client erhielt automatisch die IP-Adresse 10.10.20.100 aus dem DHCP-Bereich (siehe w6-01). | OK |
| 2 | Interne DNS-Auflösung: Von einem Client aus wird der Name dc01.ad.atlas-rhein.de aufgelöst. | Der Name dc01.ad.atlas-rhein.de wird korrekt zu 10.10.10.10 aufgelöst. | Der Name dc01.ad.atlas-rhein.de wurde korrekt zu 10.10.10.10 aufgelöst. | OK |
| 3 | Domänenanmeldung: Anmeldung am Client CL01 mit dem Domänenkonto sara.bennani. | Die Anmeldung ist erfolgreich, die Benutzerin wird an der Domäne angemeldet. | Die Anmeldung als sara.bennani war erfolgreich. | OK |
| 4 | Laufwerk G:: Nach der Anmeldung als sara.bennani wird geprüft, ob das Abteilungslaufwerk automatisch verbunden wird. | Das Laufwerk G: wird automatisch mit dem Abteilungsordner Vertrieb verbunden. | Das Laufwerk G: wurde automatisch mit dem Abteilungsordner Vertrieb verbunden. | OK |
| 5 | Laufwerk T:: Nach der Anmeldung wird geprüft, ob das gemeinsame Austauschlaufwerk automatisch verbunden wird. | Das Laufwerk T: wird automatisch mit dem Ordner Austausch verbunden. | Das Laufwerk T: wurde automatisch mit dem Ordner Austausch verbunden. | OK |
| 6 | NTFS-Recht (positiv): Als sara.bennani wird versucht, im eigenen Abteilungsordner (Vertrieb) eine Testdatei zu erstellen. | Die Testdatei kann im eigenen Abteilungsordner erstellt werden. | Als sara.bennani konnte eine Testdatei im eigenen Abteilungsordner erstellt werden. | OK |
| 7 | NTFS-Recht (negativ): Als sara.bennani wird versucht, auf den Ordner der Abteilung Buchhaltung zuzugreifen. | Der Zugriff auf den fremden Abteilungsordner wird verweigert. | Der Zugriff auf den Ordner der Buchhaltung wurde verweigert (siehe w6-02). | OK |
| 8 | Lokale Administratorrechte: Als Standardbenutzerin wird versucht, ein Terminal oder eine Anwendung mit Administratorrechten zu öffnen. | Der Vorgang scheitert, da die Benutzerin durch die GPO keine lokalen Administratorrechte mehr besitzt. | Der Versuch, ein Terminal mit Administratorrechten zu öffnen, wurde blockiert (siehe w6-03). | OK |
| 9 | Gäste-Isolation: Von einem Gerät in der Gäste-Zone wird versucht, auf ein System in der Server- oder Mitarbeiter-Zone zuzugreifen. | Der Zugriff wird verweigert, die Gäste-Zone ist vollständig von den internen Netzen isoliert. | Ein Testgerät in der Gäste-Zone (10.10.30.150) konnte DC01 und FS01 nicht erreichen, hatte aber Internetzugang (siehe w6-06). | OK |
| 10 | Cloud-Anmeldung: Anmeldung bei Nextcloud mit dem Domänenkonto sara.bennani. | Die Anmeldung ist erfolgreich, im Profil erscheint der Benutzername sara.bennani. | Die Anmeldung bei Nextcloud mit dem Domänenkonto sara.bennani war erfolgreich (siehe w6-04). | OK |
| 11 | HTTPS: Aufruf der Cloud-Adresse über HTTPS und Prüfung des Zertifikats im Browser eines Domänenmitglieds. | Die Cloud ist über HTTPS erreichbar, das Zertifikat wird als gültig angezeigt, es erscheint keine Zertifikatswarnung. | Die Cloud war über HTTPS erreichbar, das Zertifikat wurde als gültig angezeigt, ohne Warnung. | OK |
| 12 | Backup vorhanden: Prüfung im Veeam-Server, ob für die gesicherten Server Wiederherstellungspunkte vorhanden sind. | Für DC01, FS01 und SRV-LX01 sind jeweils Wiederherstellungspunkte im Repository vorhanden. | Für DC01, FS01 und SRV-LX01 waren Wiederherstellungspunkte im Repository vorhanden (siehe w5-01). | OK |
| 13 | Wiederherstellung: Eine Testdatei auf dem Laufwerk G: wird gelöscht und anschließend über Veeam aus dem Backup von FS01 wiederhergestellt. | Die gelöschte Datei ist nach der Wiederherstellung wieder vorhanden. | Die gelöschte Testdatei wurde aus dem Backup wiederhergestellt und war anschließend wieder vorhanden (siehe w5-02, w5-03). | OK |
| 14 | Monitoring: Prüfung im CheckMK-Webinterface, ob alle überwachten Hosts erreichbar sind. | DC01, FS01 und SRV-LX01 werden alle mit dem Status UP angezeigt. | DC01, FS01 und SRV-LX01 wurden alle mit dem Status UP angezeigt (siehe w6-05). | OK |
| 15 | Alarmierung: Ein überwachter Dienst auf SRV-LX01 wird gestoppt, und die Reaktion von CheckMK wird beobachtet. | CheckMK erkennt den Ausfall und zeigt den Dienst als CRIT (kritisch) an. | CheckMK erkannte den gestoppten Dienst innerhalb weniger Sekunden und zeigte ihn als CRIT an (siehe w5-06). | OK |
