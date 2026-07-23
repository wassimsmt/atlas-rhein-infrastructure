# Fazit



## Erreichte Ziele



Alle im Soll-Konzept definierten Ziele wurden umgesetzt. Aufgebaut

wurde eine zentrale IT-Infrastruktur für ein Handelsunternehmen mit

20 Mitarbeitern: eine Firewall mit drei getrennten Netzwerkzonen,

eine Windows-Domäne mit zentraler Benutzerverwaltung und 20 per

Skript angelegten Konten, ein Dateiserver mit einem

Berechtigungskonzept nach dem AGDLP-Prinzip, ein Linux-Server mit

Nextcloud und Anmeldung über Active Directory (LDAPS), eine

Datensicherung nach dem 3-2-1-Prinzip mit erfolgreichem

Wiederherstellungstest sowie ein Monitoring aller Server mit

CheckMK. Auch das zentrale Sicherheitsziel wurde erreicht: Den

Mitarbeitern wurden per Gruppenrichtlinie die lokalen

Administratorrechte entzogen.



## Schwierigster Teil



Am anspruchsvollsten war die fünfte Woche (Datensicherung und

Monitoring). Bei der Sicherung musste ich das Konzept anpassen,

weil ein hostbasiertes Backup unter Windows 11 nicht möglich war,

und stattdessen auf eine Agent-basierte Lösung umstellen. Beim

Monitoring kostete mich ein Versionskonflikt des CheckMK-Pakets

und die fehlende TLS-Registrierung der Windows-Agenten Zeit. Diese

Probleme haben mich aber am meisten gelehrt, weil ich jeden Fehler

Schritt für Schritt eingrenzen musste.



## Gelerntes



Ich habe praktische Erfahrung mit Active Directory,

Netzwerksegmentierung, Berechtigungskonzepten, der Anbindung eines

Linux-Servers an eine Windows-Domäne, Datensicherung und

Monitoring gesammelt. Besonders wichtig war für mich die

Fehlersuche: aus einer Fehlermeldung die Ursache abzuleiten und

gezielt zu beheben, statt planlos vorzugehen. Außerdem habe ich

gelernt, jeden Arbeitsschritt sauber zu dokumentieren.



## Was ich anders machen würde



Bei einer Wiederholung würde ich die Umgebung größer aufbauen: mehr

Server und Clients, mehr Abteilungen mit jeweils eigenem Subnetz

und eigenen Berechtigungen. Außerdem würde ich für die Verwaltung

mehrere Administratorkonten mit gestaffelten Rechten einrichten,

damit die Vertretung im Ausfall eines Administrators klar geregelt

ist. So wäre die Infrastruktur noch näher an einem echten

Unternehmen mit mehreren Standorten.



## Ausblick



Für einen echten Produktivbetrieb wären als nächste Schritte

sinnvoll: ein zweiter Domänencontroller zur Ausfallsicherheit, ein

tatsächliches Offsite-Backup auf externer Hardware statt der

simulierten Kopie, gültige Zertifikate einer offiziellen

Zertifizierungsstelle sowie eine unterbrechungsfreie

Stromversorgung für die zentralen Systeme. In der Praxis würden

zudem alle Systeme dauerhaft laufen und rund um die Uhr überwacht.

Das Labor bildet die Grundlagen bereits vollständig ab und lässt

sich in diese Richtung erweitern.

