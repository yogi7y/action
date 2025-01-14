#!/bin/bash

# Exit on error
set -e

# Get IP address (macOS specific)
IP=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -n 1)
if [[ -z "$IP" ]]; then
    echo "Error: Could not determine IP address"
    exit 1
fi

echo "Found IP address: $IP"

# Update .env file - replace only the IP part
if [[ -f ".env" ]]; then
    echo "Updating .env..."
    sed -i.bak "s|//[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}|//${IP}|g" ".env"
    rm -f ".env.bak"
fi

# Update config.toml - replace only the IP part
CONFIG_FILE="supabase/config.toml"
if [[ -f "$CONFIG_FILE" ]]; then
    echo "Updating $CONFIG_FILE..."
    sed -i.bak "s|//[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}|//${IP}|g" "$CONFIG_FILE"
    rm -f "$CONFIG_FILE.bak"
fi

# Clean and rebuild generated files
echo "Cleaning generated files..."
rm -f "lib/src/core/env/env.g.dart"

echo "Running build_runner..."
fvm dart run build_runner build --delete-conflicting-outputs

echo "✅ Done! IP address ($IP) configured in .env and config.toml"