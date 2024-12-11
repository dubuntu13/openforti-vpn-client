#!/bin/bash

CONFIG_FILE="./need/connections.conf"
OUTPUT_COMPOSE="docker-compose.yml"

# Start building the compose file
echo "version: '3.8'" > $OUTPUT_COMPOSE
echo -e "\nservices:" >> $OUTPUT_COMPOSE

declare -A networks_map # To track unique networks

# Read the configuration file
while IFS= read -r line || [[ -n "$line" ]]; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" == \#* ]] && continue

    # Detect connection groups
    if [[ $line == KERIO_VPN_CONNECTIONS:* || $line == FORTI_VPN_CONNECTIONS:* ]]; then
        GROUP=${line%%:*} # Extract group name
        echo "  # ${GROUP}" >> $OUTPUT_COMPOSE
        continue
    fi

    # Parse connection lines
    IFS=' ' read -r container_name network volume config_path <<<"${line#*: }"

    # Add to services
    if [[ $GROUP == "KERIO_VPN_CONNECTIONS" ]]; then
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
        echo "      - $config_path:/etc/kerio-kvc.conf" >> $OUTPUT_COMPOSE
    elif [[ $GROUP == "FORTI_VPN_CONNECTIONS" ]]; then
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
        echo "      - $config_path:/etc/openfortivpn/config" >> $OUTPUT_COMPOSE
        echo "      - ./need/fortiDockerfile/forti.sh:/opt/forti.sh" >> $OUTPUT_COMPOSE
        echo "    command: /opt/forti.sh" >> $OUTPUT_COMPOSE
    fi

    # Track networks for unique entry
    networks_map["$network"]=1
done < "$CONFIG_FILE"

# Add network definitions
echo -e "\nnetworks:" >> $OUTPUT_COMPOSE
for network in "${!networks_map[@]}"; do
    if [[ -n "$network" ]]; then
        echo "  $network:" >> $OUTPUT_COMPOSE
        echo "    driver: bridge" >> $OUTPUT_COMPOSE
    fi
done

echo "Docker Compose file generated: $OUTPUT_COMPOSE"

