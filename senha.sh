#!/bin/bash

LOG=/var/log/auth.log

[ -f "$LOG" ] || LOG=./auth.log.sample

echo "log: $LOG"
echo "----------------------------------------"

grep "Failed password" "$LOG" | grep -v "invalid user" > /tmp/falhas.tmp

awk '{
  for(i=1;i<=NF;i++){
    if($i=="for"){ print $(i+1); break }
  }
}' /tmp/falhas.tmp > /tmp/usuarios.tmp

sort /tmp/usuarios.tmp | uniq -c | sort -rn | awk '{print $2" -> "$1" tentativa(s)"}'

rm -f /tmp/falhas.tmp /tmp/usuarios.tmp