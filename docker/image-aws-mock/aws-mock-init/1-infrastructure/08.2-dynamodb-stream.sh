#!/bin/bash

echo "Deploying Lambda functions..."

STREAM_ARN=$(
  awslocal dynamodb describe-table \
    --table-name npgw.transaction \
    --region "${AWS_REGION}" \
    --query "Table.LatestStreamArn" \
    --output text
)
echo "DynamoDB Stream ARN: $STREAM_ARN"

# Get the dynamodb topic ARN
DYNAMODB_SNS_TOPIC_ARN=$(
  awslocal ssm get-parameter \
    --name "/common/transaction/dynamodb-sns-topic-arn" \
    --region "${AWS_REGION}" \
    --query "Parameter.Value" \
    --output text
)
echo "DynamoDB Topic ARN: $DYNAMODB_SNS_TOPIC_ARN"


echo "Creating DynamoDB Stream to SNS Lambda..."
awslocal lambda create-function \
  --function-name DynamoDBStreamToSNS \
  --zip-file fileb:///lambda/dbstream/lambda_dynamo_sns.zip \
  --role arn:aws:iam::000000000000:role/lambda-role \
  --handler lambda_handler_dbstream_to_sns.lambda_handler_dbstream_to_sns \
  --timeout 50 \
  --runtime python3.9 \
  --environment Variables="{SNS_TOPIC_ARN=$DYNAMODB_SNS_TOPIC_ARN,AWS_ENDPOINT_URL=http://aws-mock:4566}"

awslocal lambda put-function-concurrency \
  --function-name DynamoDBStreamToSNS \
  --reserved-concurrent-executions 1

echo "Waiting for function DynamoDBStreamToSNS to be active..."
awslocal lambda wait function-active-v2 --function-name DynamoDBStreamToSNS

awslocal lambda create-event-source-mapping \
  --function-name DynamoDBStreamToSNS \
  --event-source "${STREAM_ARN}" \
  --batch-size 1 \
  --starting-position LATEST


echo "Creating History Lambda..."
awslocal lambda create-function \
  --function-name DynamoDBStreamHandlerLog \
  --zip-file fileb:///lambda/dbstream/lambda_dynamo_stream_handlerlog.zip \
  --handler lambda_handler_log.lambda_handler_log \
  --timeout 50 \
  --runtime python3.9 \
  --role arn:aws:iam::000000000000:role/lambda-role \
  --environment Variables="{OPENSEARCH_HOST=$OPENSEARCH_HOST,OPENSEARCH_USER=$OPENSEARCH_USER,OPENSEARCH_PASSWORD=$OPENSEARCH_PASSWORD}"

echo "Waiting for function DynamoDBStreamHandlerLog to be active..."
awslocal lambda wait function-active-v2 --function-name DynamoDBStreamHandlerLog

awslocal lambda create-event-source-mapping \
  --function-name DynamoDBStreamHandlerLog \
  --event-source "${STREAM_ARN}"  \
  --batch-size 5 \
  --starting-position LATEST

awslocal sns subscribe \
  --topic-arn "${DYNAMODB_SNS_TOPIC_ARN}" \
  --protocol lambda \
  --notification-endpoint arn:aws:lambda:${AWS_REGION}:000000000000:function:DynamoDBStreamHandlerLog

awslocal lambda add-permission \
  --function-name DynamoDBStreamHandlerLog \
  --statement-id AllowExecutionFromSNS \
  --action lambda:InvokeFunction \
  --principal sns.amazonaws.com \
  --source-arn "${DYNAMODB_SNS_TOPIC_ARN}"


echo "Creating Status Lambda..."
awslocal lambda create-function \
  --function-name DynamoDBStreamHandlerStatus \
  --zip-file fileb:///lambda/dbstream/lambda_dynamo_stream_handlerstatus.zip \
  --role arn:aws:iam::000000000000:role/lambda-role \
  --handler lambda_handler_status.lambda_handler_status \
  --timeout 50 \
  --runtime python3.9 \
  --environment Variables="{OPENSEARCH_HOST=$OPENSEARCH_HOST,OPENSEARCH_USER=$OPENSEARCH_USER,OPENSEARCH_PASSWORD=$OPENSEARCH_PASSWORD}"

echo "Waiting for function DynamoDBStreamHandlerStatus to be active..."
awslocal lambda wait function-active-v2 --function-name DynamoDBStreamHandlerStatus

awslocal lambda create-event-source-mapping \
  --function-name DynamoDBStreamHandlerStatus \
  --event-source "${STREAM_ARN}"  \
  --batch-size 5 \
  --starting-position LATEST

awslocal sns subscribe \
  --topic-arn "${DYNAMODB_SNS_TOPIC_ARN}" \
  --protocol lambda \
  --notification-endpoint arn:aws:lambda:${AWS_REGION}:000000000000:function:DynamoDBStreamHandlerStatus

awslocal lambda add-permission \
  --function-name DynamoDBStreamHandlerStatus \
  --statement-id AllowExecutionFromSNS \
  --action lambda:InvokeFunction \
  --principal sns.amazonaws.com \
  --source-arn "${DYNAMODB_SNS_TOPIC_ARN}"


echo "Creating Delta Lambda..."
awslocal lambda create-function \
  --function-name DynamoDBStreamHandlerDelta \
  --zip-file fileb:///lambda/dbstream/lambda_dynamo_stream_handlerdelta.zip \
  --role arn:aws:iam::000000000000:role/lambda-role \
  --handler lambda_handler_delta.lambda_handler_delta \
  --timeout 50 \
  --runtime python3.9 \
  --environment Variables="{OPENSEARCH_HOST=$OPENSEARCH_HOST,OPENSEARCH_USER=$OPENSEARCH_USER,OPENSEARCH_PASSWORD=$OPENSEARCH_PASSWORD}"

echo "Waiting for function DynamoDBStreamHandlerDelta to be active..."
awslocal lambda wait function-active-v2 --function-name DynamoDBStreamHandlerDelta

awslocal lambda create-event-source-mapping \
  --function-name DynamoDBStreamHandlerDelta \
  --event-source "${STREAM_ARN}"  \
  --batch-size 5 \
  --starting-position LATEST

awslocal sns subscribe \
  --topic-arn "${DYNAMODB_SNS_TOPIC_ARN}" \
  --protocol lambda \
  --notification-endpoint arn:aws:lambda:${AWS_REGION}:000000000000:function:DynamoDBStreamHandlerDelta

awslocal lambda add-permission \
  --function-name DynamoDBStreamHandlerDelta \
  --statement-id AllowExecutionFromSNS \
  --action lambda:InvokeFunction \
  --principal sns.amazonaws.com \
  --source-arn "${DYNAMODB_SNS_TOPIC_ARN}"
