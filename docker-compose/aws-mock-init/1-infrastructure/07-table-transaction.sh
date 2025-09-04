#!/bin/bash

echo "Creating {npgw.transaction} table..."
awslocal dynamodb create-table \
  --table-name npgw.transaction \
  --attribute-definitions AttributeName=transactionId,AttributeType=S \
  --key-schema AttributeName=transactionId,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --stream-specification StreamEnabled=true,StreamViewType=NEW_AND_OLD_IMAGES \
  --region "${AWS_REGION}"
