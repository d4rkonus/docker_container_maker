#!/bin/bash

# Colours
greenColour="\033[1;32m"
endColour="\033[0m"
redColour="\033[1;31m"
yellowColour="\033[1;33m"
grayColour="\033[1;37m"


distro_select() {
    echo -e "\n${greenColour}Choose your distro:${endColour}\n"
    echo -e "${yellowColour}1 - Ubuntu${endColour}"
    echo -e "${yellowColour}2 - Kali Linux${endColour}"
    echo -e "${yellowColour}3 - Arch Linux${endColour}"

    read -p "[+] Give me a number: " number

    if [[ $number == "1" ]]; then
        image="ubuntu"
        echo -e "\n${greenColour}[+] Bulding image...${endColour}"
        docker build -t $image -f .ubuntu.dockerfile . &>/dev/null
        echo -e "\n${yellowColour}[+] Ubuntu image successfully built!${endColour}"
        pause
    else
        echo -e "\n${redColour}[!] Invalid option.${endColour}"
        return 1
    fi

    if [[ $number == "2" ]]; then
        image="kali"
        echo -e "\n${greenColour}[+] Bulding image...${endColour}"
        docker build -t $image -f .kali.dockerfile . &>/dev/null
        echo -e "\n${yellowColour}[+] Kali Linux image successfully built!${endColour}"
        pause
    else
        echo -e "\n${redColour}[!] Invalid option.${endColour}"
        return 1
    fi

    if [[ $number == "3" ]]; then
        image="arch"
        echo -e "\n${greenColour}[+] Bulding image...${endColour}"
        docker build -t $image -f .arch.dockerfile . &>/dev/null
        echo -e "\n${yellowColour}[+] Arch Linux image successfully built!${endColour}"
        pause
    else
        echo -e "\n${redColour}[!] Invalid option.${endColour}"
        return 1
    fi
}

select_images(){

    # Devuelve una lista de con las imágenes que existen.
    images=$(docker images --format "{{.Repository}}" 2>/dev/null | sort -u)

    if [[ -z "$images" ]]; then
        echo -e "\n${redColour}[+] No images available!${endColour}"
        return 1
    fi

    echo -e "\n${greenColour}Available images:${endColour}\n"

   number=1
   for image in $images; do
        echo -e "${yellowColour}${number} - ${image}${endColour}"
        number=$((number + 1))
   done

    # Lee la opción del usuario y valida que sea un número.
    read -p "[+] Select an image: " image_number

    if ! [[ "$image_number" =~ ^[0-9]+$ ]]; then
        echo -e "\n${redColour}[!] Invalid option. Give me a number.${endColour}"
        return 1
    fi

    number=1
    for image in $images; do
        if [[ "$number" == "$image_number" ]]; then
        IMAGE="$image"
        CONTAINER="$(echo $IMAGE | tr ':' '_')_container"
        return 0
        fi
        number=$((number + 1))
    done
    echo -e "\n${redColour}[!] Invalid option.${endColour}"
    return 1

}


delete_images(){
    images=$(docker images --format "{{.Repository}}" 2>/dev/null | sort -u 2>/dev/null)

     if [[ -z "$images" ]]; then
        echo -e "\n${redColour}[+] No images available!${endColour}"
        return 1
    fi

    echo -e "${yellowColour}[+] Available images:${endColour}"

    number=1
    for image in $images; do
        echo -e "${yellowColour}$number) $image${endColour}"
        number=$((number + 1))
    done

    echo -e ""
    read -p "Select images to delete (e.g. 1 2 3): " choices

    for choice in $choices; do
        if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
            echo -e "${redColour}[!] Invalid input: $choice${endColour}"
            continue
        fi

    number=1
    for image in $images; do
        if [[ "$number" == "$choice" ]]; then
            docker rmi -f "$image" >/dev/null 2>&1
            echo -e "${redColour}[+] Image deleted: $image${endColour}."
        fi
        number=$((number + 1))
    done
done
}