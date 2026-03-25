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
        clear >/dev/null 2>&1
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
                clear >/dev/null 2>&1
                docker images >/dev/null 2>&1
                echo -e ""
                read -p "Press enter to continue..."
                clear >/dev/null 2>&1
                ;;

            2)
                clear >/dev/null 2>&1
                docker ps -a >/dev/null 2>&1
                echo -e ""
                read -p "Press enter to continue..."
                clear >/dev/null 2>&1
                ;;

            3)
                clear >/dev/null 2>&1
                distro_select
                read -p "Press enter to continue..."
                clear >/dev/null 2>&1
                ;;

            4)
                clear >/dev/null 2>&1
                container_maker
                read -p "Press enter to continue..."
                clear >/dev/null 2>&1
                ;;

            5)
                clear >/dev/null 2>&1
                run_container
                read -p "Press enter to continue..."
                clear >/dev/null 2>&1

                ;;

            6)
                clear >/dev/null 2>&1
                delete_containers
                read -p "Press enter to continue..."
                clear >/dev/null 2>&1
                ;;

            7)
                clear >/dev/null 2>&1
                delete_images
                read -p "Press enter to continue..."
                clear >/dev/null 2>&1
                ;;

            8)
                exit 0
                ;;

            *)
                echo -e "${redColour}[!] Invalid option.${endColour}"
                sleep 1 >/dev/null 2>&1
                ;;
        esac
    done
}
