# 🔐 GitHub Actions Setup Guide

## Prerequisites

1. **Docker Hub Account** (free)
2. **Ubuntu VM** with IP: `102.164.37.37`
3. **SSH Access** to the VM

## 🚀 Step 1: Set Up GitHub Secrets

### Go to your GitHub repository:
1. Navigate to `Settings` → `Secrets and variables` → `Actions`
2. Click `New repository secret`

### Add these secrets:

#### **DOCKER_USERNAME**
- **Name**: `DOCKER_USERNAME`
- **Value**: Your Docker Hub username

#### **DOCKER_PASSWORD**
- **Name**: `DOCKER_PASSWORD`
- **Value**: Your Docker Hub password or access token

#### **VM_SSH_KEY**
- **Name**: `VM_SSH_KEY`
- **Value**: Your private SSH key for the Ubuntu VM

## 🔑 Step 2: Generate SSH Key for VM

### On your Mac, generate SSH key:
```bash
ssh-keygen -t rsa -b 4096 -C "github-actions@vpn-dashboard"
# Save as: ~/.ssh/github_actions_vpn
# No passphrase needed
```

### Copy public key to Ubuntu VM:
```bash
# Copy the public key
cat ~/.ssh/github_actions_vpn.pub

# On Ubuntu VM, add to authorized_keys:
echo "YOUR_PUBLIC_KEY_HERE" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

### Test SSH connection:
```bash
ssh -i ~/.ssh/github_actions_vpn ubuntu@102.164.37.37
```

## 🐳 Step 3: Update Docker Image Name

### In `.github/workflows/deploy.yml`:
Replace `yourusername` with your actual Docker Hub username:
```yaml
env:
  DOCKER_IMAGE: yourusername/vpn-dashboard  # ← Change this
```

### In `docker-compose.yml`:
Replace `yourusername` with your actual Docker Hub username:
```yaml
dashboard:
  image: yourusername/vpn-dashboard:latest  # ← Change this
```

## 🚀 Step 4: Push and Deploy

### Commit and push your changes:
```bash
git add .
git commit -m "Add GitHub Actions CI/CD pipeline"
git push origin main
```

### Monitor deployment:
1. Go to `Actions` tab in your GitHub repo
2. Watch the workflow run
3. Check deployment logs

## ✅ Verification

### After successful deployment:
1. **Dashboard**: http://102.164.37.37:5000 (should be blocked from public)
2. **WireGuard**: 102.164.37.37:51820
3. **Get client config**: `ssh ubuntu@102.164.37.37 "cat ~/vpn-dashboard/wireguard/config/peer1/peer1.conf"`

## 🚨 Troubleshooting

### Common issues:
1. **SSH connection failed**: Check SSH key and VM firewall
2. **Docker Hub auth failed**: Verify username/password
3. **Port access denied**: Check VM firewall rules

### Debug commands:
```bash
# Check workflow logs in GitHub Actions
# Check VM logs:
ssh ubuntu@102.164.37.37 "docker-compose logs"
```

---

**🎉 Once set up, every push to main will automatically deploy to your VM!**
