#!/usr/bin/env bash
usage() { echo "Usage: ci_git.sh {Account} {Repo} {Branch} {SrcFolder [optional]} {Destination [optional]}";}
ACCOUNT=""
REPO=""
BRANCH=""
while getopts 'a::r::b:sdp --long account::,repo::,branch:,src:,dest:' flag; do
	case "${flag}" in
	a|-account) echo "acount is set"
	ACCOUNT="${OPTARG}" ;;
	-s) echo "s is set" ;;
	--repo) echo 
	esac
done
echo "$ACCOUNT"
echo "$1"
exit
if [ "$1" = "man" ]
then
	cat <<EOF
Continuous Integration Script

	Account: <-a|--account>

	Repo: <-r|--repo>

	Branch: <-b|--branch>

	SrcFolder:<--src>

	Destination: <-d|--dest>

	Use SSH: <-s>
EOF
	exit
fi
if [ -z "$1" -o -z "$2" -o -z "$3" ]
then
	usage
	echo "ci_git.sh man for complete instructions"
	exit 1
fi
ACCOUNT=$1
REPO=$2
BRANCH=$3
SRC=$4
DESTINATION=$5
#source /home/ec2-user/ssh-agent.config
echo "starting run for $REPO at $(date)" >> /var/opt/deploy/report
if [ -d "/var/opt/deploy/$REPO-$BRANCH" ]
then
	echo "fetching branch $BRANCH from $REPO" >> /var/opt/deploy/report
        res=$( cd /var/opt/deploy/$REPO-$BRANCH && git pull )
else
	echo "cloning repo $REPO" >> /var/opt/deploy/report
        (git clone -b "$BRANCH" "https://github.com/$ACCOUNT/$REPO.git" "/var/opt/deploy/$REPO-$BRANCH") &>> /var/opt/deploy/report
fi
echo "response back is $res" &>> /var/opt/deploy/report
if [ "$res" = "Already up-to-date." ]
then
	echo "No recent changes to $SRC" &>> /var/opt/deploy/report
else
	echo "Changes to $REPO initiating copy" &>> /var/opt/deploy/report
	cp -R "/var/opt/deploy/$REPO-$BRANCH$SRC"/* "$DESTINATION" &>> /var/opt/deploy/cpreport
	chmod -R 664 "$DESTINATION"
	find "$DESTINATION" -type d -exec chmod 775 {} +
	chown -R apache:www "$DESTINATION"
fi
