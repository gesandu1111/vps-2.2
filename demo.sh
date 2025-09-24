#!/bin/bash
# WireGuard Demo Mode

echo "🎬 WireGuard Demo Mode - no changes made"

SERVER_PRIV="demo-server-private-key"
SERVER_PUB="demo-server-public-key"
CLIENT_PRIV="demo-client-private-key"
CLIENT_PUB="demo-client-public-key"

echo "Server Public: $SERVER_PUB"
echo "Client Public: $CLIENT_PUB"

echo "[Server config preview]"
cat <<EOL
[Interface]
PrivateKey = $SERVER_PRIV
Address = 10.0.0.1/24
ListenPort = 51820
SaveConfig = true

[Peer]
PublicKey = $CLIENT_PUB
AllowedIPs = 10.0.0.2/32
EOL

echo "[Client config preview]"
cat <<EOL
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
