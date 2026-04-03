#!/bin/bash

# Linux Security Hardening Script
# Checks basic security configurations

echo "===== SECURITY HARDENING CHECK ====="
echo ""

# Check 1: Firewall status
echo "[1] Checking firewall status..."
if command -v ufw &> /dev/null; then
    ufw status
else
    echo "UFW not installed"
fi
echo ""

# Check 2: Failed login attempts
echo "[2] Recent failed login attempts:"
if [ -f /var/log/auth.log ]; then
    grep "Failed password" /var/log/auth.log 2>/dev/null | tail -5
else
    echo "auth.log not found (may need sudo or different OS)"
fi
echo ""

# Check 3: Running services
echo "[3] Running services (first 5):"
systemctl list-units --type=service --state=running 2>/dev/null | head -6 || echo "Cannot list services"
echo ""

# Check 4: Open ports
echo "[4] Open network ports:"
ss -tuln 2>/dev/null | head -10 || netstat -tuln 2>/dev/null | head -10 || echo "Cannot check ports"
echo ""

# Check 5: Users with sudo access
echo "[5] Users with sudo privileges:"
if [ -f /etc/group ]; then
    grep -Po '^sudo.+:\K.*$' /etc/group 2>/dev/null || grep '^sudo:' /etc/group | cut -d: -f4
else
    echo "Cannot read /etc/group"
fi
echo ""

echo "===== CHECK COMPLETE ====="
