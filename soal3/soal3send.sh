#!/bin/bash
PWD=`pwd`
end=`ls $PWD | grep "pdkt_kusuma" | cut -d "_" -f 3 | sort -n | tail -1`

if [[ `ls $PWD | grep "kenangan"` != "kenangan" ]]
then
  mkdir $PWD/kenangan
fi

if [[ `ls $PWD | grep "duplicate"` != "duplicate" ]]
then
  mkdir $PWD/duplicate
fi

arr=""
for ((i=1;i<=end;i++))
do
  loc="`cat $PWD/wget.log | grep "Location:" | head -$i | tail -1 | cut -d " " -f 2`"
  isDuplicate=`echo -e $arr | awk -v loc=$loc 'BEGIN {isDuplicate=0} {if (loc==$0) isDuplicate=1} END {printf "%d", isDuplicate}'`
  if [[ $isDuplicate == 1 ]]
  then
    mv $PWD/pdkt_kusuma_$i $PWD/duplicate/duplicate_$i
  else
    arr="$arr$loc\n"
    mv $PWD/pdkt_kusuma_$i $PWD/kenangan/kenangan_$i
  fi
done

cat $PWD/wget.log >> $PWD/wget.log.bak
rm $PWD/wget.log
