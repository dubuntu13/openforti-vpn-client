# Docker VPN Routing Automation

This project automates the setup of Docker containers for VPN services (Kerio and Forti), configures IP routing, and enables NAT (Network Address Translation). It includes a script to handle container setup, IP forwarding, and dynamic routing based on a configuration file.

## Features

- **Automated Docker Image Building**: Automatically builds Docker images for Kerio and Forti VPN clients using specified Dockerfiles.
- **Dynamic Routing**: Reads a configuration file to dynamically set up IP routing and NAT rules.
- **IP Forwarding**: Enables IP forwarding on the host system to allow routing between networks.
- **Custom NAT Rules**: Adds NAT rules for Kerio containers to ensure seamless network communication.

## Prerequisites

Before using this project, ensure you have the following installed:

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- A Linux-based system with administrative privileges

## File Structure

```
.
├── need/
│   ├── routing.conf               # Configuration file for routing rules
│   ├── kerioDockerfile/
│   │   └── Dockerfile             # Dockerfile for Kerio VPN container
│   ├── fortiDockerfile/
│       └── Dockerfile             # Dockerfile for Forti VPN container
├── up.sh                          # Main script to build images, start containers, and configure routing
└── docker-compose.yml             # Docker Compose file to define and run multi-container setup
```

## Configuration

### Routing Configuration File (`routing.conf`)

The `routing.conf` file specifies the routing rules for your containers. Each line should define a container name and the CIDR range it routes, optionally followed by a comment. Example:

```
kerio1 192.168.68.0/24 #This is an example
forti2 192.168.191.0/24 #This is another example
```

- **Container Name**: Name of the Docker container (e.g., `kerio1`).
- **CIDR Range**: Subnet range (e.g., `192.168.68.0/24`).
- **Comments**: Optional, starting with `#`.

### Dockerfiles

- `kerioDockerfile/Dockerfile`: Defines the Kerio VPN Docker image.
- `fortiDockerfile/Dockerfile`: Defines the Forti VPN Docker image.

Update these files as needed for your VPN client configurations.

## Usage

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/docker-vpn-routing.git
   cd docker-vpn-routing
   ```

2. Update the `routing.conf` file with your routing rules.

3. Run the script:
   ```bash
   chmod +x up.sh
   ./up.sh
   ```

   The script performs the following:
   - Builds Docker images for Kerio and Forti.
   - Starts the containers using Docker Compose.
   - Enables IP forwarding on the host system.
   - Configures routing and NAT rules dynamically.

## Notes

- Ensure that the Docker container names in `routing.conf` match the names in `docker-compose.yml`.
- The script automatically skips commented or empty lines in `routing.conf`.
- IP forwarding and NAT rules are applied specifically for Kerio containers.

## Troubleshooting

- **Routing Errors**: Ensure the CIDR ranges in `routing.conf` are valid and not followed by inline comments without a space.
- **Docker Errors**: Verify Docker and Docker Compose are installed and running correctly.
- **Permission Errors**: Run the script with administrative privileges (`sudo`).

## License

This project is licensed under the [MIT License](LICENSE).

## Contribution

Feel free to fork this repository and submit pull requests for improvements or bug fixes. For major changes, please open an issue first to discuss.

## Author

[Your Name](https://github.com/yourusername)
