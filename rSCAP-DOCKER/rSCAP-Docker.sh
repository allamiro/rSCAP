#!/bin/bash

source config/rscap-config.cfg
source utils/helpers.sh

log "Running rSCAP-Docker..."
modules/scan.sh
utils/report_generator.sh
log "Compliance scan complete. Report generated."
