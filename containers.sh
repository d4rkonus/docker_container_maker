#!/bin/bash

container_maker() {
    select_images || return

    echo -e "\n${yellowColour}[+] Creating container...${endColour}"

    docker rm -f "$CONTAINER" &>/dev/null || true
    docker run -dit --name "$CONTAINER" "$IMAGE" &>/dev/null

    echo -e "${greenColour}[+] Container created: $CONTAINER${endColour}"
}

run_container() {
    mapfile -t containers < <(docker ps -a --format "{{.Names}}")

    [[ ${#containers[@]} -eq 0 ]] && {
        echo -e "${redColour}[!] No containers${endColour}"
        return
    }

    for i in "${!containers[@]}"; do
        echo "$((i+1))) ${containers[i]}"
    done

    read -p "Select container: " choice

    if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >=1 && choice <= ${#containers[@]} )); then
        c="${containers[choice-1]}"
        docker start "$c" &>/dev/null
        docker exec -it "$c" bash
    else
        echo -e "${redColour}[!] Invalid option${endColour}"
    fi
}

delete_containers() {
    mapfile -t containers < <(docker ps -a --format "{{.Names}}")

    [[ ${#containers[@]} -eq 0 ]] && {
        echo -e "${redColour}[!] No containers${endColour}"
        return
    }

    for i in "${!containers[@]}"; do
        echo "$((i+1))) ${containers[i]}"
    done

    read -p "Select containers to delete: " choices

    for choice in $choices; do
        if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >=1 && choice <= ${#containers[@]} )); then
            c="${containers[choice-1]}"
            docker rm -f "$c" &>/dev/null
            echo -e "${redColour}[+] Deleted: $c${endColour}"
        fi
    done
}