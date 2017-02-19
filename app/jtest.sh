#!/usr/bin/env bash
deploys=$(cat hermes.exp.json | jq '.deploy')
count=$(cat hermes.exp.json | jq '.deploy | length')
for ((i=0; i<$count; i++));
do
    echo "$i"
    parm="name"
    name=$(cat hermes.exp.json | jq '.deploy['$i'].'$parm)
    echo "$name"
done