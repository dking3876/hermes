#!/usr/bin/env bash
KEYS=$1
CONF=$2
ssh-agent -s | head -n 1 > $CONF
if [ "$(ls -A $KEYS)" ]; then
     for file in "$KEYS"/*.pem
    do
        source "$CONF" && ssh-add "$file"
    done
fi

