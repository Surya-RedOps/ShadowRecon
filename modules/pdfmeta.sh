#!/bin/bash

# ===========================================
# 📂 Metadata Extractor (ShadowRecon Module)
# ===========================================

target=$1
out="loot/$target/metadata.txt"
mkdir -p loot/$target
> $out

echo "[*] [Metadata] Extracting metadata from public files for $target..."

# === Grab PDF/DOC files from Wayback archive ===
urls="loot/$target/wayback_urls.txt"
meta_files="loot/$target/public_docs/"
mkdir -p "$meta_files"

echo "[*] [+] Looking for downloadable files (.pdf, .docx)..."
grep -Ei '\.pdf|\.docx|\.doc|\.xls|\.xlsx' "$urls" | while read url; do
    fname=$(basename "$url" | cut -d '?' -f1)
    curl -s "$url" -o "$meta_files/$fname"
done

# === Extract metadata using exiftool ===
echo "[*] [+] Running exiftool on downloaded files..."
for file in "$meta_files"/*; do
    [[ -f "$file" ]] || continue
    echo "File: $(basename $file)" >> $out
    exiftool "$file" | grep -E 'Author|Creator|Producer|Title|Created|Modified|Company|Manager|Email|Username' >> $out
    echo "-----------------------------" >> $out
done

echo "[✓] Metadata extraction complete."
echo "[+] Saved to $out"
