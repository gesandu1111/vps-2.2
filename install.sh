#!/bin/bash
# WireGuard VPS Installation Script

echo "🚀 Updating system..."
sudo apt update && sudo apt upgrade -y

echo "📦 Installing WireGuard..."
sudo apt install wireguard -y

echo "🔑 Generating keys..."
SERVER_PRIV=$(wg genkey)
SERVER_PUB=$(echo $SERVER_PRIV | wg pubkey)
CLIENT_PRIV=$(wg genkey)
CLIENT_PUB=$(echo $CLIENT_PRIV | wg pubkey)

echo "Server Private: $SERVER_PRIV"
echo "Server Public : $SERVER_PUB"
echo "Client Private: $CLIENT_PRIV"
echo "Client Public : $CLIENT_PUB"

# Server config
cat <<EOL | sudo tee /etc/wireguard/wg0.conf
[Interface]
PrivateKey = $SERVER_PRIV
Address = 10.0.0.1/24
ListenPort = 51820
SaveConfig = true

PostUp   = iptables -A FORWARD -i %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

[Peer]
PublicKey = $CLIENT_PUB
AllowedIPs = 10.0.0.2/32
EOL

# Client config
cat <<EOL > ~/client.conf
[Interface]
PrivateKey = $CLIENT_PRIV
Address = 10.0.0.2/24
DNS = 1.1.1.1

[Peer]
PublicKey = $SERVER_PUB
Endpoint = YOUR_VPS_IP:51820
AllowedIPs = 0.0.0.0/0, ::/0
PersistentKeepalive = 25
EOL

echo "✅ Installation complete!"
echo "Client config: ~/client.conf"
