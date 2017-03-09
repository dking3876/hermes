#!/usr/bin/env bash
source $ROOT/app/modules/reportcleanup.sh
echo "starting run $(date)" 2>&1 | tee -a "$LOGS/$ACCOUNT"_"$REPO" 
newdeploy=0
source $SSHCONFIG
FULLPATH=$DEPLOYS/$ACCOUNT/$REPO
if [ "$BRANCH" != "" ]
then
    FULLPATH="$DEPLOYS/$ACCOUNT/$REPO"_"$BRANCH"
fi
if [ -d "$FULLPATH" ]
then
	echo "Checking $BRANCH from $REPO for changes" 2>&1 | tee -a "$LOGS/$ACCOUNT"_"$REPO" 
    res=$( cd $FULLPATH && git pull )
    echo "$res" 2>&1 | tee -a "$LOGS/$ACCOUNT"_"$REPO"
else
    if [ ! -d "$DEPLOYS/$ACCOUNT" ]
    then
        mkdir "$DEPLOYS/$ACCOUNT"
    fi
	echo "cloning repo $REPO" 2>&1 | tee -a "$LOGS/$ACCOUNT"_"$REPO" 
    if [ "$BRANCH" != "" ]
    then
        withbranch="-b $BRANCH"
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
        #echo "Unrecognized Service Provided: $SERVICE"
        echo "" 
        #exit 153
    fi
    newdeploy=1
    (git clone $withbranch "$url" $FULLPATH) 2>&1 | tee -a "$LOGS/$ACCOUNT"_"$REPO" 
fi
if [ "$res" != "Already up-to-date." -o $newdeploy = 1 ]
then
    HERMES_ROOT=$FULLPATH
    if [ -f $FULLPATH/hermes.json ]
    then
        echo "hermes.json file provided. Overridding default deployment..." 2>&1 | tee -a "$LOGS/$ACCOUNT"_"$REPO" 
        configfile=$FULLPATH/hermes.json
        source $ROOT/app/jq.sh
    fi
    if [ "$SCRIPTS" != "" ]
    then
        for ((i=0;i< ${#SCRIPTS[@]}; i++))
        do
            SCRIPT=${SCRIPTS[i]}
            cd $FULLPATH && executecmd $SCRIPT
        done
    fi
    if [ "$BEFOREINSTALL" != "" ]
    then
        echo "Procesing $BEFOREINSTALL script..." 2>&1 | tee -a "$LOGS/$ACCOUNT"_"$REPO" 
        eval source $FULLPATH/$BEFOREINSTALL 2>&1 | tee -a "$LOGS/$ACCOUNT"_"$REPO"
    fi
    if [ "$TARGET" != "" ]
    then
        echo "Intializing deployment of $REPO" 2>&1 | tee -a "$LOGS/$ACCOUNT"_"$REPO" 
        if [ ! -d $TARGET ]
        then 
            mkdir $TARGET 2>&1 | tee -a "$LOGS/$ACCOUNT"_"$REPO" 
        fi
        if [ "$SOURCE" != "" ]
        then    
            SOURCE="/$SOURCE"
        fi
        cp -R "$FULLPATH$SOURCE"/* "$TARGET" 2>&1 | tee -a "$LOGS/$ACCOUNT"_"$REPO" 
    fi
    if [ "$AFTERINSTALL" != "" ]
    then
        echo "Procesing $AFTERINSTALL script..." 2>&1 | tee -a "$LOGS/$ACCOUNT"_"$REPO" 
        eval source $FULLPATH/$AFTERINSTALL 2>&1 | tee -a "$LOGS/$ACCOUNT"_"$REPO" 
    fi
    #this should be in an after install script
else
    	echo "No recent changes to $REPO" 2>&1 | tee -a "$LOGS/$ACCOUNT"_"$REPO" 
fi