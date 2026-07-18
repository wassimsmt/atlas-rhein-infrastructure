#!/bin/bash
# Nextcloud-Installation auf SRV-LX01 (Ubuntu Server 26.04)
# Dokumentierte Befehlssammlung Woche 4 - als Referenz, nicht als
# unbeaufsichtigtes Skript gedacht: Passwoerter und Zertifikate
# erfordern manuelle Schritte (siehe Kommentare).
#
# Netzwerk (im Installer gesetzt): 10.10.10.20/24, GW 10.10.10.1,
# DNS 10.10.10.10, Suchdomaene ad.atlas-rhein.de

# --- 1. System und Grundpakete ---
sudo apt update && sudo apt upgrade -y
sudo apt install -y qemu-guest-agent bzip2 ldap-utils
# Lektion: bzip2 fehlt im minimalen Ubuntu-Server-Image

# --- 2. LAMP-Stack ---
sudo apt install -y apache2 mariadb-server libapache2-mod-php php php-mysql php-xml php-zip php-curl php-gd php-mbstring php-intl php-bcmath php-gmp php-imagick php-ldap

# --- 3. Datenbank (interaktiv: Passwort ersetzen) ---
# sudo mariadb
#   CREATE DATABASE nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
#   CREATE USER 'nextcloud'@'localhost' IDENTIFIED BY 'DB_PASSWORT';
#   GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'localhost';
#   FLUSH PRIVILEGES;

# --- 4. Nextcloud entpacken ---
cd /tmp
wget https://download.nextcloud.com/server/releases/latest.tar.bz2
sudo tar -xjf latest.tar.bz2 -C /var/www/
sudo chown -R www-data:www-data /var/www/nextcloud

# --- 5. Apache: Module und globaler ServerName ---
sudo a2enmod rewrite headers env dir mime ssl
echo "ServerName srv-lx01.ad.atlas-rhein.de" | sudo tee /etc/apache2/conf-available/servername.conf
sudo a2enconf servername

# --- 6. VirtualHosts ---
# /etc/apache2/sites-available/nextcloud-ssl.conf (Port 443 mit
# SSLCertificateFile /etc/ssl/certs/cloud.pem und
# SSLCertificateKeyFile /etc/ssl/private/cloud.key)
# plus Port-80-Redirect auf HTTPS - siehe Repo-Doku Woche 4.
# sudo a2ensite nextcloud-ssl.conf && sudo a2dissite 000-default.conf
# sudo apachectl configtest && sudo systemctl restart apache2

# --- 7. CA-Vertrauen (Atlas-Rhein-CA in Ubuntus Trust-Store) ---
# CA-PEM von DC01 nach /usr/local/share/ca-certificates/atlas-rhein-ca.crt
# sudo update-ca-certificates   # Erwartung: "1 added"
# Pruefung: echo | openssl s_client -connect dc01.ad.atlas-rhein.de:636 2>&1 | grep Verification
# Erwartung: "Verification: OK"

# --- 8. Server-Zertifikat (CSR erzeugen, auf DC01 signieren) ---
# sudo openssl req -new -newkey rsa:2048 -nodes \
#   -keyout /etc/ssl/private/cloud.key -out /tmp/cloud.csr \
#   -subj "/CN=cloud.ad.atlas-rhein.de" \
#   -addext "subjectAltName=DNS:cloud.ad.atlas-rhein.de,DNS:srv-lx01.ad.atlas-rhein.de"
# Auf DC01: certreq -submit -attrib "CertificateTemplate:WebServer" cloud.csr cloud.cer
# Achtung (Lektion): certreq liefert bereits PEM - NICHT erneut mit
# certutil -encode kodieren (sonst doppelte Base64-Kodierung).
# Pruefroutine nach jedem Zertifikat-Transfer:
#   sudo openssl x509 -noout -subject -in /etc/ssl/certs/cloud.pem
#   Modulus-Vergleich Zertifikat vs. Key (muss identisch sein)

# --- 9. LDAP-Anbindung (occ, nach GUI-Grundeinrichtung) ---
# Windows Server 2025 verlangt signierte/verschluesselte Binds -> LDAPS:636
sudo -u www-data php /var/www/nextcloud/occ ldap:set-config s01 ldapUserFilterMode 1
sudo -u www-data php /var/www/nextcloud/occ ldap:set-config s01 ldapUserFilter "(&(objectClass=user)(objectCategory=person))"
sudo -u www-data php /var/www/nextcloud/occ ldap:set-config s01 ldapUserDisplayName "displayName"
sudo -u www-data php /var/www/nextcloud/occ ldap:set-config s01 ldapExpertUsernameAttr "sAMAccountName"
sudo -u www-data php /var/www/nextcloud/occ ldap:set-config s01 turnOffCertCheck 0
# Verifikation: occ ldap:test-config s01 / occ ldap:search --max 25 ""