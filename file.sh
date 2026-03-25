#!/bin/bash

# Colours
greenColour="\033[1;32m"
endColour="\033[0m"
redColour="\033[1;31m"
yellowColour="\033[1;33m"
grayColour="\033[1;37m"

check_root() {
    if [[ "$(id -u)" -ne 0 ]]; then
        echo -e "\n${redColour}[!] Please, run as root.${endColour}"
        exit 1
    fi
}

say_hello(){
cat << "EOF"
       ____            _        _                                  
      / ___|___  _ __ | |_ __ _(_)_ __   ___ _ __                 
     | |   / _ \| '_ \| __/ _` | | '_ \ / _ \ '__|                
     | |__| (_) | | | | || (_| | | | | |  __/ |                   
      \____\___/|_| |_|\__\__,_|_|_| |_|\___|_|                   
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
        echo -e "${greenColour}6 - Delete containers${endColour}"
        echo -e "${greenColour}7 - Delete images${endColour}"
        echo -e "${greenColour}8 - Exit${endColour}"

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
                clear
                delete_containers
                read -p "Press enter to continue..."
                ;;

            7)
                clear
                delete_images
                read -p "Press enter to continue..."
                ;;

            8)
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
        echo -e "${greenColour}[+] Docker is installed${endColour}"
    else
        echo -e "${redColour}[!] Installing Docker...${endColour}"

        apt update -y >/dev/null 2>&1
        apt install -y docker.io >/dev/null 2>&1

        echo -e "${greenColour}[+] Docker installed${endColour}"
        read -p "Press Enter to continue..."
    fi
}

distro_select(){
    echo -e "\n${yellowColour}Select distro:${endColour}"
    echo "1) Ubuntu"
    echo "2) Kali"

    read -p "Option: " option

    if [[ "$option" == "1" ]]; then
        IMAGE="ubuntu_image"
        echo -e "${yellowColour}[+] Building Ubuntu...${endColour}"
        docker build -t "$IMAGE" -f ubuntu.dockerfile .

    elif [[ "$option" == "2" ]]; then
        IMAGE="kali_image"
        echo -e "${yellowColour}[+] Building Kali...${endColour}"
        docker build -t "$IMAGE" -f kali.dockerfile .

    else
        echo -e "${redColour}Invalid option${endColour}"
    fi
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

delete_containers(){

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

    echo
    read -p "Select containers to delete (e.g. 1 2 3): " choices

    for choice in $choices; do

        if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
            echo "Invalid input: $choice"
            continue
        fi

        i=1
        for c in $containers; do
            if [[ "$i" == "$choice" ]]; then
                echo "[+] Deleting $c"
                docker rm -f "$c" >/dev/null 2>&1
            fi
            i=$((i+1))
        done

    done

    echo "Done."
}

delete_images(){

    images=$(docker images --format "{{.Repository}}" | sort -u)

    if [[ -z "$images" ]]; then
        echo "No images found"
        return
    fi

    echo "Available images:"

    i=1
    for img in $images; do
        echo "$i) $img"
        i=$((i+1))
    done

    echo
    read -p "Select images to delete (e.g. 1 2 3): " choices

    for choice in $choices; do

        if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
            echo "Invalid input: $choice"
            continue
        fi

        i=1
        for img in $images; do
            if [[ "$i" == "$choice" ]]; then
                echo "[+] Deleting $img"
                docker rmi -f "$img" >/dev/null 2>&1
            fi
            i=$((i+1))
        done

    done

    echo "Done."
}

main() {
    sleep 1
    check_root
    check_docker
    main_panel
}

main