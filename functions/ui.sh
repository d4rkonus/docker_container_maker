#!/bin/bash

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

main_panel() {
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
                echo -e ""
                read -p "Press enter to continue..."
                ;;

            2)
                clear
                docker ps -a
                echo -e ""
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
