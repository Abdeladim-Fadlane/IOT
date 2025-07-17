#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
NC='\033[0m' 

function banner() {
  echo -e "${CYAN}"
  echo "   *  *_     *                        *           "
  echo "  | |/ /__ *| |*_ **  **_ ___ *|* |_ ___ *"
  echo "  | ' </ *\` | / *\` | '_ \\/ -_) -_) '_|  */ -*) '_|"
  echo "  |_|\\_\\__,_|_\\__,_| .__/\\___\\___|_|  \\__\\___|_|  "
  echo "                   |_|                            "
  echo -e "${MAGENTA} ☸️  K3S   🐙 Git   🐳 Docker   🚀 Argo CD   🦊 GitLab  💥${NC}"
  echo -e ""
}

banner
echo -e "${GREEN}[+] Starting the Inception of Things - Bonus...${NC}"
sleep 1

echo -e "${CYAN}[~] 🚀 Launching K3D cluster...${NC}" 
k3d cluster create iot-cluster -p "8888:30080"
echo -e "${GREEN}[✓] K3D cluster is up and running!${NC}"
sleep 1

echo -e "${CYAN}[~] 🌀 Creating namespace  ${NC}"
kubectl create namespace argocd
kubectl create namespace gitlab
kubectl create namespace dev 

echo -e "${CYAN}[~] 🐙 Adding GitLab Helm repository...${NC}"
helm repo add gitlab https://charts.gitlab.io/
helm repo update

echo -e  "${CYAN}[~] 🐙 Deploying GitLab using Helm...${NC}"
helm upgrade --install gitlab gitlab/gitlab \
  -n gitlab \
  -f https://gitlab.com/gitlab-org/charts/gitlab/raw/master/examples/values-minikube-minimum.yaml \
  --set global.hosts.domain=k3d.gitlab.com \
  --set global.hosts.externalIP=0.0.0.0 \
  --set global.hosts.https=false \
  --timeout 600s

echo -e "${CYAN}[~] Installing ArgoCD...${NC}"
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl wait -n argocd --for=condition=Ready pods --all --timeout=600s
kubectl apply -f confs/application.yaml

echo -e "${CYAN}[~] waiting for gitlab to be ready...${NC}"
kubectl wait --for=condition=available --timeout=600s deployment/gitlab-webservice-default -n gitlab
kubectl port-forward -n gitlab svc/gitlab-webservice-default 8081:8181 > /dev/null 2>&1 &
kubectl port-forward svc/argocd-server -n argocd 8080:443 > /dev/null 2>&1 &
sleep 5
echo -e "${GREEN}[✓] GitLab and ArgoCD are now running!${NC}"

echo -e "${MAGENTA}🎉 Setup complete!${NC}"
echo -e "${CYAN}Access ArgoCD at: https://localhost:8080${NC}"
echo -e "${CYAN}Access GitLab at: http://localhost:8081${NC}"
echo -e "${MAGENTA}[~] GitLab root Password: ${GREEN}$(kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -o jsonpath="{.data.password}" | base64 --decode) ${NC}"
echo -e "${MAGENTA}[~] ArgoCd Admin Password: ${GREEN}$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d)${NC}"
