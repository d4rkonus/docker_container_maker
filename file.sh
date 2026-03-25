#!/bin/bash

# Colours
greenColour="\033[1;32m"
endColour="\033[0m"
redColour="\033[1;31m"
yellowColour="\033[1;33m"
grayColour="\033[1;37m"


say_hello() {
cat << "EOF"
       ____            _        _                                   _             
      / ___|___  _ __ | |_ __ _(_)_ __   ___ _ __   _ __ ___   __ _| | _____ _ __ 
     | |   / _ \| '_ \| __/ _` | | '_ \ / _ \ '__| | '_ ` _ \ / _` | |/ / _ \ '__|
     | |__| (_) | | | | || (_| | | | | |  __/ |    | | | | | | (_| |   <  __/ |   
      \____\___/|_| |_|\__\__,_|_|_| |_|\___|_|    |_| |_| |_|\__,_|_|\_\___|_|   
EOF
                                                            echo -e "${grayColour}made by d4rkonus${endColour}\n"
}


check_root() {
    if [[ "$(id -u)" -ne 0 ]]; then
        echo -e "\n${redColour}[!] Please, run as root.${endColour}"
        exit 1
    fi
}

check_docker() {
    if command -v docker >/dev/null 2>&1; then
        echo -e "\n${greenColour}[+] Docker is installed${endColour}"
    else
        echo -e "\n${redColour}[!] Installing Docker...${endColour}"

        apt update -y >/dev/null 2>&1
        apt install -y docker.io >/dev/null 2>&1

        echo -e "\n${greenColour}[+] Docker installed${endColour}"
        read -p "Press Enter to continue..."
    fi
}




main_panel(){
    while true; do
        say_hello

        echo -e "\n${greenColour}1 - List images${endColour}"
        echo -e "${greenColour}2 - List containers${endColour}"
        echo -e "${greenColour}3 - Build image${endColour}"
        echo -e "${greenColour}4 - Build container${endColour}"
        echo -e "${greenColour}5 - Execute container${endColour}"
        echo -e "${greenColour}6 - Delete containers${endColour}"
        echo -e "${greenColour}7 - Delete images${endColour}"
        echo -e "${greenColour}8 - Exit${endColour}"

        read -p "[+] Select an option: " number

        case $number in
            1)
                clear
                docker images >/dev/null 2>&1
                echo ""
                read -p "Press Enter to continue..."
                ;;

            2) 
                clear
                docker ps >/dev/null 2>&1
                echo ""
                read -p "Press Enter to continue..."
                ;;

            8)
                clear
                exit 0
                ;;

            *) 
                clear
                echo -e "\n${redColour}[!] Invalid option, try again.${endColour}"
                read -p "Press Enter to continue..."
                ;;
        esac    
    done
}

check_root
check_docker
main_panel