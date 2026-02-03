#!/bin/bash
#
# RECH00D.SH

DOMAIN=$1

if [ $# -eq 0 ]
  then
    echo "#### RECHOOD.SH ####"
    echo "------ by: H00D (https://github.com/h00d-data/recH00d)"
    echo "Usage: ./rechood.sh domain.com"
    echo ""
else
    echo "### RECH00D.SH STARTING ###"
    echo "> You can go for lunch or dinner, it will take a while! :P"
    assetfinder -subs-only $DOMAIN  > domains_asset
    echo "[+] assetfinder finish! Next..."
    cat domains_asset | ~/go/bin/waybackurls  > urls.txt
    echo "[+] waybackurls finish! Next..."
    amass enum -d $DOMAIN -passive  > domains_amass_passive
    echo "[+] amass recon finish! Next..."
    amass enum -d $DOMAIN -active -brute -w /usr/share/seclists/Discovery/DNS/deepmagic.com-prefixes-top50000.txt  > domains_amass_active
    echo "[+] amass brute force finish! Next..."
    subfinder -d $DOMAIN  > domains_sub
    echo "[+] subfinder recon finish! Next..."
    findomain -t $DOMAIN  > domains_find
    echo "[+] findomain recon finish! Next..."
    echo "$DOMAIN"  haktrails subdomains  > domains_hak
    cat domains*  > dominioTotal.txt
    amass enum -nf dominioTotal.txt -passive  > domains_amass_passive2
    amass enum -nf dominioTotal.txt -active -brute -w /usr/share/seclists/Discovery/DNS/deepmagic.com-prefixes-top50000.txt > domains_amass_active_2
    echo "[+] amass brute force 2 finish! Next..."
    cat domains_amass_passive2 domains_amass_active_2  > domainsTotal2
    cat domainsTotal2  haktrails subdomains  > domains_hak2
    cat dominioTotal.txt domainsTotal2 domains_hak2  > webTotal
    echo "> Finish!"

fi
