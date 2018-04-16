#!/bin/bash

source options

tput setaf 28; clear
printf "Welcome to Eurélis game by Quozul!\n"
tput setaf 0

if $first_launch; then # If this is the first launch

    printf "It looks like this is the first launch of the game.\nWe'll process to the setup of the game."
    sed -i 's/first_launch=.*/first_launch=false/' options

    read -srn1 "Press any key to continue or ^C to quit."

    ## Software Installation

    sudo apt-get update
    sudo apt-get install bash   # Updating bash
    sudo apt-get install shuf
    sudo apt-get install tput

else

    printf "\nRemember to start every files using 'bash' command otherwise this will not work using 'sh' command. If you having trouble executing any files provided with Eurélis, go to the GitHub page and read the wiki.\n"
fi

printf "The game will launch soon.\n"
