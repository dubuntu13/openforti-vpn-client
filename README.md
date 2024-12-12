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
├── conf
├── docker-compose-kerio.yml
├── generate-compose.sh
├── id_rsa.pub
├── need
│   ├── connections.conf
│   ├── fortiDockerfile
│   │   ├── Dockerfile
│   │   └── forti.sh
│   ├── fortivpnConf
│   │   └── config
│   ├── kerioDockerfile
│   │   ├── Dockerfile
│   │   └── entrypoint.sh
│   ├── keriovpnConf
│   │   └── kerio-kvc.conf
│   └── routing.conf
├── README.md
├── readme.txt
└── up.sh

```
## First of All Add Your client configs
1. openforti client config directory is:
   ```
   ./need/fortivpnConf/<Put youd forti's config into this directory>
2. kerio-kvc client config directory:
   ```
   ./need/keriovpnConf/<Put your kerio kvc client into this directory>

## Manage your VPN's image's and container's:
1. Edit ./need/connections.conf
   ```
      KERIO_VPN_CONNECTIONS:
        kerio1 kerio-vpn1 kvnet1 ./need/keriovpnConf/kerio-kvc.conf

      FORTI_VPN_CONNECTIONS:
        forti2 forti-vpn2 fortinet2 ./need/fortivpnConf/moi1
   ```
`kerio1` is container name</br>
`kerio-vpn1` is network name in container</br>
`./need/keriovpnConf/kerio-kvc.conf` This is the path of the config file</br>
same in kerio and forti and you can add multiple of each to create and connect to al lof them</br>


## Configuration

### Routing Configuration File (`routing.conf`)

The `routing.conf` After you edit the earlier file now config your route on your host:

```
kerio1 192.168.68.0/24 #This is an example
forti2 192.168.151.0/24 #This is another example
```

- **Container Name**: Name of the Docker container (e.g., `kerio1`).
- **CIDR Range**: Subnet range (e.g., `192.168.68.0/24`).
- **Comments**: Optional, starting with `#`.

## Now wwe can Start to Connectiong to zones

1. Clone the repository:
   ```bash
   git clone https://github.com/dubuntu13/openforti-vpn-client
   cd openforti-vpn-client
   ```

2. Run the generate-compose.sh.
   ```
   ./generate-compose.sh
   ```
dobble check the docker-compose that script created and the docker images version musst be equal with the up.sh docker images.

4. Run the script:
   ```bash
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

https://github.com/dubuntu13
