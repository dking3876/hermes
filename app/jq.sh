#!/usr/bin/env bash
keys=( NAME ACCOUNT REPO BRANCH)
for var in "${keys[@]}"
do
    key=$(echo "$var" | awk '{print tolower($0)}')
    id=$(cat $configfile | jq '.'$key)
    eval "$var"=$id
done
declare -a SCRIPTS
object=$(cat $configfile | jq -c '.scripts[]?')
if [ "$object" != "" ]
then
    for ((i=0;i< ${#object[@]}; i++))
    do
        SCRIPTS+=( ${object[i]} )
    done
fi
tmpglobal=$(cat $configfile | jq '.global | keys[]')
IFS=' ' read -r -a globals <<< $tmpglobal
for curkey in ${globals[@]}
do
    el=$curkey
    curkey="${curkey#\"}"
    curkey="${curkey%\"}"
    curkey=$(echo "$curkey" | awk '{print toupper($0)}')
    val=$(cat $configfile | jq '.global.'$el)
    eval "GLOBAL_$curkey"="$val"
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
            if [ "$c_tag" != "$SETTAG" ]
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
done