#!/usr/bin/env bash
sudo -u hermes-ci ssh-keygen -f "$KEYS"/"$REPO" -t rsa -P ""
if [ "$?" = 0 ]
then
	mv "$KEYS"/"$REPO" "$KEYS"/"$REPO".pem
fi
#source REPO
source "$SSHCONFIG" && ssh-add "$KEYS"/"$REPO".pem
echo "Keypair generated"
echo "Adding key pair to $SERVICE repository"
if [ "$SERVICE" = "GIT" ]
then
	pubKey=$(cat "$KEYS"/"$REPO".pub)
	title=${pubKey/*}
	json=$( printf '{"title": "%s", "key": "%s"}' "$title" "$pubKey")
	if [ -f $ROOT/app/keys/GIT-token.txt ]
	then
		echo "using token"
		curl -H "Authorization: token $OAUTHTOKEN" -s -d "$json" https://api.github.com/repos/$ACCOUNT/$REPO/keys
	else
		read -p "Enter Your github Username: " Username
		curl -u "$Username" -s -d "$json" https://api.github.com/repos/$ACCOUNT/$REPO/keys
	fi
fi
if [ "$SERVICE" = "BIT" ]
then
	pubKey=$(cat "$KEYS"/"$REPO".pub)
	title=${pubKey/*}
	if [ -f $ROOT/app/keys/BIT-token.txt ]
	then
		echo "using token"
		curl -X POST -H "Authorization: Bearer $OAUTHTOKEN" https://api.bitbucket.org/1.0/repositories/$ACCOUNT/$REPO/deploy-keys --data-urlencode "key=$pubKey" --data-urlencode "label=$title"
	else
		read -p "Enter Your bitbucket Username: " Username
		curl -X POST -u "$Username" https://api.bitbucket.org/1.0/repositories/$ACCOUNT/$REPO/deploy-keys --data-urlencode "key=$pubKey" --data-urlencode "label=$title"
	fi
fi
echo ""
exit