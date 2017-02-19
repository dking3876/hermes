#!/usr/bin/env bash
if [ ! -d "$DEPLOYS/$ACCOUNT" ]
then
    mkdir "$DEPLOYS/$ACCOUNT"
fi
echo "Setup Config file"
echo "export ACCOUNT=$ACCOUNT" > "$DEPLOYS/$ACCOUNT"/deployment.conf
echo "export REPO=$REPO" >> "$DEPLOYS/$ACCOUNT"/deployment.conf 
echo "export BRANCH=$BRANCH" >> "$DEPLOYS/$ACCOUNT"/deployment.conf 
echo "export TYPE=$TYPE" >> "$DEPLOYS/$ACCOUNT"/deployment.conf 
echo "export SOURCE=$SOURCE" >> "$DEPLOYS/$ACCOUNT"/deployment.conf 
echo "export TARGET=$TARGET" >> "$DEPLOYS/$ACCOUNT"/deployment.conf 
echo "export HERMESUSER=$HERMESUSER" >> "$DEPLOYS/$ACCOUNT"/deployment.conf 
echo "export GROUP=$GROUP" >> "$DEPLOYS/$ACCOUNT"/deployment.conf 
echo "export SERVICE=$SERVICE" >> "$DEPLOYS/$ACCOUNT"/deployment.conf 
echo "export BEFOREINSTALL=$BEFOREINSTALL" >> "$DEPLOYS/$ACCOUNT"/deployment.conf 
echo "export AFTERINSTALL=$AFTERINSTALL" >> "$DEPLOYS/$ACCOUNT"/deployment.conf 