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


check_root() {
    if [[ "$(id -u)" -ne 0 ]]; then
        echo -e "\n${redColour}[!] Please, become sudo user to run this script.${endColour}"
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

main_panel(){
    while true; do
        clear
        say_hello

        echo -e "\n${greenColour}1 - List images${endColour}"
        echo -e "${greenColour}2 - List containers${endColour}"
        echo -e "${greenColour}3 - Build image${endColour}"
        echo -e "${greenColour}4 - Build container${endColour}"
        echo -e "${greenColour}5 - Execute container${endColour}"
        echo -e "${greenColour}6 - Exit${endColour}"

        read -p "[+] Select an option: " number

        case "$number" in 
            1) 
                clear
                docker images
                echo
                read -p "Press enter to continue..."
                ;;

            2) 
                clear
                docker ps -a
                echo
                read -p "Press enter to continue..."
                ;;

            3) 
                clear
                distro_select
                read -p "Press enter to continue..."
                ;;

            4)
                clear
                container_maker
                read -p "Press enter to continue..."
                ;;

            5)
                clear
                run_container
                read -p "Press enter to continue..."
                ;;

            6)
                exit 0
                ;;

            *)
                echo -e "${redColour}[!] Invalid option.${endColour}"
                sleep 1
                ;;
        esac
    done
}


check_docker(){
    if command -v docker >/dev/null 2>&1; then
        echo -e "${greenColour}[+] Docker is installed${endColour}."
    else
        echo -e "${redColour}\n\n[!] Docker needs to be installed.\n"
        sleep 2
        echo -e "${grayColour}[+] Installing Docker..."
        
        apt update -y >/dev/null 2>&1
        apt install -y docker.io >/dev/null 2>&1

        sleep 2
        echo -e "${greenColour}[+] Docker installed successfully${endColour}\n"

        echo -e "\n${yellowColour}Press Enter to continue...${endColour}"
        read
        clear
    fi
}

distro_select(){
    echo -e "\n[+] These are the Linux distributions for docker:\n"

    echo -e "${yellowColour}1 -> Ubuntu${endColour}"
    echo -e "${yellowColour}2 -> Kali Linux${endColour}"
    read -p "Select the option: " option

    if [[ "$option" == "1" ]]; then
        IMAGE="ubuntu_image"
        CONTAINER="ubuntu_container_1"

        echo -e "\n${yellowColour}[+] Building new ubuntu image for docker...${endColour}"
        docker build -t "$IMAGE" -f ubuntu.dockerfile . >/dev/null 2>&1
    

    elif [[ "$option" == "2" ]]; then
        IMAGE="kali_image"
        CONTAINER="kali_container_1"

        echo -e "\n${yellowColour}[+] Building new kali image for docker...${endColour}"
        docker build -t "$IMAGE" -f kali.dockerfile . >/dev/null 2>&1
    

    else
        echo -e "\n${redColour}[!] Invalid option${endColour}"
        exit 1
    fi
}

container_maker(){
    select_image || return

    echo -e "\n${yellowColour}[+] Creating container...${endColour}"

    docker rm -f "$CONTAINER" >/dev/null 2>&1 || true
    docker run -dit --name "$CONTAINER" "$IMAGE" >/dev/null 2>&1

    echo -e "${greenColour}[+] Container created: $CONTAINER${endColour}"
}

run_container(){

    containers=$(docker ps -a --format "{{.Names}}")

    if [[ -z "$containers" ]]; then
        echo "No containers found"
        return
    fi

    echo "Available containers:"

    i=1
    for c in $containers; do
        echo "$i) $c"
        i=$((i+1))
    done

    read -p "Select container: " choice

    if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
        echo "Invalid input"
        return
    fi

    i=1
    for c in $containers; do
        if [[ "$i" == "$choice" ]]; then
            docker start "$c" >/dev/null 2>&1
            docker exec -it "$c" bash
            return
        fi
        i=$((i+1))
    done

    echo "Invalid option"
}


select_image(){

    images=$(docker images --format "{{.Repository}}" | sort -u)

    if [[ -z "$images" ]]; then
        echo "No images found"
        return 1
    fi

    echo "Available images:"

    i=1
    for img in $images; do
        echo "$i) $img"
        i=$((i+1))
    done

    read -p "Select image: " choice

    if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
        echo "Invalid input"
        return 1
    fi

    i=1
    for img in $images; do
        if [[ "$i" == "$choice" ]]; then
            IMAGE="$img"
            CONTAINER="$(echo "$img" | tr ':' '_')_container"
            return
        fi
        i=$((i+1))
    done

    echo "Invalid option"
    return 1
}


main() {
    sleep 1
    check_root
    check_docker
    main_panel
}

main