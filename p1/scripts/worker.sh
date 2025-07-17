#!/bin/bash

echo "Waiting for node token..."
while [ ! -f /vagrant/node-token ]; do
    sleep 5
done

curl -sfL https://get.k3s.io | K3S_URL="https://192.168.56.110:6443" K3S_TOKEN="$(cat /vagrant/node-token)" INSTALL_K3S_EXEC="--flannel-iface eth1" sh -
echo "K3s worker installed successfully! enjoy 😊"