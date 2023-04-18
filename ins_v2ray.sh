#!/bin/bash

# Update the system
sudo apt update

# Install necessary dependencies
sudo apt install curl -y

# Download and install v2ray
curl -O https://github.com/v2ray/v2ray-core/releases/latest/download/v2ray-linux-64.zip
unzip v2ray-linux-64.zip
sudo mv v2ray /usr/local/bin/
sudo mv v2ctl /usr/local/bin/

# Create a v2ray configuration file
sudo mkdir /etc/v2ray
sudo touch /etc/v2ray/config.json
sudo chmod 777 /etc/v2ray/config.json

# Generate a random UUID for v2ray
uuid=$(cat /proc/sys/kernel/random/uuid)

# Write v2ray configuration to config.json
cat << EOF > /etc/v2ray/config.json
{
    "inbounds": [{
        "port": 10001, # Replace with your desired port
        "protocol": "vmess",
        "settings": {
            "clients": [{
                "id": "$uuid",
                "alterId": 64
            }]
        },
        "streamSettings": {
            "network": "tcp",
            "tcpSettings": {
                "header": {
                    "type": "http",
                    "request": {
                        "path": ["/"],
                        "headers": {
                            "Host": ["example.com"] # Replace with your desired host
                        }
                    }
                }
            }
        }
    }, {
        "port": 10002, # Replace with another desired port
        "protocol": "vmess",
        "settings": {
            "clients": [{
                "id": "$uuid",
                "alterId": 64
            }]
        },
        "streamSettings": {
            "network": "tcp",
            "tcpSettings": {
                "header": {
                    "type": "http",
                    "request": {
                        "path": ["/"],
                        "headers": {
                            "Host": ["example.com"] # Replace with your desired host
                        }
                    }
                }
            }
        }
    }],
    "outbounds": [{
        "protocol": "freedom",
        "settings": {}
    }]
}
EOF

# Start v2ray service
sudo systemctl enable v2ray
sudo systemctl start v2ray

# Print v2ray status
sudo systemctl status v2ray
