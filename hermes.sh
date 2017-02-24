#!/usr/bin/env bash
#LOCATION OF THIS SCRIPT
SCRIPTDIR=$(dirname $0)
source "$SCRIPTDIR"/app/functions.sh
source "$SCRIPTDIR"/app/env.conf
#parse_yaml "$SCRIPTDIR"/test.yml
#check if install was passed and folder doesn't exist. Do Installation if both are true
if [ ! -d "$ROOT" -a $1 = "install" ]
then
	/bin/bash "$SCRIPTDIR"/app/modules/install.sh $ROOT $DEPLOYS $LOGS $KEYS $DEPLOYMENTCONFIG
	if [ "$?" = 150 ]
	then
		usage
	fi
	exit
else
	echo "Hermes is already installed. To update run:"
	echo "hermes update as root"
	usage
fi