#!/bin/bash
# Databases from https://github.com/sapics/ip-location-db

mkdir -p /usr/share/xt_geoip/tmp/
wget -P /usr/share/xt_geoip/tmp/ https://cdn.jsdelivr.net/npm/@ip-location-db/geo-whois-asn-country/geo-whois-asn-country-ipv4.csv
wget -P /usr/share/xt_geoip/tmp/ https://cdn.jsdelivr.net/npm/@ip-location-db/geo-whois-asn-country/geo-whois-asn-country-ipv6.csv
wget -P /usr/share/xt_geoip/tmp/ https://cdn.jsdelivr.net/npm/@ip-location-db/iptoasn-country/iptoasn-country-ipv4.csv
wget -P /usr/share/xt_geoip/tmp/ https://cdn.jsdelivr.net/npm/@ip-location-db/iptoasn-country/iptoasn-country-ipv6.csv
wget -P /usr/share/xt_geoip/tmp/ https://cdn.jsdelivr.net/npm/@ip-location-db/dbip-country/dbip-country-ipv4.csv
wget -P /usr/share/xt_geoip/tmp/ https://cdn.jsdelivr.net/npm/@ip-location-db/dbip-country/dbip-country-ipv6.csv
wget -P /usr/share/xt_geoip/tmp/ https://cdn.jsdelivr.net/npm/@ip-location-db/geolite2-country/geolite2-country-ipv4.csv
wget -P /usr/share/xt_geoip/tmp/ https://cdn.jsdelivr.net/npm/@ip-location-db/geolite2-country/geolite2-country-ipv6.csv
cd /usr/share/xt_geoip/tmp/
cat * > geoip.csv
sort -u geoip.csv -o /usr/share/xt_geoip/dbip-country-lite.csv
rm -r /usr/share/xt_geoip/tmp/
/usr/lib/xtables-addons/xt_geoip_build -D /usr/share/xt_geoip/ -S /usr/share/xt_geoip/
rm /usr/share/xt_geoip/dbip-country-lite.csv
