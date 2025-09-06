#!/bin/bash

echo "Create dynamodb-events topic..."
DYNAMODB_SNS_TOPIC_ARN=$(
  awslocal sns create-topic \
    --name "dynamodb-events" \
    --region "${AWS_REGION}" \
    --query 'TopicArn' \
    --output text
)
echo "Dynamodb Events TopicArn: $DYNAMODB_SNS_TOPIC_ARN"

echo "Create parameter /common/transaction/dynamodb-sns-topic-arn"
awslocal ssm put-parameter \
  --name "/common/transaction/dynamodb-sns-topic-arn" \
  --value "${DYNAMODB_SNS_TOPIC_ARN}" \
  --type "String" \
  --region "${AWS_REGION}" \
  --overwrite
