#!/bin/bash

echo "Creating {npgw.company} table..."
awslocal dynamodb create-table \
  --table-name npgw.company \
  --attribute-definitions AttributeName=companyName,AttributeType=S \
  --key-schema AttributeName=companyName,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region "${AWS_REGION}"
