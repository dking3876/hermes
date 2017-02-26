#!/usr/bin/env bash
REPORT="$REPORT"_"$REPO"
echo "data" >> $REPORT
REPORTSIZE=$(stat -c%s "$REPORT")
if [ $REPORTSIZE -gt 150000 ]
then
	mv "$REPORT" "$REPORT-$(date +"%Y%m%d")"
fi