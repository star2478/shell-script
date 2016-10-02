#!/bin/bash
#osVersion=4.4.2 %6F%73%56%65%72%73%69%6F%6E=%34%2E%34%2E%32
#deviceId=865473026617087 %64%65%76%69%63%65%49%64=%38%36%35%34%37%33%30%32%36%36%31%37%30%38%37
#os=android %6F%73=%61%6E%64%72%6F%69%64
#appId=10017 %61%70%70%49%64=%31%30%30%31%37
#appVersion=1.5.0 %61%70%70%56%65%72%73%69%6F%6E=%31%2E%35%2E%30
#sign=c046a4b93346f39fe0ee459b041c661b %73%69%67%6E=%63%30%34%36%61%34%62%39%33%33%34%36%66%33%39%66%65%30%65%65%34%35%39%62%30%34%31%63%36%36%31%62
#appLog跨越时间：0928 06:00~0929 14:00
#split -10000 -a 4 log.out

srcFile=appLog/logId
i=0
updatePatchCount=0

while read line
do
    ((i++))
    line=${line//\[/\\\[}
    line=${line//\]/\\\]}

    arr=(${line//,/ })
    file=${arr[0]}
    time=${arr[1]}
    logId=${arr[2]}
    patchId=${arr[3]}
#    cmd1="grep '$logId' $file | grep \"PatchController:  patchId\""
#    cmd="grep \"Restful Response\" $file | grep \"patchId\""
#    echo $cmd1" "$cmd2
#    patchIdString=`grep '$logId' $file | grep "PatchController:  patchId:"`
#    cmd="grep \"$logId\" $file |grep \"$time\"| grep \"Restful Response\"| awk -F \"patchId\\\":\" '{print $2}'|awk -F \",\" '{print \$1}'"
#    echo $cmd
#    resultPatchId=`grep $logId $file |grep $time| grep "Restful Response"| awk -F "patchId\":" '{print $2}'|awk -F "," '{print $1}'`
#    echo "===="
#    echo $file
#    echo $logId
#    echo $time
    resultPatchId=`grep $logId $file | grep "Restful Response"| awk -F "patchId\":" '{print $2}'|awk -F "," '{print $1}'`
#    echo $patchId","$resultPatchId","$line
    # 意味着有更新
    if [ $resultPatchId -gt $patchId ]; then
        ((updatePatchCount++))
    fi
    j=`expr $i % 500`
    if [ $j -eq 0 ]; then
        echo $i": "$updatePatchCount
    fi
done < $srcFile
echo "count="$updatePatchCount
echo "finish!"
