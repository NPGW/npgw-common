#!/bin/bash

echo "Creating {npgw.control} table..."
awslocal dynamodb create-table \
  --table-name npgw.control \
  --attribute-definitions AttributeName=controlName,AttributeType=S \
  --key-schema AttributeName=controlName,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region "${AWS_REGION}"
