#!/bin/bash
# Credit: https://ultramookie.com/2020/10/geoip-blocking-ubuntu-20.04/
# Credit: https://github.com/sapics/ip-location-db

MON=$(date +"%m")
YR=$(date +"%Y")


# Create temporary directory
mkdir -p /usr/share/xt_geoip/tmp/
mkdir -p /usr/share/xt_geoip/tmp/ip2loc/

# Download latest from db-ip.com
wget https://download.db-ip.com/free/dbip-country-lite-${YR}-${MON}.csv.gz -O /usr/share/xt_geoip/tmp/dbip-country-lite.csv.gz
gunzip /usr/share/xt_geoip/dbip-country-lite.csv.gz
rm /usr/share/xt_geoip/dbip-country-lite.csv.gz

# Download latest from ip2location and convert to ip address format
wget -P /usr/share/xt_geoip/tmp/ip2loc/ http://download.ip2location.com/lite/IP2LOCATION-LITE-DB1.CSV.ZIP
unzip -o /usr/share/xt_geoip/tmp/ip2loc/IP2LOCATION-LITE-DB1.CSV.ZIP -d /usr/share/xt_geoip/tmp/ip2loc/
php ~/ip2location-csv-converter.php -range /usr/share/xt_geoip/tmp/ip2loc/IP2LOCATION-LITE-DB1.CSV /usr/share/xt_geoip/tmp/IP2LOCATION-LITE-DB1.CSV

# Download latest from https://github.com/sapics/ip-location-db
wget -P /usr/share/xt_geoip/tmp/ https://cdn.jsdelivr.net/npm/@ip-location-db/geo-whois-asn-country/geo-whois-asn-country-ipv4.csv
wget -P /usr/share/xt_geoip/tmp/ https://cdn.jsdelivr.net/npm/@ip-location-db/geo-whois-asn-country/geo-whois-asn-country-ipv6.csv
wget -P /usr/share/xt_geoip/tmp/ https://cdn.jsdelivr.net/npm/@ip-location-db/iptoasn-country/iptoasn-country-ipv4.csv
wget -P /usr/share/xt_geoip/tmp/ https://cdn.jsdelivr.net/npm/@ip-location-db/iptoasn-country/iptoasn-country-ipv6.csv
wget -P /usr/share/xt_geoip/tmp/ https://cdn.jsdelivr.net/npm/@ip-location-db/dbip-country/dbip-country-ipv4.csv
wget -P /usr/share/xt_geoip/tmp/ https://cdn.jsdelivr.net/npm/@ip-location-db/dbip-country/dbip-country-ipv6.csv
wget -P /usr/share/xt_geoip/tmp/ https://cdn.jsdelivr.net/npm/@ip-location-db/geolite2-country/geolite2-country-ipv4.csv
wget -P /usr/share/xt_geoip/tmp/ https://cdn.jsdelivr.net/npm/@ip-location-db/geolite2-country/geolite2-country-ipv6.csv

# Combine all csv
cd /usr/share/xt_geoip/tmp/
cat *.csv > geoip.csv
sort -u geoip.csv -o /usr/share/xt_geoip/dbip-country-lite.csv

# Remove temp directory and update geoip xtables
rm -r /usr/share/xt_geoip/tmp/
/usr/lib/xtables-addons/xt_geoip_build -D /usr/share/xt_geoip/ -S /usr/share/xt_geoip/
rm /usr/share/xt_geoip/dbip-country-lite.csv

# reload ufw
ufw reload
