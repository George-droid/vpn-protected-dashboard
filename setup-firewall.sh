#!/bin/bash
set -e

echo "🛡️  Setting up UFW firewall rules..."

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "❌ This script must be run as root (use sudo)"
   exit 1
fi

# Enable UFW
echo "📋 Configuring UFW firewall..."
ufw --force reset

# Default policies
ufw default deny incoming
ufw default allow outgoing

# Allow SSH (adjust port if needed)
ufw allow 22/tcp comment "SSH"

# Allow WireGuard
ufw allow 51820/udp comment "WireGuard VPN"

# Allow dashboard ONLY from VPN subnet
ufw allow from 10.8.0.0/24 to any port 5000 proto tcp comment "Dashboard (VPN only)"

# Enable UFW
ufw --force enable

echo "✅ Firewall configured successfully!"
echo ""
echo "📊 UFW Status:"
ufw status numbered

echo ""
echo "🔒 Security summary:"
echo "   • Port 22 (SSH): Open to all"
echo "   • Port 51820 (WireGuard): Open to all"
echo "   • Port 5000 (Dashboard): Only from VPN subnet (10.8.0.0/24)"
echo "   • All other incoming: Blocked"
echo ""
echo "🌐 Dashboard is now accessible:"
echo "   • Public internet: BLOCKED ❌"
echo "   • VPN clients (10.8.0.0/24): ALLOWED ✅"
echo ""
echo "📱 Test with VPN client:"
echo "   curl http://10.8.0.1:5000"
