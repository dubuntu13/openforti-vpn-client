#!/usr/bin/env bash
set -o nounset

main() {
  /etc/init.d/kerio-kvc start
  sleep 5

  # workaround for fixing the real IP address of kvpn
  # see more: https://aur.archlinux.org/packages/kerio-control-vpnclient/#comment-795258
  ip link set dev kvnet address "$(awk '/VPN driver opened/ {print $NF}' /var/log/kerio-kvc/debug.log | tail -n1 | sed 's/-/:/g')"

  # Enable IP forwarding and configure NAT for the kvnet interface
  echo 1 > /proc/sys/net/ipv4/ip_forward &&
  iptables -t nat -A POSTROUTING -o kvnet -j MASQUERADE &&

  # Show logs to check Docker
  bash -c "tail -f /var/log/kerio-kvc/*.log" &
}

close() {
  echo "stopping"
  /etc/init.d/kerio-kvc stop
  trap - SIGINT SIGTERM
  exit 0
}

trap close SIGINT SIGTERM

main

sleep infinity & wait

