# openforti-vpn-client<br/>
#######################
Provide requirements:

<h1>1.</h1><h3>config file of openfortivpn</h3>
$ vim ./config:
```
host = <VPN SERVER><br/>
port = <PORT><br/>
username = <USERNAME><br/>
password = <PASWWORD><br/>
trusted-cert = <cert key> >> "you can connect on your host to the vpn and service will give you the cert and put it in here"

<h1>2.</h1><h3>replace your config for ssh and tunnle in the file below</h3>
 $ vim ./forti.sh

<h1>3.</h1><h3>replace your variable in the ./docker-compose.yml file</h3>
vim ./docker-compose.yml

<h1>4.</h1><h3>Generate ssh-key and copy the publice-key to the host that you want to tunnle to it, and put a private key in this local directory.</h3>
use these command's:
$ ssh-keygen -t rsa
$ ssh-copy-id -i ~/.ssh/id_rsa.pub username@

<h3>READY TO GO</h3>
$ docker build -t <br/>
$ docker-compose up -d

##########################easy peasy :))############################
