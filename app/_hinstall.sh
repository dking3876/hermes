#!/usr/bin/env bash
echo ""
echo "Hermes Automated Deployment"
echo "................................"
echo "It does not appear Hermes has been installed."
per=0
dest=$1
orig=$(dirname $0)
echo "$orig"
while true; do
    read -p "Would you like to install Hermes now? [y/n] " answer
    case $answer in
        [Yy]* ) 
            echo -ne "|"
            while [ $per -lt 7 ]; do
                echo -ne "##"
                sleep 1
                ((per++))
            done
            echo -ne '##|(100%)'
            sleep 1
            while [ $# -gt 0 ]
            do 
                mkdir "$1"; shift;
            done
            cp -R "$orig" "$dest"
            chmod +x "$dest"/app/*.sh
            chmod +x "$dest"/app/hermes
            echo -ne '\n'
            echo "Hermes installation completed";
            #Create symlink to heremes file in the bin path to use everywhere
            ln -sf "$dest"/app/hermes /bin/hermes
            exit;;
        [Nn]* ) exit 150;;
        * ) echo "Please answer yes or no.";;
    esac
done