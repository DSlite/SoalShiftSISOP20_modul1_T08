#!/bin/bash

c=`ls | grep "pdkt_kusuma" | cut -d "_" -f 3 | sort -n | tail -1`

if [[ $c =~ [^0-9] ]]
then
  c=0
fi

a=`expr $c + 1`
b=`expr $c + 28`

for ((i=a;i<=b;i++))
do
  wget -a wget.log -O "pdkt_kusuma_$i" https://loremflickr.com/320/240/cat
done
