#!/bin/bash

# ===========================================
# 🐙 GitHub Leak Finder (ShadowRecon Module)
# ===========================================

target=$1
out="loot/$target/github_leaks.txt"
mkdir -p loot/$target
> $out

echo "[*] [GitHub] Scanning GitHub for possible leaks related to $target..."

# === GitHub Dorking via Web Search (no API needed) ===
dorks=(
  "org:$target"
  "$target filename:.env"
  "$target filename:.git-credentials"
  "$target filename:config.json"
  "$target password"
  "$target AWS_SECRET_ACCESS_KEY"
  "$target filename:.htpasswd"
)

# Use Bing to bypass GitHub search limits
for dork in "${dorks[@]}"; do
  echo "[*] [+] Dork: $dork" >> $out
  curl -s -A "Mozilla/5.0" "https://www.bing.com/search?q=site:github.com+${dork// /+}" \
    | grep -Eo "https://github\.com/[^\"]+" | sed 's/&.*//g' | sort -u >> $out
done

count=$(grep -c 'https://github.com' $out)

if [ "$count" -eq 0 ]; then
    echo "[!] No GitHub leaks found."
else
    echo "[✓] GitHub links found: $count"
    echo "[+] Saved to $out"
fi
