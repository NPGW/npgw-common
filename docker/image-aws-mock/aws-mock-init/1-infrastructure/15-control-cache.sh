#!/bin/bash

echo "Creating {npgw.control-cache} table..."
awslocal dynamodb create-table \
  --table-name npgw.control-cache \
  --attribute-definitions AttributeName=cacheId,AttributeType=S \
  --key-schema AttributeName=cacheId,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region "${AWS_REGION}"
