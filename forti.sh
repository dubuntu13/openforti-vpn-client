#!/bin/bash

#vasrbiale
REMOTE_IP="$IP.v4"
REMOTE_USERNAME="$username"

# Run openfortivpn in the background
openfortivpn -c /etc/openfortivpn/config &

# Wait for a while to ensure openfortivpn has started (you may need to adjust the duration)
sleep 10

# Run ssh command after openfortivpn is started
#ssh -o StrictHostKeyChecking=no -L 127.0.0.1:5601:localhost:5601 $REMOTE_USERNAME@$REMOTE_IP -N &> /dev/null &

#sleep 10
# Keep the script running in an infinite loop
while true; do
    sleep 1
done
