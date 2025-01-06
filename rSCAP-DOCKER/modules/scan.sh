#!/bin/bash

source utils/helpers.sh
source config/rscap-config.cfg

log "Starting rSCAP-Docker scan..."

for type_dir in "$STIG_DIR"/*; do
    for version_dir in "$type_dir"/*; do
        for stig_file in "$version_dir"/*.xml; do
            log "Processing STIG: $stig_file"
            modules/parse_stig.sh "$stig_file"
        done
    done
done

log "Scan completed."
