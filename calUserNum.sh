#!/bin/bash
#osVersion=4.4.2 %6F%73%56%65%72%73%69%6F%6E=%34%2E%34%2E%32
#deviceId=865473026617087 %64%65%76%69%63%65%49%64=%38%36%35%34%37%33%30%32%36%36%31%37%30%38%37
#os=android %6F%73=%61%6E%64%72%6F%69%64
#appId=10017 %61%70%70%49%64=%31%30%30%31%37
#appVersion=1.5.0 %61%70%70%56%65%72%73%69%6F%6E=%31%2E%35%2E%30
#sign=c046a4b93346f39fe0ee459b041c661b %73%69%67%6E=%63%30%34%36%61%34%62%39%33%33%34%36%66%33%39%66%65%30%65%65%34%35%39%62%30%34%31%63%36%36%31%62
#appLog跨越时间：0928 06:00~0929 14:00

fileList=`ls nginxLog`
banks=(上海银行-IOS  上海银行-Android   金谷银行-IOS   威海银行-IOS   威海银行-Android   紫金银行-IOS  紫金银行-Android)
patchNames=(4a6f15118b500ff8eae3a2decf9fddc6.zip 9fb2292a9d284b8b17a1be376b58b100.jar 4308cd33d8af9e0e1dd62532876d19f4.zip 32975384dee9f81450bb7c6a4dde3bdd.zip ea5f3173824bc5930b89f998e5dac651.jar e7ee92a3515204b406700629dd4d67b0.zip dfeb154819677f62cfe7e3669738e7ba.jar)

curPath=`pwd`
totalPatchNum=0
totalUserNum=0

#echo "获取总用户数"
mkdir -p userNum
rm userNum/*
curl http://ff-app-sg.paic.com.cn/webii/fsg/uv/getStatisticsInfoList?os=0 > IOSUserNum
curl http://ff-app-sg.paic.com.cn/webii/fsg/uv/getStatisticsInfoList?os=1 > AndroidUserNum
javac -classpath fastjson-1.1.26-1.1.26.jar parseJson.java
java -classpath fastjson-1.1.26-1.1.26.jar:$curPath parseJson IOSUserNum IOS
java -classpath fastjson-1.1.26-1.1.26.jar:$curPath parseJson AndroidUserNum Android

echo "计算银行更新情况"
for i in "${!banks[@]}";
do
    bankName=${banks[i]}
    patchNameList=${patchNames[i]}
    arrPatchName=(${patchNameList//-/ })
    bankTotalPatchNum=0
    for file in $fileList
    do
        for patchName in ${arrPatchName[@]}
        do
            bankPatchNum=`grep $patchName nginxLog/$file|wc -l`
            bankTotalPatchNum=$((bankTotalPatchNum+bankPatchNum))
        done
    done
    bankTotalUserNum=`cat userNum/$bankName`
    totalPatchNum=$((totalPatchNum+bankTotalPatchNum))
    totalUserNum=$((totalUserNum+bankTotalUserNum))
    bankRatio=`awk 'BEGIN{printf "%.3f\n",('$bankTotalPatchNum' * 100 /'$bankTotalUserNum')}'`
    echo $bankName":\t更新数="$bankTotalPatchNum"，用户数="$bankTotalUserNum"，更新率="$bankRatio"%"
done
ratio=`awk 'BEGIN{printf "%.3f\n",('$totalPatchNum' * 100 /'$totalUserNum')}'`
#ratio=`expr $totalPatchNum \* 100 \/ $totalUserNum`
echo "total:\t更新数="$totalPatchNum"，用户数="$totalUserNum"，更新率="$ratio"%"
echo "finish!"
