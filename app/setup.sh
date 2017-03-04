#!/usr/bin/env bash
filename=$DEPLOYMENTCONFIG/$ACCOUNT-$REPO;
if [ -f $filename ]
then
    echo "file exists need to check if tag exists and if not add it to the deploy array"
    #check for tag

    #tag does not exist in deploy array setup new deployment
    newdeploy=<<EOL
{
    "tag": "$TAG",
    "branch": "$BRANCH",
    "beforeinstall": "$BEFOREINSTALL",
    "afterinstall": "$AFTERINSTALL",
    "source": "$SOURCE",
    "target": "$TARGET"
}
EOL
    #add new deployment to array and save new deployment file
    content=$(cat $filename | jq .deploy |= .+ [$newdeploy])
    echo $content > $filename.deployment.json
    if [ $? = 0 ]
    then
        echo "Succesfully saved deployment for $filename . Run hermes-ci deploy --config $filename --tag $tag to run this deployment"
    else
        echo "There was an error saving your deployment"
    fi
else
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
fi