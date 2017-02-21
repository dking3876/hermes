#!/usr/bin/env bash
echo "starting run $(date)" 2>&1 | tee "$LOGS/$ACCOUNT"_"$REPO" 
if [ "$BRANCH" != "" ]
then
    BRANCH="_$BRANCH"
fi
if [ -d "$DEPLOYS/$ACCOUNT/$REPO$BRANCH" ]
then
	echo "fetching branch $BRANCH from $REPO" >> "$LOGS/$ACCOUNT"_"$REPO"
    res=$( cd $DEPLOYS/$ACCOUNT/$REPO$BRANCH && git pull )
else
    if [ ! -d "$DEPLOYS/$ACCOUNT" ]
    then
        mkdir "$DEPLOYS/$ACCOUNT"
    fi
	echo "cloning repo $REPO" >> "$LOGS/$ACCOUNT"_"$REPO"
    if [ "$BRANCH" != "" ]
    then
        withbranch=-b "$BRANCH"
    fi
    echo $SERVICE
    if [ "$SERVICE" = "GIT" ]
    then
        echo "git is the service"
        #configure git string
        url="https://github.com/$ACCOUNT/$REPO.git"
        if [ "$TYPE" = "ssh" ]
        then
            #get ssh config file and change string
            #source /home/ec2-user/ssh-agent.config
            url="git@github.com:$ACCOUNT/$REPO.git"
        fi
    fi
    if [ "$SERVICE" = "BIT" ]
    then
        #configure bitbucket string
        echo "bitbucket selected"
    else
        echo "Unrecognized Service Provided: $SERVICE"
        #exit 153
    fi
    (git clone $withbranch "$url" $DEPLOYS/$ACCOUNT/$REPO$BRANCH) &>> "$LOGS/$ACCOUNT"_"$REPO"
fi
if [ "$res" = "Already up-to-date." ]
then
	echo "No recent changes to $REPO" &>> "$LOGS/$ACCOUNT"_"$REPO"
else
	echo "Intializing deployment of $REPO" &>> "$LOGS/$ACCOUNT"_"$REPO"
    if [ ! -d $TARGET ]
    then 
        mkdir $TARGET
    fi
	cp -R "$DEPLOYS/$ACCOUNT/$REPO$BRANCH"/* "$TARGET" &>> "$LOGS/$ACCOUNT"_"$REPO"
	chmod -R 775 "$TARGET"
	#find "$TARGET" -type d -exec chmod 775 {} +
	chown -R deryk:deryk "$TARGET"
fi
exit