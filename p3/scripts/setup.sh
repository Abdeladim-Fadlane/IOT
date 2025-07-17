#!/bin/bash
# 🎨 Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
NC='\033[0m' 

# 💥 Banner
function banner() {
  echo -e "${CYAN}"
  echo "   *  *_     *                        *           "
  echo "  | |/ /__ *| |*_ * ***  **_ ___ *|* |_ ___ * *"
  echo "  | ' </ *\` | / *\` | '_ \\/ -_) -_) '_|  */ -*) '_|"
  echo "  |_|\\_\\__,_|_\\__,_| .__/\\___\\___|_|  \\__\\___|_|  "
  echo "                   |_|                            "
  echo -e "${MAGENTA} ☸️  K3S   🐙 Git   🐳 Docker   🚀 Argo CD${NC}"
  echo -e ""
}

banner
echo -e "${GREEN}[+] Starting the Inception of Things - Part 3...${NC}"
sleep 1

echo -e "${CYAN}[~] 🚀 Launching K3D cluster...${NC}" 
sudo k3d cluster create iot-cluster -p "8888:30080"
echo -e "${GREEN}[✓] K3D cluster is up and running!${NC}"
sleep 1

echo -e "${YELLOW}[~] Creating namespace argocd and dev...${NC}"
kubectl create namespace argocd
kubectl create namespace dev 
echo -e "${GREEN}[✓] Namespace 'argocd' and 'dev' created!${NC}"

echo -e "${CYAN}[~] Installing ArgoCD...${NC}"
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
echo -e "${GREEN}[✓] ArgoCD installed!${NC}"
sleep 1

echo -e "${YELLOW}[~] Waiting for ArgoCD to be ready...${NC}"
kubectl wait -n argocd --for=condition=Ready pods --all --timeout=600s
echo -e "${GREEN}[✓] ArgoCD is ready!${NC}"

echo -e "${CYAN}[~] Creating ArgoCD application...${NC}"
kubectl apply -f confs/application.yaml
echo -e "${GREEN}[✓] ArgoCD application created!${NC}"

echo -e "${CYAN}[~] Exposing ArgoCD API server...${NC}"
kubectl port-forward svc/argocd-server -n argocd 8080:443 > /dev/null 2>&1 &
echo -e "${GREEN}[✓] ArgoCD API server is exposed on port 8080!${NC}"

echo -e "${MAGENTA} [⚡] 🎉 Setup complete!${NC}"
echo -e "${CYAN}[⚡] Access ArgoCD at: https://localhost:8080${NC}"
echo -e "${MAGENTA} [⚡] ArgoCd Admin Password ${GREEN}$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d)${NC}"
