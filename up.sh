#!/bin/bash

# Configuration file path
CONFIG_FILE="./conf/routing.conf"
IMAGE_TAR="./need/kerio-vpn.tar"
DOCKERFILE_NAME="./need/"
DOCKER_IMAGE_NAME="forti-client:latest"

# Step 1: Untar the image file
if [[ -f "$IMAGE_TAR" ]]; then
    echo "Extracting Docker image from $IMAGE_TAR..."
    docker load < "$IMAGE_TAR"
    echo "Docker image loaded successfully."
else
    echo "Error: $IMAGE_TAR not found!"
    exit 1
fi

# Step 2: Build the Docker image
if [[ -f "$DOCKERFILE_NAME" ]]; then
    echo "Building Docker image: $DOCKER_IMAGE_NAME..."
    docker build -t "$DOCKER_IMAGE_NAME""$DOCKERFILE_NAME"
    echo "Docker image $DOCKER_IMAGE_NAME built successfully."
else
    echo "Error: $DOCKERFILE_NAME not found!"
    exit 1
fi

# Step 3: Bring up the containers
echo "Bringing up Docker containers..."
docker-compose up -d

# Enable IP forwarding
echo "Enabling IP forwarding..."
echo 1 > /proc/sys/net/ipv4/ip_forward

# Step 4: Process each line in the configuration file
while IFS=' ' read -r CONTAINER_NAME RANGE || [[ -n "$CONTAINER_NAME" ]]; do
    # Skip empty lines and comments
    [[ -z "$CONTAINER_NAME" || "$CONTAINER_NAME" == \#* ]] && continue

    # Get the container IP
    CONTAINER_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$CONTAINER_NAME")

    # Check if the container IP was retrieved successfully
    if [[ -z "$CONTAINER_IP" ]]; then
        echo "Error: Unable to get IP for container $CONTAINER_NAME"
        continue
    fi

    # Add the route
    echo "Adding route: $RANGE via $CONTAINER_IP for $CONTAINER_NAME"
    ip route add "$RANGE" via "$CONTAINER_IP"

    # Set NAT rules for the container
    echo "Adding NAT rule for container: $CONTAINER_NAME"
    iptables -t nat -A POSTROUTING -o "$CONTAINER_NAME" -j MASQUERADE
done < "$CONFIG_FILE"

echo "Script execution completed."
