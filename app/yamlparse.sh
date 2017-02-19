#!/usr/bin/env bash
SCRIPTDIR=$(dirname $0)
source "$SCRIPTDIR"/functions.sh
testing=$(parse_yaml2 "$SCRIPTDIR"/test.yml)
eval $(parse_yaml2 "$SCRIPTDIR"/test.yml)
echo "$testing"
#echo "$testing" | while read a;
#	do
		#Breaks out each individual Variable
		 #echo "$a";
         #check if variable is deploy__{int}
         #if it is start new string
         #once variable is deploy__{int} again
         #push string into array+=(string)
         #each item in array now has complete deployment instructions
         #loop through array and do eval $(array[i]) to build vars for us in deployment
#	done
echo "$global__deployment__test"
exit;

array=()
