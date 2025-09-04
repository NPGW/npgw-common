#!/bin/bash

echo "Creating {npgw.merchant-control} table..."
awslocal dynamodb create-table \
  --table-name npgw.merchant-control \
  --attribute-definitions AttributeName=merchantId,AttributeType=S \
  --key-schema AttributeName=merchantId,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region "${AWS_REGION}"
