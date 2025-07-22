#!/bin/bash

# ===========================================
# 🕵️ Email Harvester (ShadowRecon Module)
# ===========================================

target=$1
out="loot/$target/emails.txt"
tmp="loot/$target/tmp_emails.txt"
mkdir -p loot/$target
> $out
> $tmp

echo "[*] [Email] Harvesting emails for $target..."

# === Dorked Search (uses curl to hit Bing quietly) ===
echo "[*] [+] Bing dork: site:$target email pattern..."
curl -s -A "Mozilla/5.0" "https://www.bing.com/search?q=site:$target+email" \
  | grep -Eoi "[a-zA-Z0-9._%+-]+@$target" >> $tmp

# === Hunter.io (optional API key support later) ===
# echo "[*] [+] Hunter.io scan..."
# curl -s "https://api.hunter.io/v2/domain-search?domain=$target&api_key=$HUNTER_API" \
#   | jq -r '.data.emails[].value' >> $tmp

# === PDF/Wayback scraping later linked ===

# === Remove duplicates ===
sort -u $tmp -o $out
rm $tmp

count=$(wc -l < $out)
if [ "$count" -eq 0 ]; then
    echo "[!] No emails found."
else
    echo "[✓] Emails found: $count"
    echo "[+] Saved to $out"
fi
