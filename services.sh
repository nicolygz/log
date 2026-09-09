#!/bin/bash
journalctl -u "*.service" --since "24 hours ago" | grep -E "(Started|Stopped)" | awk '{print $1, $2, $3, $5, $6, $7, $8}'
