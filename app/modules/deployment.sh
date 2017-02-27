#!/usr/bin/env bash
echo "starting run $(date)" 2>&1 | tee -a "$LOGS/$ACCOUNT"_"$REPO" 
newdeploy=0
source $SSHCONFIG
if [ "$BRANCH" != "" ]
then
    CLONE=$BRANCH
    BRANCH="_$BRANCH"
fi
if [ -d "$DEPLOYS/$ACCOUNT/$REPO$BRANCH" ]
then
	echo "Checking $CLONE from $REPO for changes" 2>&1 | tee -a "$LOGS/$ACCOUNT"_"$REPO" 
    res=$( cd $DEPLOYS/$ACCOUNT/$REPO$BRANCH && git pull )
    echo "$res" 2>&1 | tee -a "$LOGS/$ACCOUNT"_"$REPO"
else
    if [ ! -d "$DEPLOYS/$ACCOUNT" ]
    then
        mkdir "$DEPLOYS/$ACCOUNT"
    fi
	echo "cloning repo $REPO" 2>&1 | tee -a "$LOGS/$ACCOUNT"_"$REPO" 
    if [ "$BRANCH" != "" ]
    then
        withbranch="-b $CLONE"
    fi
    echo $SERVICE
    if [ "$SERVICE" = "GIT" ]
    then
        #get ssh config file and change string
        url="git@github.com:$ACCOUNT/$REPO.git"
    fi
    if [ "$SERVICE" = "BIT" ]
    then
        #configure bitbucket string
        echo "bitbucket selected"
        url="git@bitbucket.org:$ACCOUNT/$REPO.git"
    else
        echo "Unrecognized Service Provided: $SERVICE"
        #exit 153
    fi
    newdeploy=1
    (git clone $withbranch "$url" $DEPLOYS/$ACCOUNT/$REPO$BRANCH) 2>&1 | tee -a "$LOGS/$ACCOUNT"_"$REPO" 
fi
if [ "$res" != "Already up-to-date." -o $newdeploy = 1 ]
then
    if [ -f $DEPLOYS/$ACCOUNT/$REPO$BRANCH/hermes.json ]
    then
        echo "using config file from repo"
        configfile=$DEPLOYS/$ACCOUNT/$REPO$BRANCH/hermes.json
        source $ROOT/app/jq.sh
    fi

    if [ "$SCRIPTS" != "" ]
    then
        echo "Do 'scripts'"
    fi
    if [ "$BEFOREINSTALL" != "" ]
    then
        echo "do 'beforeintall'"
        eval $BEFOREINSTALL
    fi
	echo "Intializing deployment of $REPO" 2>&1 | tee -a "$LOGS/$ACCOUNT"_"$REPO" 
    if [ ! -d $TARGET ]
    then 
        mkdir $TARGET
    fi
	cp -R "$DEPLOYS/$ACCOUNT/$REPO$BRANCH"/* "$TARGET" 2>&1 | tee -a "$LOGS/$ACCOUNT"_"$REPO" 
    if [ "$AFTERINSTALL" != "" ]
    then
        echo "do 'afterinstall'"
        eval $AFTERINSTALL
    fi
    #this should be in an after install script
	chmod -R 775 "$TARGET"
	#find "$TARGET" -type d -exec chmod 775 {} +
	chown -R deryk:deryk "$TARGET"
else
    	echo "No recent changes to $REPO" 2>&1 | tee -a "$LOGS/$ACCOUNT"_"$REPO" 
fi