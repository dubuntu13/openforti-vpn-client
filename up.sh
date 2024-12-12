#!/bin/bash

# Configuration file path
CONFIG_FILE="./need/routing.conf"
DOCKERFILE_KERIO="./need/kerioDockerfile/Dockerfile"
DOCKER_IMAGE_NAME_KERIO="kerio-vpn:1.0"
DOCKERFILE_FORTI="./need/fortiDockerfile/Dockerfile"
DOCKER_IMAGE_NAME_FORTI="forti-client:latest"

# Step 1: Check and build the Kerio Docker image
if [[ -f "$DOCKERFILE_KERIO" ]]; then
    echo "Building Docker image: $DOCKER_IMAGE_NAME_KERIO..."
    docker build -t "$DOCKER_IMAGE_NAME_KERIO" -f "$DOCKERFILE_KERIO" .
    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to build Docker image $DOCKER_IMAGE_NAME_KERIO!"
        exit 1
    fi
    echo "Docker image $DOCKER_IMAGE_NAME_KERIO built successfully."
else
    echo "Error: Dockerfile for Kerio ($DOCKERFILE_KERIO) not found!"
    exit 1
fi

# Step 2: Check and build the Forti Docker image (optional)
if [[ -f "$DOCKERFILE_FORTI" ]]; then
    echo "Building Docker image: $DOCKER_IMAGE_NAME_FORTI..."
    docker build -t "$DOCKER_IMAGE_NAME_FORTI" -f "$DOCKERFILE_FORTI" .
    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to build Docker image $DOCKER_IMAGE_NAME_FORTI!"
        exit 1
    fi
    echo "Docker image $DOCKER_IMAGE_NAME_FORTI built successfully."
else
    echo "Warning: Dockerfile for Forti ($DOCKERFILE_FORTI) not found. Skipping Forti build."
fi

# Step 3: Bring up the containers
echo "Bringing up Docker containers..."
docker-compose up -d
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to start Docker containers!"
    exit 1
fi

# Enable IP forwarding
echo "Enabling IP forwarding..."
sysctl -w net.ipv4.ip_forward=1
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to enable IP forwarding!"
    exit 1
fi

# Step 4: Process each line in the configuration file
if [[ -f "$CONFIG_FILE" ]]; then
    while IFS=' ' read -r CONTAINER_NAME RANGE COMMENT || [[ -n "$CONTAINER_NAME" ]]; do
        # Skip empty lines and comments
        [[ -z "$CONTAINER_NAME" || "$CONTAINER_NAME" == \#* ]] && continue

        # Clean the RANGE to remove any comments (anything after #)
        RANGE=$(echo "$RANGE" | cut -d '#' -f 1)

        # Get the container IP
        CONTAINER_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$CONTAINER_NAME")
        if [[ -z "$CONTAINER_IP" ]]; then
            echo "Error: Unable to get IP for container $CONTAINER_NAME"
            continue
        fi

        # Add the route
        echo "Adding route: $RANGE via $CONTAINER_IP for $CONTAINER_NAME"
        ip route add "$RANGE" via "$CONTAINER_IP"
        if [[ $? -ne 0 ]]; then
            echo "Error: Failed to add route $RANGE via $CONTAINER_IP"
            continue
        fi

        # Set NAT rules for the container
        echo "Adding NAT rule for container: $CONTAINER_NAME"
        iptables -t nat -A POSTROUTING -o "$CONTAINER_NAME" -j MASQUERADE
        if [[ $? -ne 0 ]]; then
            echo "Error: Failed to add NAT rule for $CONTAINER_NAME"
        fi
    done < "$CONFIG_FILE"
else
    echo "Error: Configuration file $CONFIG_FILE not found!"
    exit 1
fi

# Step 5: Add the IP forwarding and NAT rules for Kerio container
echo "Adding IP forwarding and NAT rule for Kerio containers..."
docker exec -d kerio1 /bin/bash -c "echo 1 > /proc/sys/net/ipv4/ip_forward && iptables -t nat -A POSTROUTING -o kvnet -j MASQUERADE"

echo "Script execution completed."

