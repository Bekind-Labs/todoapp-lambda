#!/bin/bash
##
##  usage: get_function_url.sh function_name
##
JQ=${JQ:-jq}
AWSCLI=${AWSCLI:-awslocal}
AWS_REGION=${AWS_REGION:-ap-northeast-1}

nargs=$#
[ $nargs -lt 1 ] && echo "usage: $0 function_name [endpoint_path]" && exit 1

function_name=$1; shift
endpoint_path=$1; shift

function_url=$(
  ${AWSCLI} lambda get-function-url-config --region="$AWS_REGION" --function-name="$function_name" |
  ${JQ} -r '.FunctionUrl'
)

echo "${function_url}${endpoint_path}"
