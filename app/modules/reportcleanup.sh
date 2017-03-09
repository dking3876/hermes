#!/usr/bin/env bash
REPORT="$LOGS/$ACCOUNT"_"$REPO"
REPORTSIZE=$(stat -c%s "$REPORT")
if [[ $REPORTSIZE -gt 2500000 ]] || [[ $(date +%u) -eq 7 ]]
then
	mv "$REPORT" "$REPORT-$(date +"%Y%m%d")"
fi