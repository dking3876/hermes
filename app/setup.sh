#!/usr/bin/env bash
filename=$DEPLOYMENTCONFIG/$ACCOUNT-$REPO;
if [ -f $filename.deployment.json ]
then
    echo "file exists need to check if tag exists and if not add it to the deploy array"
    #check for tag

    #tag does not exist in deploy array setup new deployment
    exists=$(cat $filename.deployment.json | jq '.deploy[] | select(.tag=="'$TAG'")')
    if [ "$exists" != "" ]
    then
        #add new deployment to array and save new deployment file
    content=$(cat $filename.deployment.json | jq '.deploy |= .+ [{
        "tag": "'$TAG'",
        "branch": "'$BRANCH'",
        "beforeinstall": "'$BEFOREINSTALL'",
        "afterinstall": "'$AFTERINSTALL'",
        "source": "'$SOURCE'",
        "target": "'$TARGET'"
    }]')
        echo $content > $filename.deployment.json
        if [ $? = 0 ]
        then
            echo "Succesfully saved deployment for $filename . Run hermes-ci deploy --config $filename --tag $TAG to run this deployment"
        else
            echo "There was an error saving your deployment"
        fi
    else
        echo "Deployement already exists with $TAG tag.  To modify a deployment it is best to add a hermes.json file to your project.  You can alternatively modify the deployment file manually"
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