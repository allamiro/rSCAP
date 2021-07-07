#!/bin/bash


set -e

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


if [ -z $1 ]
then
echo ""
printf '%s\n'
echo -e "..........................................|> ${GREEN}No STIG CKL file found please try again${NC}"
printf '%s\n'
exit 0
else
cat $1 > `hostname -f`.xml
echo -e "..........................................|> ${GREEN}STIG CKL XML File created${NC}"

fi


# XML FILE DATA VARIABLES - TARGET DATA INFO
HOSTNAME=$(hostname)
HOSTFQDN=$(hostname -f)
HOST_IP=$(hostname -i|cut -f2 -d ' ')
HOST_MAC=$(ip addr | grep link/ether | awk '{print $2}')

# Updating STIG File  Target Data Info.
xmlTargetFileName=`hostname -f`.xml
export xmlTargetFileName

echo " "
echo "..........................................|> Editing Target Data Section"
xmlstarlet edit --inplace --update "//CHECKLIST/ASSET/HOST_NAME" --value "$HOSTNAME" $xmlTargetFileName
xmlstarlet edit --inplace --update "//CHECKLIST/ASSET/HOST_FQDN" --value "$HOSTFQDN" $xmlTargetFileName
xmlstarlet edit --inplace --update "//CHECKLIST/ASSET/HOST_IP" --value "$HOST_IP" $xmlTargetFileName
xmlstarlet edit --inplace --update "//CHECKLIST/ASSET/HOST_MAC" --value "$HOST_MAC" $xmlTargetFileName
echo -e "..........................................|> ${GREEN}Editing Target Data Section completed!${NC}"
echo -e "${GREEN}...................................................................................${NC}"

VULN_TOTAL=`xmlstarlet sel -t -c "count(//VULN)" $xmlTargetFileName`
echo -e  "Total Number of Vulnerability checks......|> ${GREEN}$(( $VULN_TOTAL + 1 ))${NC}"

VULN_COUNT=0

# ITERATION THROUGH VULN-ID

while [ $VULN_COUNT -lt $VULN_TOTAL ]
do

        VULN_COUNT=$(( $VULN_COUNT + 1 ))
        VulnId=$(xmlstarlet sel  -T -t -v  "//VULN[$VULN_COUNT]/STIG_DATA[1]/ATTRIBUTE_DATA[1]" $xmlTargetFileName)
        #;printf '%s\n' "$VulnId"



echo ""
printf '%s\n'
echo -e "..........................................|> ${GREEN}STIG CKL XML File Found${NC}"





