#!/bin/bash
##
##  usage: get_rest_api_url.sh api_name stage_name
##
JQ=${JQ:-jq}
AWSCLI=${AWSCLI:-awslocal}
AWS_REGION=${AWS_REGION:-ap-northeast-1}
AWS_ENDPOINT=${AWS_ENDPOINT:localstack.localhost:4566}

[ $# -lt 2 ] && echo "usage: $0 api_name stage_name [endpoint_path]" && exit 1

api_name=$1; shift
stage_name=$1; shift
endpoint_path=$1; shift

api_id=$(
  ${AWSCLI} apigateway get-rest-apis --region="$AWS_REGION" --query="items[?name=='$api_name']" |
  ${JQ} -r '.[0].id'
)

echo "http://${api_id}.execute-api.${AWS_REGION}.${AWS_ENDPOINT}/${stage_name}${endpoint_path}"
