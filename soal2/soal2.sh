#!/bin/bash
PWD=`pwd`

read -r pass <<< "`cat /dev/urandom | tr -cd 'a-zA-Z0-9' | fold -w 28 | head -n 1`"
read -r name <<< "`echo $1 | tr -cd 'a-zA-Z'`"

echo $pass > $PWD/$name.txt
