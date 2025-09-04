#!/bin/bash

QUEUE_NAME=notification.fifo

echo "Create notification queue..."
awslocal sqs create-queue \
  --queue-name "${QUEUE_NAME}" \
  --region "${AWS_REGION}" \
  --attributes '{
    "FifoQueue": "true",
    "ContentBasedDeduplication": "false",
    "DeduplicationScope": "messageGroup",
    "DelaySeconds": "0",
    "FifoThroughputLimit": "perMessageGroupId",
    "KmsDataKeyReusePeriodSeconds": "300",
    "MaximumMessageSize": "262144",
    "MessageRetentionPeriod": "259200",
    "ReceiveMessageWaitTimeSeconds": "0",
    "VisibilityTimeout": "180",
    "SqsManagedSseEnabled": "false"
  }'

echo "Create parameter /merchant/queue/default-notification-name"
awslocal ssm put-parameter \
  --name "/merchant/queue/default-notification-name" \
  --value "${QUEUE_NAME}" \
  --type "String" \
  --region "${AWS_REGION}" \
  --overwrite
