#Install a base Image of ubuntu
FROM debian:bullseye-slim

RUN apt-get -y update
RUN apt-get -y install openfortivpn
RUN apt-get -y install aptitude python python3-pip openssh-client openssh-server network-manager-fortisslvpn network-manager-l2tp \
network-manager-openvpn openconnect network-manager-pptp

