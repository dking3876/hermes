#!/usr/bin/env bash
filename=$DEPLOYMENTCONFIG/$ACCOUNT-$REPO;
if [ "$TAG" != "" ]
then
    filename+=-$TAG
fi
if [ "$NAME" = "" ]
then
    NAME=$ACCOUNT
fi
cat <<EOL > $filename.deployment.json
{
    "name": "$NAME",
    "account": "$ACCOUNT",
    "repo": "$REPO",
    "tag": "$TAG",
    "deploy": [
        {
            "tag": "$TAG",
            "branch": "$CLONE",
            "beforeinstall": "$BEFOREINSTALL",
            "afterinstall": "$AFTERINSTALL",
            "source": "$SOURCE",
            "target": "$TARGET"
        }
    ]
}
EOL
if [ $? = 0 ]
then
    echo "Succesfully saved deployment for $filename"
else
    echo "There was an error saving your deployment"
fi