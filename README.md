# VPN-Protected Internal Dashboard (WireGuard + Flask)

A minimal, **ready-to-run** demo proving VPN experience:
- Stand up **WireGuard** via Docker
- Run a tiny **Flask** app
- **Restrict access** so the app is reachable **only** over the VPN subnet

## Architecture
```
[ Client (WireGuard) ] --encrypted--> [ WireGuard Server (Docker) ] --local--> [ Flask App ]
VPN subnet: 10.8.0.0/24 (server 10.8.0.1)
App port: 5000 (UFW allows only from 10.8.0.0/24)
```
---

## Prerequisites
- Ubuntu 22.04+ VM with a public IP (or any Linux box)
- Docker + Docker Compose
- UFW firewall enabled (recommended)
- WireGuard client installed on your laptop/phone

## 1) Start the Flask app
```bash
cd app
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
python main.py
```
This listens on `0.0.0.0:5000` on the server. We will firewall it so only VPN clients can reach it.

## 2) Start WireGuard (Docker)
Edit `wireguard/docker-compose.yml` and set:
- `SERVERURL=<YOUR_PUBLIC_IP_OR_DNS>`
- `TZ=Africa/Lagos` (or your timezone)

Then run:
```bash
cd wireguard
docker compose up -d
```

This generates server keys and a **first client** config under `wireguard/config/peer1/peer1.conf`.

## 3) Lock down the firewall (UFW)
Allow the app only from the VPN subnet (10.8.0.0/24):
```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH and WireGuard:
sudo ufw allow 22/tcp
sudo ufw allow 51820/udp

# Allow Flask app ONLY from the VPN subnet
sudo ufw allow from 10.8.0.0/24 to any port 5000 proto tcp

sudo ufw enable
sudo ufw status
```

## 4) Connect a client (macOS/Windows/Linux/Android/iOS)
- Open the WireGuard app
- Import the config from: `wireguard/config/peer1/peer1.conf`
- Connect

**Test:**
```bash
# From the client (connected via VPN):
curl http://10.8.0.1:5000
```

You should see JSON from the Flask app. Disconnect VPN and the request will fail (as expected).

## 5) Helper scripts
Create additional clients and show status:
```bash
# From project root
./scripts/add-client.sh alice
./scripts/show-status.sh
```

> The new client config will appear under `wireguard/config/alice/alice.conf`.

---

## Demo Script (Talk Track)
1. Show repo + `docker-compose.yml` (why Docker: reproducibility, speed).
2. Show `ufw status` highlighting VPN-only rule for port 5000.
3. Connect WireGuard and request the app (`curl http://10.8.0.1:5000`).
4. Disconnect VPN and show it fails.
5. Add a new user via `./scripts/add-client.sh bob` and show the new config.
6. Show `./scripts/show-status.sh` to list connected peers.

---

## Production Considerations
- Put the Flask app behind a process manager or Docker
- Monitoring (`wg show`, Prometheus exporters)
- Key rotation/offboarding process
- Infrastructure as Code (Terraform/Ansible)
- Reverse proxy (Nginx/Caddy) bound to the VPN interface for TLS inside the tunnel

---

## Project Structure
```
vpn-protected-dashboard/
├─ app/
│  ├─ main.py
│  ├─ requirements.txt
├─ wireguard/
│  ├─ docker-compose.yml
│  └─ config/            # auto-created at runtime
├─ scripts/
│  ├─ add-client.sh
│  └─ show-status.sh
└─ .gitignore
```

## License
MIT
