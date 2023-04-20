#!/bin/bash

# Update package list
apt update

# Install required packages
apt install -y curl unzip

# Download and install V2Ray
bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)

# Create a new V2Ray configuration file
cat > /usr/local/etc/v2ray/config.json <<EOF
{
  "inbounds": [
    {
      "port": 8080,
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "YOUR_UUID",
            "alterId": 64
          }
        ]
      },
      "streamSettings": {
        "network": "tcp",
        "tcpSettings": {
          "header": {
            "type": "http",
            "response": {
              "version": "1.1",
              "status": "200",
              "reason": "OK",
              "headers": {
                "Content-Type": ["application/octet-stream", "application/x-msdownload", "text/mcf-xml", "text/xml", "application/atom+xml", "application/rss+xml", "application/x-javascript", "text/javascript", "text/css", "text/html", "application/x-silverlight-2", "application/x-silverlight-3", "application/x-silverlight-4", "application/futuresplash", "image/gif", "image/png", "image/jpeg", "image/bmp", "image/webp", "audio/mpeg", "audio/ogg", "audio/x-wav", "video/mp4", "video/ogg", "application/octet-stream", "application/pdf", "text/plain", "application/zip", "application/gzip"],
                "Cache-Control": ["public, max-age=31536000, immutable"],
                "Access-Control-Allow-Origin": ["*"],
                "Vary": ["Accept-Encoding"],
                "Server": ["V2Fly"],
                "Content-Encoding": ["gzip"],
                "Transfer-Encoding": ["chunked"],
                "Connection": ["keep-alive"]
              }
            }
          }
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom"
    }
  ]
}
EOF

# Replace YOUR_UUID with a new UUID
sed -i 's/YOUR_UUID/'$(cat /proc/sys/kernel/random/uuid)'/g' /usr/local/etc/v2ray/config.json

# Start V2Ray service
systemctl start v2ray
systemctl enable v2ray

# Print V2Ray status
systemctl status v2ray
