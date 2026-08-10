#!/bin/bash
# Hermes Security Audit — Quick Installer
# Run: curl -fsSL https://raw.githubusercontent.com/axelfreeman/hermes-security-audit/main/install.sh | bash

set -e

echo "🔒 Hermes Security Audit — Installer"
echo ""

# Find all Hermes profiles
HERMES_HOME="${HERMES_HOME:-$HOME/.hermes}"
if [ -d "$HERMES_HOME/profiles" ]; then
    PROFILES=$(ls "$HERMES_HOME/profiles/" 2>/dev/null | grep -v "^default$" | head -1)
    if [ -n "$PROFILES" ]; then
        PROFILE="$PROFILES"
    else
        PROFILE="default"
    fi
else
    PROFILE="default"
fi

SKILL_DIR="$HERMES_HOME/profiles/$PROFILE/skills/infrastructure/hermes-security-audit"

mkdir -p "$SKILL_DIR"
curl -fsSL https://raw.githubusercontent.com/axelfreeman/hermes-security-audit/main/SKILL.md -o "$SKILL_DIR/SKILL.md"

echo "✅ Installed to: $SKILL_DIR"
echo ""
echo "Try it: say 'проверь безопасность сервера' to your Hermes agent"
