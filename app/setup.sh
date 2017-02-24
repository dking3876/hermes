#!/usr/bin/env bash
filename=$DEPLOYMENTCONFIG/$ACCOUNT-$REPO;
if [ "$TAG" != "" ]
then
    filename+=-$TAG
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
            "branch": "$BRANCH",
            "beforeinstall": "$BEFOREINSTALL",
            "afterinstall": "$AFTERINSTALL",
            "source": "$SOURCE",
            "target": "$TARGET"
        }
    ]
}
EOL