# 🚀 Ubuntu Deployment Guide

## Why This Approach is Perfect for Interviews

**Docker Hub + Docker Compose** demonstrates:
- ✅ **Professional deployment practices** - Industry standard
- ✅ **Infrastructure as Code** - Reproducible deployments  
- ✅ **Containerization expertise** - Modern DevOps skills
- ✅ **Security awareness** - Firewall rules, VPN-only access
- ✅ **Automation** - Scripts for consistent setup

## Prerequisites

- Ubuntu 22.04+ server with public IP
- SSH access to the server
- Docker Hub account (free)

## 🐳 Step 1: Build and Push to Docker Hub

### On your local machine:

```bash
# Login to Docker Hub
docker login

# Build the image
cd app
docker build -t yourusername/vpn-dashboard:latest .

# Push to Docker Hub
docker push yourusername/vpn-dashboard:latest
```

### Update docker-compose.yml:
Replace `build: ./app` with:
```yaml
dashboard:
  image: yourusername/vpn-dashboard:latest
  # ... rest of config
```

## 🖥️ Step 2: Deploy on Ubuntu Server

### SSH to your server:
```bash
ssh user@your-server-ip
```

### Clone and deploy:
```bash
# Clone your repo
git clone https://github.com/yourusername/vpn-protected-dashboard.git
cd vpn-protected-dashboard

# Set your server's public IP
export SERVERURL=your-server-ip

# Deploy services
./deploy.sh
```

## 🛡️ Step 3: Configure Firewall

```bash
# Run as root (sudo)
sudo ./setup-firewall.sh
```

## 📱 Step 4: Test VPN Access

### Get client config:
```bash
cat wireguard/config/peer1/peer1.conf
```

### On your device:
1. Install WireGuard app
2. Import the config
3. Connect to VPN
4. Test: `curl http://10.8.0.1:5000`

## 🔍 Verification Commands

```bash
# Check service status
docker-compose ps

# Check WireGuard status
docker exec wireguard wg show

# Check firewall rules
sudo ufw status numbered

# Test dashboard access (should fail from public internet)
curl http://your-server-ip:5000

# Test VPN access (should work when connected)
curl http://10.8.0.1:5000
```

## 📊 What This Demonstrates

### Technical Skills:
- **Docker & Containerization** - Professional deployment
- **Networking** - VPN setup, firewall configuration
- **Security** - Access control, subnet isolation
- **Automation** - Deployment scripts, Docker Compose
- **Monitoring** - Health checks, service status

### Interview Talking Points:
- "I containerized the Flask app for reproducible deployments"
- "Used Docker Compose for multi-service orchestration"
- "Implemented UFW firewall rules to restrict dashboard access to VPN subnet only"
- "WireGuard provides encrypted tunnel with minimal overhead"
- "Health checks ensure service reliability"

## 🚨 Troubleshooting

### Common Issues:
1. **Port 5000 blocked**: Check UFW rules
2. **WireGuard not starting**: Ensure kernel modules are loaded
3. **Client can't connect**: Verify SERVERURL in docker-compose.yml

### Debug Commands:
```bash
# Check logs
docker-compose logs dashboard
docker-compose logs wireguard

# Check network
docker network ls
docker network inspect vpn-protected-dashboard_vpn-network
```

## 🎯 Production Considerations

- **Monitoring**: Add Prometheus/Grafana
- **Backups**: Volume persistence for WireGuard configs
- **SSL**: Reverse proxy with Let's Encrypt
- **Scaling**: Load balancer for multiple dashboard instances
- **Security**: Regular key rotation, audit logging

---

**This deployment shows enterprise-level DevOps practices that any employer would value!** 🎉
