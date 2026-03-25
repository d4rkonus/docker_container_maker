#!/bin/bash

# Colours
greenColour="\033[1;32m"
endColour="\033[0m"
redColour="\033[1;31m"
yellowColour="\033[1;33m"
grayColour="\033[1;37m"

container_maker() {
    select_images || return

    echo -e "\n${yellowColour}[+] Creating container...${endColour}"

    docker rm -f "$CONTAINER" >/dev/null 2>&1 || true
    docker run -dit --name "$CONTAINER" "$IMAGE" >/dev/null 2>&1

    echo -e "${greenColour}[+] Container created: $CONTAINER${endColour}"
}

run_container() {
    containers=$(docker ps -a --format "{{.Names}}" 2>/dev/null)

    if [[ -z "$containers" ]]; then
        echo -e "${redColour}[!] No containers found${endColour}"
        return
    fi

    echo -e "${yellowColour}[+] Available containers:${endColour}"

    i=1
    for c in $containers; do
        echo -e "${yellowColour}$i) $c${endColour}"
        i=$((i + 1))
    done

    read -p "Select container: " choice

    if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
        echo -e "${redColour}[!] Invalid input${endColour}"
        return
    fi

    i=1
    for c in $containers; do
        if [[ "$i" == "$choice" ]]; then
            docker start "$c" >/dev/null 2>&1
            docker exec -it "$c" bash 2>/dev/null
            return
        fi
        i=$((i + 1))
    done

    echo -e "${redColour}[!] Invalid option${endColour}"
}

delete_containers() {
    containers=$(docker ps -a --format "{{.Names}}" 2>/dev/null)

    if [[ -z "$containers" ]]; then
        echo -e "${redColour}[!] No containers found${endColour}"
        return
    fi

    echo -e "${yellowColour}[+] Available containers:${endColour}"

    i=1
    for c in $containers; do
        echo -e "${yellowColour}$i) $c${endColour}"
        i=$((i + 1))
    done

    echo -e ""
    read -p "Select containers to delete (e.g. 1 2 3): " choices

    for choice in $choices; do
        if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
            echo -e "\nInvalid input: $choice"
            continue
        fi

        i=1
        for c in $containers; do
            if [[ "$i" == "$choice" ]]; then
                echo -e "${redColour}[+] Deleting $c${endColour}"
                docker rm -f "$c" >/dev/null 2>&1
            fi
            i=$((i + 1))
        done
    done

    echo -e "${greenColour}Done.${endColour}"
}
