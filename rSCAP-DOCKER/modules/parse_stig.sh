#!/bin/bash

STIG_FILE="$1"

log "Parsing STIG: $STIG_FILE"
xmlstarlet sel -t -m "//Vulnerability" \
  -v "Vuln-ID" -o ": " \
  -v "Rule/Title" -o " (" -v "Severity" -o ")" -n "$STIG_FILE" \
  >> "$LOG_DIR/scan_log_$(date +%F).log"
