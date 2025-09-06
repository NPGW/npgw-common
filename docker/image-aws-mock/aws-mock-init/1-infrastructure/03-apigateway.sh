#!/bin/bash

echo "Creating api gateway..."

# an entry point for all http requests from the clients, and redirect ot different aws services
# this id will be used for adding new endpoints, request methods, integration with other services
API_ID=$(
  awslocal apigateway create-rest-api \
    --name "NpgwApi"\
    --region "${AWS_REGION}" \
    --output text \
    --query 'id'
)
echo "API ID CREATED $API_ID"

# root resource is a root of API gateway, "/" from where we build other api routes
# root is created with apigateway create-rest-api, here we just getting it's id to use later
ROOT_RESOURCE_ID=$(
  awslocal apigateway get-resources \
    --rest-api-id "${API_ID}" \
    --region "${AWS_REGION}" \
    --output text \
    --query 'items[0].id'
)
echo "ROOT RESOURCE ID CREATED $ROOT_RESOURCE_ID"
