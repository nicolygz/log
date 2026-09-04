#!/bin/bash

log=/var/log/syslog
[ -f "$log" ] || log=./syslog.sample

grep "Linux version" "$log" | tail -1 | awk '{print $1, $2, $3}'