#!/bin/bash

cat wget.log | grep "Location" | awk '{printf "%d, %s\n", NR, $0}'
