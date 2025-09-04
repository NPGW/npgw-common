#!/bin/bash

echo "Creating {npgw.acquirer} table..."
awslocal dynamodb create-table \
  --table-name npgw.acquirer \
  --attribute-definitions AttributeName=acquirerName,AttributeType=S \
  --key-schema AttributeName=acquirerName,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region "${AWS_REGION}"
