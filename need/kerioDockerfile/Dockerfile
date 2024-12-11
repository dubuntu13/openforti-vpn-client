#Install a base Image of ubuntu
FROM quay.io/hienduyph/keriovpn-client

RUN apt-get -y update
RUN apt-get -y install iptables telnet
ENTRYPOINT ["./entrypoint.sh"]
