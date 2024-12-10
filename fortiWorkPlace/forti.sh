#!/bin/bash

# Run openfortivpn in the background
openfortivpn -c /etc/openfortivpn/config &

# Wait for a while to ensure openfortivpn has started (you may need to adjust the duration)
sleep 10

echo 1 > /proc/sys/net/ipv4/ip_forward && iptables -t nat -A POSTROUTING -o ppp0 -j MASQUERADE
#sleep 10
# Keep the script running in an infinite loop
while true; do
    sleep 1
done
