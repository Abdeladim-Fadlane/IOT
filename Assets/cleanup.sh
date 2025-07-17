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
  echo -e "${RED}"
  echo "   _____ _                                "
  echo "  / ____| |                               "
  echo " | |    | | ___  __ _ _ __  _   _ _ __     "
  echo " | |    | |/ _ \/ _\` | '_ \| | | | '_ \    "
  echo " | |____| |  __/ (_| | | | | |_| | |_) |   "
  echo "  \_____|_|\___|\__,_|_| |_|\__,_| .__/    "
  echo "                                 | |       "
  echo "                                 |_|       "
  echo -e "${MAGENTA} 🗑️  Cleanup   🧹 Removal   💥 Destruction${NC}"
  echo -e ""
}

# ⚡ Start
banner
echo -e "${RED}[!] Starting cleanup - Removing all installed components...${NC}"
sleep 1

# Destroy K3D cluster
echo -e "${CYAN}[~] 💥 Destroying K3D cluster...${NC}"
sudo k3d cluster delete iot-cluster 2>/dev/null || echo "K3D cluster not found or already destroyed"
echo -e "${GREEN}[✓] K3D cluster destroyed!${NC}"
sleep 1


echo -e "${MAGENTA}🎉 Cleanup complete!${NC}"
echo -e "${RED}All components have been removed from your system.${NC}"
echo -e "${CYAN}Your system has been restored to its previous state.${NC}"