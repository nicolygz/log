#!/bin/bash

LOG=/var/log/auth.log
[ -f "$LOG" ] || LOG=./auth.log.sample

echo "log: $LOG"
echo "data/hora            usuario         comando"
echo "-------------------------------------------------"

grep "sudo:" "$LOG" | grep -v "NOT in sudoers" | while read -r linha; do
  data=$(echo "$linha" | awk '{print $1,$2,$3}')

  usuario=$(echo "$linha" | sed -E 's/.*sudo:\s+([a-zA-Z0-9_]+)\s*:.*/\1/')

  comando=$(echo "$linha" | sed -n 's/.*COMMAND=//p')

  printf "%-20s %-15s %s\n" "$data" "$usuario" "$comando"
done