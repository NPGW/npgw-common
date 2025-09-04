#!/bin/bash
set -euo pipefail

echo "Create topic..."
TOPIC_ARN=$(
  awslocal sns create-topic \
    --name "custom-alarm" \
    --region "${AWS_REGION}" \
    --query 'TopicArn' \
    --output text
)
echo "TopicArn: $TOPIC_ARN"

echo "Create parameter /common/alert/topic-arn"
awslocal ssm put-parameter \
  --name "/common/alert/topic-arn" \
  --value "${TOPIC_ARN}" \
  --type "String" \
  --region "${AWS_REGION}" \
  --overwrite
