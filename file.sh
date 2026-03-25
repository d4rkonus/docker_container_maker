#!/bin/bash

# Colours
greenColour="\033[1;32m"
endColour="\033[0m"
redColour="\033[1;31m"
yellowColour="\033[1;33m"
grayColour="\033[1;37m"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/images.sh"
source "$SCRIPT_DIR/containers.sh"


say_hello() {
cat << "EOF"
       ____            _        _                                   _             
      / ___|___  _ __ | |_ __ _(_)_ __   ___ _ __   _ __ ___   __ _| | _____ _ __ 
     | |   / _ \| '_ \| __/ _` | | '_ \ / _ \ '__| | '_ ` _ \ / _` | |/ / _ \ '__|
     | |__| (_) | | | | || (_| | | | | |  __/ |    | | | | | | (_| |   <  __/ |   
      \____\___/|_| |_|\__\__,_|_|_| |_|\___|_|    |_| |_| |_|\__,_|_|\_\___|_|   
EOF
echo -e                                                                         "\n${grayColour}made by d4rkonus${endColour}\n"
}


check_root() {
    if [[ "$(id -u)" -ne 0 ]]; then
        echo -e "\n${redColour}[!] Please, run as root.${endColour}"
        exit 1
    fi
}

check_docker() {
    if command -v docker &>/dev/null; then
        echo -e "\n${greenColour}[+] Docker is installed${endColour}"
    else
        echo -e "\n${redColour}[!] Installing Docker...${endColour}"

        apt update -y &>/dev/null
        apt install -y docker.io &>/dev/null

        echo -e "\n${greenColour}[+] Docker installed${endColour}"
        pause
    fi
}

pause(){
    echo ""
    read -p "Press Enter to continue..."
}


main_panel(){
    while true; do
        clear
        say_hello

        echo -e "\n${greenColour}1 - List images${endColour}"
        echo -e "${greenColour}2 - List containers${endColour}"
        echo -e "${greenColour}3 - Build image${endColour}"
        echo -e "${greenColour}4 - Build container${endColour}"
        echo -e "${greenColour}5 - Execute container${endColour}"
        echo -e "${greenColour}6 - Delete containers${endColour}"
        echo -e "${greenColour}7 - Delete images${endColour}"
        echo -e "${greenColour}8 - Exit${endColour}"
        echo ""
        read -p "[+] Select an option: " number

        case $number in
            1)
                clear
                docker images
                pause
                ;;

            2) 
                clear
                docker ps 
                pause
                ;;

            3)
                clear
                distro_select
                ;;

            4)
                clear
                container_maker
                pause
                ;;

            5)
                clear
                run_container
                pause
                ;;

            6)
                clear
                delete_containers
                pause
                ;;

            7)
                clear
                delete_images
                pause
                ;;

            8)
                clear
                exit 0
                ;;

            *) 
                clear
                echo -e "\n${redColour}[!] Invalid option, try again.${endColour}"
                pause
                ;;
        esac    
    done
}

check_root
check_docker
main_panel