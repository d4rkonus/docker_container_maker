#!/bin/bash

select_images(){
    mapfile -t images < <(docker images --format "{{.Repository}}" | sort -u)

    if [[ ${#images[@]} -eq 0 ]]; then
        echo -e "\n${redColour}[!] No images available${endColour}"
        return 1
    fi

    echo -e "\n${greenColour}Available images:${endColour}\n"

    for i in "${!images[@]}"; do
        echo -e "${yellowColour}$((i+1)) - ${images[i]}${endColour}"
    done

    read -p "[+] Select an image: " choice

    if ! [[ "$choice" =~ ^[0-9]+$ ]] || (( choice < 1 || choice > ${#images[@]} )); then
        echo -e "\n${redColour}[!] Invalid option${endColour}"
        return 1
    fi

    IMAGE="${images[choice-1]}"
    CONTAINER="${IMAGE//:/_}_container"
}

distro_select() {
    echo -e "\n${greenColour}Choose your distro:${endColour}\n"
    echo -e "${yellowColour}1 - Ubuntu${endColour}"
    echo -e "${yellowColour}2 - Kali Linux${endColour}"
    echo -e "${yellowColour}3 - Arch Linux${endColour}"

    read -p "[+] Give me a number: " number

    case $number in
        1)
            docker build -t ubuntu -f ubuntu.dockerfile . &>/dev/null
            echo -e "\n${greenColour}[+] Ubuntu built${endColour}"
            ;;
        2)
            docker build -t kali -f kali.dockerfile . &>/dev/null
            echo -e "\n${greenColour}[+] Kali built${endColour}"
            ;;
        3)
            docker build -t arch -f arch.dockerfile . &>/dev/null
            echo -e "\n${greenColour}[+] Arch built${endColour}"
            ;;
        *)
            echo -e "\n${redColour}[!] Invalid option${endColour}"
            return 1
            ;;
    esac
}

delete_images(){
    mapfile -t images < <(docker images --format "{{.Repository}}" | sort -u)

    [[ ${#images[@]} -eq 0 ]] && {
        echo -e "\n${redColour}[!] No images${endColour}"
        return
    }

    for i in "${!images[@]}"; do
        echo "$((i+1))) ${images[i]}"
    done

    read -p "Select images to delete: " choices

    for choice in $choices; do
        if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >=1 && choice <= ${#images[@]} )); then
            img="${images[choice-1]}"
            docker rmi -f "$img" &>/dev/null
            echo -e "${redColour}[+] Deleted: $img${endColour}"
        fi
    done
}