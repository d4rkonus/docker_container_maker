#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colours
greenColour="\033[1;32m"
endColour="\033[0m"
redColour="\033[1;31m"
yellowColour="\033[1;33m"
grayColour="\033[1;37m"

source "$SCRIPT_DIR/functions/system.sh"
source "$SCRIPT_DIR/functions/images.sh"
source "$SCRIPT_DIR/functions/containers.sh"
source "$SCRIPT_DIR/functions/ui.sh"

main() {
    sleep 1 >/dev/null 2>&1
    check_root
    check_docker
    main_panel
}

main