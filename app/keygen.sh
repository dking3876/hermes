#!/usr/bin/env bash
KEYS=$1
echo "$KEYS"/"$2" | ssh-keygen -t rsa
echo $?
if [ "$?" = 0 ]
then
	mv "$KEYS"/"$2" "$KEYS"/"$2".pem
fi
echo "Keypair generated"
echo "Public Key:"
cat "$KEYS"/"$2".pub