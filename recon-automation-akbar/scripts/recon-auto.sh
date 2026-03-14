#!/bin/bash

DOMAIN_LIST="input/domains.txt"
SUBDOMAIN_OUTPUT="output/all-subdomains.txt"
LIVE_HOST_OUTPUT="output/live.txt"

PROGRESS_LOG_FILE="logs/progress.log"
ERROR_LOG_FILE="logs/errors.log"

echo "Recon started at $(date)" | tee -a $PROGRESS_LOG_FILE

while read -r domain; do

    echo "[+] Starting enumeration for $domain" | tee -a $PROGRESS_LOG_FILE

    subfinder -d $domain -silent 2>>$ERROR_LOG_FILE \
    | anew $SUBDOMAIN_OUTPUT

done < $DOMAIN_LIST

echo "[+] Checking which hosts are alive..." | tee -a $PROGRESS_LOG_FILE

cat $SUBDOMAIN_OUTPUT \
| httpx -status-code -title -silent \
2>>$ERROR_LOG_FILE \
| tee $LIVE_HOST_OUTPUT

TOTAL_SUBDOMAINS=$(wc -l < $SUBDOMAIN_OUTPUT)
TOTAL_LIVE_HOSTS=$(wc -l < $LIVE_HOST_OUTPUT)

echo "[+] Total unique subdomains found : $TOTAL_SUBDOMAINS" | tee -a $PROGRESS_LOG_FILE
echo "[+] Total live hosts detected     : $TOTAL_LIVE_HOSTS" | tee -a $PROGRESS_LOG_FILE

echo "Recon finished at $(date)" | tee -a $PROGRESS_LOG_FILE
