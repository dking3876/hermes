#!/usr/bin/env bash
echo "#########################################################"
echo "##"
echo "##        Hermes Automated Deployment"
echo "##"
echo "#########################################################"
echo "It does not appear Hermes has been installed."
per=0
dest=$1
orig=$(dirname $0)
echo $orig
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
            cp -R "$orig"/../../app "$dest"
            chmod -R +x "$dest"/app/*.sh
            chmod +x "$dest"/app/hermes-ci
            echo -ne '\n'
            echo "Hermes installation completed";
            #Create symlink to heremes file in the bin path to use everywhere
            ln -sf "$dest"/app/hermes-ci /bin/hermes-ci
            useradd -r -s /bin/false hermes-ci
            chown -R hermes-ci:hermes-ci "$dest"
            #store ssh-agent header for use for pulls and clones
            (crontab -l 2>/dev/null; echo "@reboot hermes-ci sshconfig") | crontab -
            #(crontab -l 2>/dev/null; echo "*/2 * * * * hermes sshconfig") | crontab -
            exit;;
        [Nn]* ) exit 150;;
        * ) echo "Please answer yes or no.";;
    esac
done