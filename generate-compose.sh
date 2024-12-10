#!/bin/bash

CONFIG_FILE="./connections.conf"
OUTPUT_COMPOSE="docker-compose.yml"

# Start building the compose file
echo "version: '3.8'" > $OUTPUT_COMPOSE
echo -e "\nservices:" >> $OUTPUT_COMPOSE

# Read the configuration file
while IFS= read -r line || [[ -n "$line" ]]; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" == \#* ]] && continue

    # Parse KERIO_VPN_CONNECTIONS
    if [[ $line == KERIO_VPN_CONNECTIONS:* ]]; then
        echo "  # Kerio VPN Connections" >> $OUTPUT_COMPOSE
        while IFS= read -r conn_line; do
            [[ -z "$conn_line" || "$conn_line" == \#* ]] && break
            IFS=' ' read -r name container_name network volume <<<"${conn_line#*: }"
            echo "  $container_name:" >> $OUTPUT_COMPOSE
            echo "    image: kerio-vpn:1.0" >> $OUTPUT_COMPOSE
            echo "    container_name: $container_name" >> $OUTPUT_COMPOSE
            echo "    restart: unless-stopped" >> $OUTPUT_COMPOSE
            echo "    privileged: true" >> $OUTPUT_COMPOSE
            echo "    cap_add:" >> $OUTPUT_COMPOSE
            echo "      - NET_ADMIN" >> $OUTPUT_COMPOSE
            echo "    devices:" >> $OUTPUT_COMPOSE
            echo "      - /dev/net/tun" >> $OUTPUT_COMPOSE
            echo "    networks:" >> $OUTPUT_COMPOSE
            echo "      - $network" >> $OUTPUT_COMPOSE
            echo "    volumes:" >> $OUTPUT_COMPOSE
            echo "      - $volume:/etc/kerio-kvc.conf" >> $OUTPUT_COMPOSE
        done
    fi

    # Parse FORTI_VPN_CONNECTIONS
    if [[ $line == FORTI_VPN_CONNECTIONS:* ]]; then
        echo "  # Forti VPN Connections" >> $OUTPUT_COMPOSE
        while IFS= read -r conn_line; do
            [[ -z "$conn_line" || "$conn_line" == \#* ]] && break
            IFS=' ' read -r name container_name network volume <<<"${conn_line#*: }"
            echo "  $container_name:" >> $OUTPUT_COMPOSE
            echo "    image: forti-client:latest" >> $OUTPUT_COMPOSE
            echo "    container_name: $container_name" >> $OUTPUT_COMPOSE
            echo "    user: 'root:root'" >> $OUTPUT_COMPOSE
            echo "    privileged: true" >> $OUTPUT_COMPOSE
            echo "    cap_add:" >> $OUTPUT_COMPOSE
            echo "      - NET_ADMIN" >> $OUTPUT_COMPOSE
            echo "    devices:" >> $OUTPUT_COMPOSE
            echo "      - /dev/net/tun" >> $OUTPUT_COMPOSE
            echo "    networks:" >> $OUTPUT_COMPOSE
            echo "      - $network" >> $OUTPUT_COMPOSE
            echo "    volumes:" >> $OUTPUT_COMPOSE
            echo "      - $volume:/etc/openfortivpn/config" >> $OUTPUT_COMPOSE
        done
    fi
done < "$CONFIG_FILE"

# Add network definitions
echo -e "\nnetworks:" >> $OUTPUT_COMPOSE
while IFS= read -r line || [[ -n "$line" ]]; do
    [[ -z "$line" || "$line" == \#* ]] && continue
    if [[ $line =~ (kerio|forti)[0-9]: ]]; then
        IFS=' ' read -r name container_name network volume <<<"${line#*: }"
        echo "  $network:" >> $OUTPUT_COMPOSE
        echo "    driver: bridge" >> $OUTPUT_COMPOSE
    fi
done < "$CONFIG_FILE"

echo "Docker Compose file generated: $OUTPUT_COMPOSE"

