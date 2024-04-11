# openforti-vpn-client<br/>
#######################<br/>
you can customize the docker-compose.yml with your need, and you can put multiple container with diffrent openfortivpn connection in docker-compose and connect to them at the same time.

Provide requirements:

<h1>1.</h1><h3>config file of openfortivpn</h3>
$ vim ./config:
```<br/>
host = #VPN SERVER<br/>
port = #PORT<br/>
username = #USERNAME<br/>
password = #PASWWORD<br/>
trusted-cert = #cert key >> "you can connect on your host to the vpn and service will give you the cert and put it in here"

<h1>2.</h1><h3>replace your config for ssh and tunnle in the file below</h3>
 $ vim ./forti.sh

<h1>3.</h1><h3>replace your variable in the ./docker-compose.yml file</h3>
vim ./docker-compose.yml<br/>

<h3>READY TO GO</h3>
$ docker build -t <Image nem><br/>
$ docker-compose up -d<br/>

##########################easy peasy :))############################
