#!/usr/bin/env bash
ACTION=$1
case $ACTION in
    install) 
        echo "install";
        source app/env.conf;
        echo "$TYPE";
        #source install file
        exit;;
    update) 
        echo "update"
        #source update file
        exit;;
    keygen)
        echo "keygen";
        #source keygen function
        exit;;
    man) 
        echo "manual"
        #cat man file
        exit;;
    deploy) 
        echo "deployment";
        #source deployment script
        exit;;
    *)
        echo "unknown action";
        exit;;
esac
eval set -- $options
echo "$1 $2"