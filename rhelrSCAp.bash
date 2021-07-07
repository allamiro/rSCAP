#!/bin/bash




# set the text colors variables
export GREEN='\033[0;32m'
export G='\033[0;32m'
export NC='\033[0m'
# some date Variables
export today=$(date +%h-%d)
export todayAll=$(date +%Y-%m-%d)
export logFile='logs/RHEL-rSCAP-$todayAll.log'
export logTime=`date "+%Y-%m-%d %H:%M:%S"`



# Results Variables

export TYPE=`echo $1 | grep "-"|cut -d"-" -f1`
export STG_VERSION=`echo $1 |grep V | cut -d "_" -f2`
export TODAY_DT=`date +%Y-%m-%d`
export func_scripts="functions/"
export N_CHECKS="stig_checks/$TYPE/$STG_VERSION/$TYPE_$TODAY_DT"
export N_RESULTS="results/$TYPE/$STG_VERSION/$TYPE_$TODAY_DT/" && mkdir -p $N_RESULTS




