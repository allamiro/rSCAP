#!/bin/bash

log "Generating compliance report..."
cat "$LOG_DIR/scan_log_$(date +%F).log" > "$LOG_DIR/compliance_report_$(date +%F).txt"
