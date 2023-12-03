#Install a base Image of ubuntu
FROM debian:bullseye-slim

RUN apt-get -y update
RUN apt-get -y install openfortivpn
#RUN apt-get -y install vim tmux aptitude python python3-pip openssh-client openssh-server network-manager-fortisslvpn network-manager-l2tp network-manager-openvpn openconnect network-manager-pptp fzf net-tools curl sshpass telnet ppp 
RUN apt-get -y install vim tmux aptitude python python3-pip openssh-client openssh-server network-manager-fortisslvpn network-manager-l2tp \
network-manager-openvpn openconnect network-manager-pptp fzf net-tools curl sshpass telnet bsdmainutils
RUN curl https://raw.githubusercontent.com/mrbooshehri/cmd-fuzzy-ssh/master/fuzzy-ssh > /bin/fuzzy-ssh

