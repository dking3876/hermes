#!/usr/bin/env bash
keys=( NAME ACCOUNT REPO BRANCH)
for var in "${keys[@]}"
do
    key=$(echo "$var" | awk '{print tolower($0)}')
    id=$(cat $configfile | jq '.'$key)
    eval "$var"=$id
done
declare -a SCRIPTS
object=$(cat $configfile | jq -c '.scripts[]')
for ((i=0;i< ${#object[@]}; i++))
do
    SCRIPTS+=( ${object[i]} )
done

SETTAG=$TAG
DEPLOYMENT=( TAG BRANCH SOURCE TARGET BEFOREINSTALL AFTERINSTALL )
deploys=$(cat $configfile | jq '.deploy')
count=$(cat $configfile | jq '.deploy | length')
for ((i=0; i<$count; i++));
do
    for var in "${DEPLOYMENT[@]}"
    do
        eval "$var="
        flag=1
        key=$(echo "$var" | awk '{print tolower($0)}')
        id=$(cat $configfile | jq '.deploy['$i'].'$key)
        if [ "$key" = "tag" ]
        then
            eval "c_tag"=$id
            if [ $c_tag != $SETTAG ]
            then
            flag=0
                break
            fi
        fi
        if [ $id = null ]
        then
            continue
        fi
        eval "$var=$id"
    done
    if [ $flag = configfile ]
    then
        #DO DEPLOYMENT WITH ALL VARS SOURCE
        #echo "Deployment Configuration"
        #echo "Name: $NAME"
        #echo "Account: $ACCOUNT"
        #echo "Repo: $REPO"
        #echo "Branch: $BRANCH"
        #echo "Tag: $TAG"
        #echo "Scripts: ${SCRIPTS[@]}"
        #echo "Source: $SOURCE"
        #echo "Target: $TARGET"
        #echo "User: $HERMESUSER"
        #echo "Group: $GROUP"
        #echo "Service: $SERVICE"
        #echo "BeforeInstall: $BEFOREINSTALL"
        #echo "AfterInstall: $AFTERINSTALL"
    fi
done