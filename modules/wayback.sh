#!/bin/bash

# ===========================================
# 🕳️ Wayback Scraper (ShadowRecon Module)
# ===========================================

target=$1
out="loot/$target/wayback_urls.txt"
js_out="loot/$target/js_files.txt"
endpoints_out="loot/$target/js_endpoints.txt"
mkdir -p loot/$target
> $out
> $js_out
> $endpoints_out

echo "[*] [Wayback] Scraping archived URLs for $target..."

# === Pull all URLs from Wayback Machine ===
curl -s "http://web.archive.org/cdx/search/cdx?url=*.$target/*&output=text&fl=original&collapse=urlkey" >> $out

sort -u $out -o $out
echo "[+] Archived URLs saved to $out"

# === Extract JS files ===
grep "\.js" $out | grep -Ev "\.json|jquery" | sort -u >> $js_out
echo "[+] JS files saved to $js_out"

# === Extract parameters/endpoints from JS links ===
grep -Eo "https?://[^ ]+" $js_out | while read url; do
    curl -s "$url" | grep -Eo "[a-zA-Z0-9_]+=" >> $endpoints_out
done

sort -u $endpoints_out -o $endpoints_out
echo "[✓] Wayback scraping complete."
echo "[+] Found $(wc -l < $js_out) JS files"
echo "[+] Found $(wc -l < $endpoints_out) parameter-looking endpoints"
