#!/bin/bash

# ===========================================
#           SHADOWRECON v1.0 🔍
#      Red Team Reconnaissance Toolkit
# ===========================================

# Author  : bruhh 🧠⚔️
# Purpose : Bash-based OSINT & Recon automation for red teamers and bounty hunters.
# Repo    : https://github.com/your-shadowrecon-lair
# ===========================================

# === CONFIG ===
MODULES_DIR="modules"
LOOT_DIR="loot"

# === FUNCTIONS ===

prep_loot() {
    target=$1
    mkdir -p "$LOOT_DIR/$target"
    echo "[*] Target set: $target"
    echo "[*] Loot folder: $LOOT_DIR/$target"
}

run_modules() {
    echo "[*] Running recon modules..."
    bash "$MODULES_DIR/subdomains.sh" "$target"
    bash "$MODULES_DIR/emails.sh" "$target"
    bash "$MODULES_DIR/wayback.sh" "$target"
    bash "$MODULES_DIR/techstack.sh" "$target"
    bash "$MODULES_DIR/githubleaks.sh" "$target"
    bash "$MODULES_DIR/pdfmeta.sh" "$target"
    bash "$MODULES_DIR/report.sh" "$target"
    echo "[✓] Recon complete. Report generated."
}

# === START ===

clear
echo "═══════════════════════════════════════"
echo "        SHADOWRECON v1.0 🔥"
echo "  OSINT. Recon. Loot. Dominate. 💀"
echo "═══════════════════════════════════════"
echo

read -p "[?] Enter target domain (example.com): " target
prep_loot "$target"
run_modules "$target"
