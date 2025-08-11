#!/bin/bash
set -e

echo "🚀 Deploying VPN-Protected Dashboard on Ubuntu..."

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo "❌ This script should not be run as root. Please run as a regular user with sudo access."
   exit 1
fi

# Check if SERVERURL is set
if [[ -z "$SERVERURL" ]]; then
    echo "❌ Please set SERVERURL environment variable:"
    echo "   export SERVERURL=your-server-ip-or-domain"
    exit 1
fi

echo "✅ Server URL: $SERVERURL"

# Install Docker if not present
if ! command -v docker &> /dev/null; then
    echo "📦 Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    echo "✅ Docker installed. Please log out and back in, then run this script again."
    exit 0
fi

# Install Docker Compose if not present
if ! command -v docker-compose &> /dev/null; then
    echo "📦 Installing Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# Create .env file
echo "📝 Creating .env file..."
cat > .env << EOF
SERVERURL=$SERVERURL
EOF

# Start services
echo "🐳 Starting services with Docker Compose..."
docker-compose up -d

# Wait for services to be ready
echo "⏳ Waiting for services to be ready..."
sleep 10

# Check service status
echo "📊 Service status:"
docker-compose ps

# Show WireGuard status
echo "🔐 WireGuard status:"
docker exec wireguard wg show

echo ""
echo "✅ Deployment complete!"
echo ""
echo "🌐 Dashboard: http://$SERVERURL:5000"
echo "🔐 WireGuard: $SERVERURL:51820"
echo ""
echo "📱 Client configs available in: ./wireguard/config/"
echo "📋 Next steps:"
echo "   1. Copy client config from ./wireguard/config/peer1/peer1.conf"
echo "   2. Import into WireGuard app on your device"
echo "   3. Connect and test: curl http://10.8.0.1:5000"
echo ""
echo "🛡️  Firewall rules will be applied next..."
