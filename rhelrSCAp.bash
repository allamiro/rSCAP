#!/bin/bash






# Results Variables

export TYPE=`echo $1 | grep "-"|cut -d"-" -f1`
export STG_VERSION=`echo $1 |grep V | cut -d "_" -f2`
export TODAY_DT=`date +%Y-%m-%d`
export func_scripts="functions/"
export N_CHECKS="stig_checks/$TYPE/$STG_VERSION/$TYPE_$TODAY_DT"
export N_RESULTS="results/$TYPE/$STG_VERSION/$TYPE_$TODAY_DT/" && mkdir -p $N_RESULTS




