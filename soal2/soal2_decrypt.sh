#!/bin/bash

inode=$(ls -di "${1}" | cut -d ' ' -f 1)
fs=$(df "${1}" | tail -1 | awk '{print $1}')
crtime=$(sudo debugfs -R 'stat <'"${inode}"'>' "${fs}" 2>/dev/null | grep -oP 'crtime.*--\s*\K.*' | cut -d ' ' -f 4 | cut -d ':' -f 1)

filename="`echo $1 | cut -d "." -f 1`"

decrypt=`echo $filename | tr $( echo {a..z} | sed -r 's/ //g' | sed -r 's/(.{'$crtime'})(.*)/\2\1/') 'a-z' | tr $(echo {A..Z} | sed -r 's/ //g' | sed -r 's/(.{'$crtime'})(.*)/\2\1/') 'A-Z'`

mv $filename.txt $decrypt.txt
