#!/bin/sh

# Provides a listing of CloudApps from the given account.

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

echo "Here is a list of all CloudApps in account ${ACCOUNT_NUM}:"
${RSC_TOOL} --xm ".status ~ .name" -a ${ACCOUNT_NUM} -h ${RIGHTSCALE_HOST} -r ${REFRESH_TOKEN} ss index manager/projects/${ACCOUNT_NUM}/executions

echo "Currently the running cloud apps in this account are:"
${RSC_TOOL} --pp  --xm ":has(.status:val(\"running\")) > .name" -a ${ACCOUNT_NUM} -h ${RIGHTSCALE_HOST} -r ${REFRESH_TOKEN} ss index manager/projects/${ACCOUNT_NUM}/executions  | sort
echo ""
echo "Currently the failed cloud apps in this account are:"
${RSC_TOOL} --pp  --xm ":has(.status:val(\"failed\")) > .name" -a ${ACCOUNT_NUM} -h ${RIGHTSCALE_HOST} -r ${REFRESH_TOKEN} ss index manager/projects/${ACCOUNT_NUM}/executions  | sort
