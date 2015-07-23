#!/bin/sh

function usage ()
{
	echo "Usage: $0 RIGHTSCALE_ACCOUNT_NUM RIGHTSCALE_HOST REFRESH_TOKEN" 
}

if [ $# -ne 3 ]
then
	usage
	exit 1
fi
 
RSC_TOOL="rsc"
ACCOUNT_NUM="${1}"
RIGHTSCALE_HOST="${2}"
REFRESH_TOKEN="${3}"

echo "**** WARNING WARNING WARNING ****"
echo "YOU WILL TERMINATE ALL LAUNCHING CLOUD APPLICATIONS IN ACCOUNT ID: ${ACCOUNT_NUM}"
echo ""
echo "Currently the LAUNCHING cloud apps in this account are:"
${RSC_TOOL} --pp  --xm ":has(.status:val(\"launching\")) > .name" -a ${ACCOUNT_NUM} -h ${RIGHTSCALE_HOST} -r ${REFRESH_TOKEN} ss index manager/projects/${ACCOUNT_NUM}/executions  | sort

echo ""
echo "****************"
echo "Enter Control-C WITHIN 10 seconds to EXIT" 
sleep 10

echo ""
launching_app_ids=`${RSC_TOOL} --pp  --xm ":has(.status:val(\"launching\")) > .id" -a ${ACCOUNT_NUM} -h ${RIGHTSCALE_HOST} -r ${REFRESH_TOKEN} ss index manager/projects/${ACCOUNT_NUM}/executions | sed 's/"//g' | sort | tr '\n' ' '`

echo "Launching App IDs to be terminated: ${launching_app_ids}"
for app_id in ${launching_app_ids}
do
	echo "	Terminating app ID ${app_id}"
	${RSC_TOOL} -a ${ACCOUNT_NUM} -h ${RIGHTSCALE_HOST} -r ${REFRESH_TOKEN} ss terminate manager/projects/${ACCOUNT_NUM}/executions/${app_id}
	echo ""
done
echo ""