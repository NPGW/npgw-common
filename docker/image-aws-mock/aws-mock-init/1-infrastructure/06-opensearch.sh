#!/bin/bash

echo "Create parameter /portal/opensearch/host"
awslocal configure set cli_follow_urlparam false
awslocal ssm put-parameter \
  --name "/portal/opensearch/host" \
  --value "${OPENSEARCH_HOST}" \
  --type "String" \
  --region "${AWS_REGION}" \
  --overwrite

echo "Create parameter /portal/opensearch/user-name"
awslocal ssm put-parameter \
  --name "/portal/opensearch/user-name" \
  --value "${OPENSEARCH_USER}" \
  --type "String" \
  --region "${AWS_REGION}" \
  --overwrite

echo "Create parameter /portal/opensearch/user-password"
awslocal ssm put-parameter \
  --name "/portal/opensearch/user-password" \
  --value "${OPENSEARCH_PASSWORD}" \
  --type "String" \
  --region "${AWS_REGION}" \
  --overwrite

