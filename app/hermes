#!/usr/bin/env bash
#GIT OR BITBUCKET /OTHER SERVICES LATER
SERVICE="GIT"
#ACCOUNT NAME (ie: github.com/dking3876)
ACCOUNT=""
#REPO NAME (ie: hermes)
REPO=""
#BRANCH (ie: master)
BRANCH=""
#TYPE OF DEPLOY (http|ssh)
TYPE=http
#FOLDER IN REPO FOR DEPLOYMENT
SOURCE=""
#DESIGNATION FOR DEPLOYMENT
TARGET=""
#install Cron job
AUTO=0
#save config file for running later
SAVE=0
#If config flag is set no deployment happens now, only configuration file setup
CONFIG=0
#Linux Version to determine if yum or apt-get
VERSION=$(cat /etc/*-release | grep ID_LIKE | sed -e 's/.*=//')
#Root for intallation and Hermes applicaiton
ROOT=/var/opt/hermesdeployment
#Directory for all deploys (this is where the repos get pulled to before deploying)
DEPLOYS="$ROOT"/deploys
#Directory for all logs
LOGS="$ROOT"/logs
#Directy for public/private keypairs
KEYS="$ROOT"/keys
#LOCATION OF THIS SCRIPT
SCRIPTDIR=$(dirname $0)
source "$SCRIPTDIR"/functions.sh
#parse_yaml "$SCRIPTDIR"/test.yml
#check if install was passed and folder doesn't exist. Do Installation if both are true
if [ ! -d "$ROOT" -a $1 = "install" ]
then
	/bin/bash "$SCRIPTDIR"/_hinstall.sh $ROOT $DEPLOYS $LOGS $KEYS
	if [ "$?" = 150 ]
	then
		usage
	fi
	exit
fi
#Generate a keypair 
if [ "$1" = "keypair" ]
then
	genkey $KEYS $2
	exit;
fi
echo "$-"
#Check if --config flas was passed
if [[ $* == *--config* ]]
then
	#Load existing config file if it exists
	echo "config file was passed"
fi
#shorthand options
optsetshort=a:r:b:sS:t:hu:g:
#longhad options
optsetlong=account:,repo:,branch:,ssh,src:,target:,help,report,user:,group:,auto,save,bitbucket,service:,afterinstall:,beforeinstall:,config
if ! options=$(getopt -o $optsetshort -l $optsetlong -- "$@")
then 
	exit 1
fi
eval set -- $options
while [ $# -gt 0 ]
do
	case $1 in
	-h|--help) cat "$SCRIPTDIR"/hermes.man ; exit;;
	-a|--account) ACCOUNT="$2" ; shift;;
	-r|--repo) REPO=$2 ; shift;;
	-b|--branch) BRANCH=$2 ; shift;;
	-s|--ssh) TYPE=ssh;;
	-S|--src) SOURCE=$2 ; shift;;
	-t|--target) TARGET=$2 ; shift;;
	-u|--user) HERMESUSER=$2 ; shift;;
	-g|--group) GROUP=$2 ; shift;;
	--service) SERVICE=$2 ; shift;;
	--bitbucket) SERVICE="BIT";;
	--auto) AUTO=1; SAVE=1;;
	--save) SAVE=1;;
	--report) REPORT="$2" ; shift;;
	--afterinstall) AFTERINSTALL=$2 ; shift;;
	--beforeinstall) BEFOREINSTALL=$2 ;shift;;
	--config) CONFIG=1;;
	esac
	shift
done
#Check if the required parameters are set.
if [ "$ACCOUNT" != "" ] && [ "$REPO" != "" ] && [ "$TARGET" != "" ]
then
	#The below is purly for debugging right now
	echo "Current Configuration"
	echo "Account: $ACCOUNT"
	echo "Repo: $REPO"
	echo "Branch: $BRANCH"
	echo "Type: $TYPE"
	echo "Source: $SOURCE"
	echo "Target: $TARGET"
	echo "User: $HERMESUSER"
	echo "Group: $GROUP"
	echo "Service: $SERVICE"
	echo "BeforeInstall: $BEFOREINSTALL"
	echo "AfterInstall: $AFTERINSTALL"
	#run a deployment
	source "$SCRIPTDIR"/deployment.sh
	#If we are either just saving or automating the configuration
	if [ "$SAVE" = 1 ]
	then
		source "$SCRIPTDIR"/setup.sh
	fi
else
	usage
	if [ "$ACCOUNT" = "" ]
	then
		echo "Error:	-a|--account is required"
	fi
	if [ "$REPO" = "" ]
	then
		echo "Error:	-r|--repo is required"
	fi
	if [ "$TARGET" = "" ]
	then
		echo "Error:	-t|--target is required"
	fi
fi