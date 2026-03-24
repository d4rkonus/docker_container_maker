#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"


# Ocultar cursor
tput civis

# Restaurar cursor al salir
trap 'tput cnorm' EXIT
trap 'tput cnorm; exit 1' INT TERM

check_root() {
    if [[ "$(id -u)" -ne 0 ]]; then
        echo -e "\n${redColour}[!] Please run this script as root.${endColour}"
        exit 1
    fi
}


say_hello(){
cat << "EOF"
       ____            _        _                                   _             
      / ___|___  _ __ | |_ __ _(_)_ __   ___ _ __   _ __ ___   __ _| | _____ _ __ 
     | |   / _ \| '_ \| __/ _` | | '_ \ / _ \ '__| | '_ ` _ \ / _` | |/ / _ \ '__|
     | |__| (_) | | | | || (_| | | | | |  __/ |    | | | | | | (_| |   <  __/ |   
      \____\___/|_| |_|\__\__,_|_|_| |_|\___|_|    |_| |_| |_|\__,_|_|\_\___|_|    made by d4rkonus
EOF
}


check_docker(){
    if command -v docker >/dev/null 2>&1; then
        echo -e "${greenColour}[+] Docker is installed${endColour}."
    else
        echo -e "${redColour}[!] Docker needs to be installed.\n"
        sleep 2
        echo -e "${grayColour}[+] Installing Docker..."
        
        apt update -y >/dev/null 2>&1
        apt install -y docker.io >/dev/null 2>&1

        sleep 2
        echo -e "${greenColour}[+] Docker installed successfully${endColour}"
    fi
}

distro_select(){
    echo -e "Select which distro for the container:\n"

    echo -e "${yellowColour}1 -> Kali Linux${endColour}"
    echo -e "${yellowColour}2 -> Ubuntu${endColour}"
    echo -e "${yellowColour}3 -> Arch Linux${endColour}\n"

    read -p "Select the option: " option

}

main() {
    sleep 1
    check_root
    say_hello
    check_docker
}

main