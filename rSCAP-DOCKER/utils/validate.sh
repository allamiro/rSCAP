#!/bin/bash

STIG_FILE="$1"

log "Validating XML: $STIG_FILE"
xmlstarlet val "$STIG_FILE"
