#!/bin/bash

read -r region regionprofit <<< `awk -F, 'NR > 1 {seen[$13]+=$NF} END {for (i in seen) printf "%s,%f\n", i, seen[i]}' Sample-Superstore.csv | sort -g -t, -k2 | awk -F, 'NR < 2 {printf "%s %f ", $1, $2}'`
printf "Region dengan profit paling sedikit:\n$region($regionprofit)\n\n"

read -r state1 state1profit state2 state2profit <<< `awk -F, -v region=$region '{if (match($13, region)) seen[$11]+=$NF} END {for (i in seen) printf "%s,%f\n", i, seen[i]}' Sample-Superstore.csv | sort -g -t, -k2 | awk -F, 'NR < 3 {printf "%s %f ", $1, $2}'`
printf "2 State dengan profit paling sedikit dari region $region:\n$state1($state1profit)\n$state2($state2profit)\n\n"

list=`awk -F, -v state1=$state1 -v state2=$state2 '{if (match ($11, state1)||match ($11, state2)) seen[$17]+=$NF} END {for (i in seen) printf "%s,%f\n", i, seen[i]}' Sample-Superstore.csv | sort -g -t, -k2 | awk -F, 'NR < 11 {printf "%s(%f)\n", $1, $2}'`
printf "List barang dengan profit paling sedikit antara state $state1 dan $state2:\n$list\n\n"
