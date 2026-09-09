#!/bin/bash
DATA_CORTE=$(date -d "7 days ago" +%Y-%m-%d)
awk -v data="$DATA_CORTE" '$1 >= data && $3 == "install" {print $1, $2, $4}' /var/log/dpkg.log*
