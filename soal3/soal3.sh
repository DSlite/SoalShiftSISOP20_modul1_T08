#!/bin/bash
PWD=`pwd`
c=`ls $PWD | grep "pdkt_kusuma" | cut -d "_" -f 3 | sort -n | tail -1`

if [[ $c =~ [^0-9] ]]
then
  c=0
fi

a=`expr $c + 1`
b=`expr $c + 28`

for ((i=a;i<=b;i++))
do
  wget -a $PWD/wget.log -O $PWD/"pdkt_kusuma_$i" https://loremflickr.com/320/240/cat
done
