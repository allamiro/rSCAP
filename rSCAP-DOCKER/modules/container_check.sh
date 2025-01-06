#!/bin/bash

source utils/helpers.sh

log "Checking Docker containers for compliance..."
docker ps -q | while read -r container_id; do
    log "Inspecting container: $container_id"
    # Add compliance checks here
done
