#!/bin/bash

LOG=/var/log/auth.log
[ -f "$LOG" ] || LOG=./auth.log.sample

echo "log: $LOG"
echo "data/hora            usuario         ip origem"
echo "-------------------------------------------------"

grep "Accepted" "$LOG" | while read -r linha; do
  data=$(echo "$linha" | awk '{print $1,$2,$3}')

  usuario=$(echo "$linha" | grep -oE "for [a-zA-Z0-9_]+" | awk '{print $2}')
  ip=$(echo "$linha" | grep -oE "from [0-9.]+" | awk '{print $2}')

  printf "%-20s %-15s %s\n" "$data" "$usuario" "$ip"
done