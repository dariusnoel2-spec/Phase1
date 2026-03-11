#!/bin/bash
# Hardnen Script
echo "Securing Files"

# Fix 
sudo chmod 640 /etc/shadow
sudo chmown root:shadow /etc/shadow

# Secure Vault
sudo chmod 700 ~/Vault


echo "Files Secured"
