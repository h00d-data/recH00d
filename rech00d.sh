#!/bin/bash

# ============================
# RecH00D - Domain Recognition
# ============================

if [[ -z "$1" ]]; then
  echo "Usage: $0 domain.com"
  exit 1
fi

DOMAIN=$1
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTPUT_DIR="output/$DOMAIN-$TIMESTAMP"

mkdir -p "$OUTPUT_DIR"

echo "[+] Starting reconnaissance on $DOMAIN"
echo "[+] Output directory: $OUTPUT_DIR"

echo "[+] Running Findomain..."
findomain -t "$DOMAIN" -q > "$OUTPUT_DIR/findomain.txt"

echo "[+] Running Assetfinder..."
assetfinder --subs-only "$DOMAIN" > "$OUTPUT_DIR/assetfinder.txt"

echo "[+] Running Subfinder..."
subfinder -d "$DOMAIN" -silent > "$OUTPUT_DIR/subfinder.txt"

echo "[+] Running Amass (passive)..."
amass enum -passive -d "$DOMAIN" -o "$OUTPUT_DIR/amass.txt"

echo "[+] Merging results..."
cat "$OUTPUT_DIR"/*.txt | sort -u > "$OUTPUT_DIR/all_subdomains.txt"

echo "[+] Resolving domains..."
cat "$OUTPUT_DIR/all_subdomains.txt" | dnsx -silent > "$OUTPUT_DIR/resolved_subdomains.txt"

echo "[+] Recon finished!"
echo "[+] Total subdomains: $(wc -l < "$OUTPUT_DIR/all_subdomains.txt")"
echo "[+] Resolved subdomains: $(wc -l < "$OUTPUT_DIR/resolved_subdomains.txt")"
