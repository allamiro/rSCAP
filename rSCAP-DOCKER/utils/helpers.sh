#!/bin/bash

log() {
    echo "$(date +%F_%T) [INFO] $1" | tee -a "$LOG_DIR/scan_log_$(date +%F).log"
}
