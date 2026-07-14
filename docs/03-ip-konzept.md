\# IP-Konzept: Atlas-Rhein Handel GmbH



\## Netzwerkzonen



| Zone | Netz | Gateway | Zweck |

|---|---|---|---|

| Server | 10.10.10.0/24 | 10.10.10.1 | Alle Server, nur statische Adressen |

| Mitarbeiter | 10.10.20.0/24 | 10.10.20.1 | Arbeitsplätze, Adressen per DHCP |

| Gäste | 10.10.30.0/24 | 10.10.30.1 | Gastgeräte, kein Zugriff auf interne Systeme |



\## Statische Adressen (Server-Zone)



| Host | Rolle | IP-Adresse |

|---|---|---|

| FW01 | Firewall (OPNsense) | 10.10.10.1 |

| DC01 | Domänencontroller, DNS, DHCP | 10.10.10.10 |

| FS01 | Dateiserver | 10.10.10.11 |

| SRV-LX01 | Nextcloud (Ubuntu Server) | 10.10.10.20 |

| MON01 | Monitoring, CheckMK (Ubuntu Server) | 10.10.10.30 |



\## DHCP-Bereiche



| Zone | Pool | Vergeben durch |

|---|---|---|

| Mitarbeiter | 10.10.20.100 bis 10.10.20.200 | DC01 |

| Gäste | 10.10.30.100 bis 10.10.30.200 | FW01 |



\## DNS



Alle internen Systeme verwenden DC01 (10.10.10.10) als DNS-Server.

Die Gäste-Zone verwendet einen öffentlichen DNS-Server, da Gäste

keine internen Namen auflösen dürfen.

