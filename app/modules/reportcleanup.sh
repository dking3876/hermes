#!/usr/bin/env bash
REPORT="$LOGS/$ACCOUNT"_"$REPO" 
REPORTSIZE=$(stat -c%s "$REPORT")
if [ $REPORTSIZE -gt 2500000 ]
then
	mv "$REPORT" "$REPORT-$(date +"%Y%m%d")"
fi