#!/bin/bash
zgrep -E " (remove|purge) " /var/log/dpkg.log* | awk '{print $1, $2, $3, $4}' | sort