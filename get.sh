#!/bin/bash
grep -E "COMMAND=.*(apt|apt-get|dpkg)" /var/log/auth.log* | awk '{
    user=$5; 
    sub(/\[.*\]:/, "", user); 
    for(i=1; i<=NF; i++) if($i ~ /COMMAND=/) {
        cmd=""; for(j=i; j<=NF; j++) cmd=cmd " " $j; 
        print $1, $2, $3, "| Usuário:", user, "|", cmd
    }
}'