#!/usr/bin/env bash
filename=$DEPLOYMENTCONFIG/$ACCOUNT-$REPO;
if [ "$NAME" = "" ]
then
    NAME=$ACCOUNT
fi
cat <<EOL > $filename.deployment.json
{
    "name": "$NAME",
    "account": "$ACCOUNT",
    "repo": "$REPO",
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
if [ $? = 0 ]
then
    echo "Succesfully saved deployment for $filename . Run hermes-ci deploy --config $filename --tag $tag to run this deployment"
else
    echo "There was an error saving your deployment"
fi