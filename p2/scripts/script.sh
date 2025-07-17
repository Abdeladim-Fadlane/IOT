#!/bin/bash

curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" INSTALL_K3S_EXEC="--flannel-iface eth1" sh -
		
echo "Waiting for K3s server to be ready..."
while ! kubectl get nodes &> /dev/null; do
    sleep 5
done
echo "K3s server is ready!"

kubectl apply  -f /vagrant/app1.yaml 
kubectl apply  -f /vagrant/app2.yaml
kubectl apply  -f /vagrant/app3.yaml
kubectl apply  -f /vagrant/ingress.yaml

echo "🚀 Waiting for deployment to be ready..."
kubectl wait deployment app-one --for condition=Available=True --timeout=-1s > /dev/null
kubectl wait deployment app-two --for condition=Available=True --timeout=-1s > /dev/null
kubectl wait deployment app-three --for condition=Available=True --timeout=-1s > /dev/null
echo "✅ Deployment 'apps' is ready!"

echo "⏳ Waiting for Ingress endpoint..."
until kubectl get endpoints traefik -n kube-system -o jsonpath='{.subsets[0].addresses[0].ip}' 2>/dev/null | grep -q '[0-9]'; do
    sleep 5
done
echo "✅ Ingress endpoint is ready!"

echo "🎉 K3s setup complete! Enjoy 😊"