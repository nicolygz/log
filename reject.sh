#!/bin/bash

LOG=/var/log/auth.log
[ -f "$LOG" ] || LOG=./auth.log.sample

echo "log: $LOG"
echo "data/hora            usuario         motivo"
echo "-------------------------------------------------"

grep "Invalid user" "$LOG" | while read -r linha; do
  data=$(echo "$linha" | awk '{print $1,$2,$3}')
  usuario=$(echo "$linha" | grep -oE "user [a-zA-Z0-9_]+" | awk '{print $2}')
  printf "%-20s %-15s %s\n" "$data" "$usuario" "usuario nao existe"
done

grep "NOT in sudoers" "$LOG" | while read -r linha; do
  data=$(echo "$linha" | awk '{print $1,$2,$3}')
  usuario=$(echo "$linha" | sed -E 's/.*sudo:\s+([a-zA-Z0-9_]+)\s*:.*/\1/')
  printf "%-20s %-15s %s\n" "$data" "$usuario" "sem permissao (nao esta no sudoers)"
done