#!/bin/bash
#osVersion=4.4.2 %6F%73%56%65%72%73%69%6F%6E=%34%2E%34%2E%32
#deviceId=865473026617087 %64%65%76%69%63%65%49%64=%38%36%35%34%37%33%30%32%36%36%31%37%30%38%37
#os=android %6F%73=%61%6E%64%72%6F%69%64
#appId=10017 %61%70%70%49%64=%31%30%30%31%37
#appVersion=1.5.0 %61%70%70%56%65%72%73%69%6F%6E=%31%2E%35%2E%30
#sign=c046a4b93346f39fe0ee459b041c661b %73%69%67%6E=%63%30%34%36%61%34%62%39%33%33%34%36%66%33%39%66%65%30%65%65%34%35%39%62%30%34%31%63%36%36%31%62
#patchId %70%61%74%63%68%49%64
#appLog跨越时间：0928 06:00~0929 14:00

dir="appLog/splitDir"

fileList=`ls $dir`
desFile=appLog/logId
desFileTmp=appLog/logIdTmp
rm $desFile
rm $desFileTmp
for file in $fileList
do
    srcFile=$dir/$file
    echo "scan "$srcFile
    grep '%61%70%70%49%64=%31%30%30%31%37' $srcFile |grep '%61%70%70%56%65%72%73%69%6F%6E=%31%2E%35%2E%30' |grep "Begin Request\[/dmz/fpatch/getPatch"|grep -v '%70%61%74%63%68%49%64' |awk '{print srcFile","$1","$3",0"}' srcFile="$srcFile" >> $desFileTmp
    grep '%61%70%70%49%64=%31%30%30%31%37' $srcFile |grep '%61%70%70%56%65%72%73%69%6F%6E=%31%2E%35%2E%30' |grep "Begin Request\[/dmz/fpatch/getPatch"|grep '%70%61%74%63%68%49%64' |awk '{print srcFile","$1","$3","$6}' srcFile="$srcFile" >> $desFileTmp
#grep 'dmz/fpatch/getPatch' $srcFile|grep -v '%70%61%74%63%68%49%64' |awk '{print srcFile","$3",0"}' srcFile="$srcFile" >> $desFileTmp
#grep 'dmz/fpatch/getPatch' $srcFile|grep '%70%61%74%63%68%49%64' |awk '{print srcFile","$3","$6}' srcFile="$srcFile" >> $desFileTmp
done
sed 's/\[/\\\[/g' $desFileTmp |sed 's/\]/\\\]/g' > $desFileTmp".tmp"
mv $desFileTmp".tmp" $desFileTmp
echo "start to cal patchId"
a="0"
while read line
do
    arr=(${line//,/ })
    file=${arr[0]}
    time=${arr[1]}
    logId=${arr[2]}
    patchId=${arr[3]}

    if [ "$patchId" -eq "$a" ]; then
        echo $line >> $desFile
    else
        ab=`echo $patchId | awk -F "%70%61%74%63%68%49%64=" '{print $2}'|awk -F "&" '{print $1}'`
        echo $file","$logId","$ab >> $desFile
    fi
done < $desFileTmp
echo "finish!"
