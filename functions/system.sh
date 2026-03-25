#!/bin/bash

check_root() {
    if [[ "$(id -u)" -ne 0 ]]; then
        echo -e "\n${redColour}[!] Please, run as root.${endColour}"
        exit 1
    fi
}

check_docker() {
    if command -v docker >/dev/null 2>&1; then
        echo -e "${greenColour}[+] Docker is installed${endColour}"
    else
        echo -e "${redColour}[!] Installing Docker...${endColour}"

        apt update -y >/dev/null 2>&1
        apt install -y docker.io >/dev/null 2>&1

        echo -e "${greenColour}[+] Docker installed${endColour}"
        read -p "Press Enter to continue..."
    fi
}
