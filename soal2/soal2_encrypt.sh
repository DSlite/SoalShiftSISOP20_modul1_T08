#!/bin/bash
PWD=`pwd`
inode=$(ls -di $PWD/"${1}" | cut -d ' ' -f 1)
fs=$(df $PWD/"${1}" | tail -1 | awk '{print $1}')
crtime=$(sudo debugfs -R 'stat <'"${inode}"'>' "${fs}" 2>/dev/null | grep -oP 'crtime.*--\s*\K.*' | cut -d ' ' -f 4 | cut -d ':' -f 1)

filename="`echo $1 | cut -d "." -f 1`"

encrypt=`echo $filename | tr 'a-z' $(echo {a..z} | sed -r 's/ //g' | sed -r 's/(.{'$crtime'})(.*)/\2\1/') | tr 'A-Z' $(echo {A..Z} | sed -r 's/ //g' | sed -r 's/(.{'$crtime'})(.*)/\2\1/')`

mv $PWD/$filename.txt $PWD/$encrypt.txt
