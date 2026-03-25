#!/bin/bash

distro_select() {
    echo -e "\n${yellowColour}Select distro:${endColour}"
    echo -e "${yellowColour}1) Ubuntu${endColour}"
    echo -e "${yellowColour}2) Kali${endColour}"

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

select_image() {
    images=$(docker images --format "{{.Repository}}" | sort -u)

    if [[ -z "$images" ]]; then
        echo -e "${redColour}[!] No images found${endColour}"
        return 1
    fi

    echo -e "${yellowColour}[+] Available images:${endColour}"

    i=1
    for img in $images; do
        echo -e "${yellowColour}$i) $img${endColour}"
        i=$((i + 1))
    done

    read -p "Select image: " choice

    if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
        echo -e "${redColour}[!] Invalid input${endColour}"
        return 1
    fi

    i=1
    for img in $images; do
        if [[ "$i" == "$choice" ]]; then
            IMAGE="$img"
            CONTAINER="$(echo "$img" | tr ':' '_')_container"
            return
        fi
        i=$((i + 1))
    done

    echo -e "${redColour}[!] Invalid option${endColour}"
    return 1
}

delete_images() {
    images=$(docker images --format "{{.Repository}}" | sort -u)

    if [[ -z "$images" ]]; then
        echo -e "${redColour}[!] No images found${endColour}"
        return
    fi

    echo -e "${yellowColour}[+] Available images:${endColour}"

    i=1
    for img in $images; do
        echo -e "${yellowColour}$i) $img${endColour}"
        i=$((i + 1))
    done

    echo -e ""
    read -p "Select images to delete (e.g. 1 2 3): " choices

    for choice in $choices; do
        if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
            echo -e "${redColour}[!] Invalid input: $choice${endColour}"
            continue
        fi

        i=1
        for img in $images; do
            if [[ "$i" == "$choice" ]]; then
                echo -e "${redColour}[+] Deleting $img${endColour}"
                docker rmi -f "$img" >/dev/null 2>&1
            fi
            i=$((i + 1))
        done
    done

    echo -e "${greenColour}[+] Done.${endColour}"
}
