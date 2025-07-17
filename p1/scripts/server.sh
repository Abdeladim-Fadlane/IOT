#!/bin/bash

curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" INSTALL_K3S_EXEC="--flannel-iface eth1" sh -

echo "Waiting for K3s server to be ready..."
while ! kubectl get nodes &> /dev/null; do
    sleep 5
done
echo "K3s server installed and ready"

mkdir -p /vagrant
cp /var/lib/rancher/k3s/server/node-token /vagrant/node-token
echo "Node token saved to /vagrant/node-token"