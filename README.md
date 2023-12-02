# openforti-vpn-client
#######################
Provide requirements:

<1. Change the variable of the config file for and put your config VPN>
> ./config:
```
host = <VPN SERVER>
port = <PORT>
username = <USERNAME>
password = <PASWWORD>
trusted-cert = <cert key> >> "you can connect on your host to the vpn and service will give you the cert and put it in here"
```



2. replace your config for ssh and tunnle in the file below:
./forti.sh




3. replace your variable in the ./docker-compose.yml file




4. Generate ssh-key and copy the publice-key to the host that you want to tunnle to it, and put a private key in this local directory.
use these command's:
        $ ssh-keygen -t rsa
        $ ssh-copy-id -i ~/.ssh/id_rsa.pub username@<remote IP>



READY TO GO
$ docker build -t <image-name> .
$ docker-compose up -d

##############################easy peasy :))#############################
