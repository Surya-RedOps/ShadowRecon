#!/bin/bash

# ===========================================
# 🔍 Subdomain Enumerator (ShadowRecon Module)
# ===========================================

target=$1
out="loot/$target/subdomains.txt"
wordlist="wordlists/subdomains.txt"

echo "[*] [Subdomain] Enumerating for $target..."
mkdir -p loot/$target
> $out

# === crt.sh ===
echo "[*] [+] Gathering from crt.sh..."
curl -s "https://crt.sh/?q=%25.$target&output=json" | \
  grep -oP '"common_name":"\K[^"]+' | \
  sed 's/\\n/\n/g' | \
  sort -u >> $out

# === RapidDNS.io ===
echo "[*] [+] Gathering from rapiddns.io..."
curl -s "https://rapiddns.io/subdomain/$target?full=1" | \
  grep -oP "href=\"http[s]?://[^\"']+" | \
  cut -d '/' -f3 >> $out

# === Bruteforce ===
echo "[*] [+] Bruteforcing with $wordlist..."
while read sub; do
    full="$sub.$target"
    ip=$(host "$full" | grep "has address" | awk '{print $1}')
    [[ ! -z "$ip" ]] && echo "$full" >> $out
done < $wordlist

# === Final Output ===
sort -u $out -o $out
echo "[✓] Subdomain enumeration complete."
echo "[+] Found $(wc -l < $out) subdomains."
echo "[+] Saved to $out"
