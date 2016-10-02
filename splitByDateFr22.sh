#!/bin/bash
file=totalLog
#DATES="22/Sep/2016  23/Sep/2016   24/Sep/2016   25/Sep/2016   26/Sep/2016"
DATES="27/Sep/2016"
date=27
mkdir -p log
for x in $DATES
do     
	grep $x $file |grep 'ff_app_cms_id592670_vol1001/fpatch' > log/"201609"$date".log"
	((date++))
	echo $x" done"
done 
echo "finish!"
