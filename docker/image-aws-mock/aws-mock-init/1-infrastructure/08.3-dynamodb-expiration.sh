#!/bin/bash


echo "Setting up transaction expiration lambdas..."

DYNAMODB_SNS_TOPIC_ARN=$(awslocal ssm get-parameter \
  --name "/common/transaction/dynamodb-sns-topic-arn" \
  --region "${AWS_REGION}" \
  --query "Parameter.Value" \
  --output text)
echo "DynamoDB Topic ARN: $DYNAMODB_SNS_TOPIC_ARN"

SCHEDULER_LAMBDA_NAME="TransactionExpireScheduler"
HANDLER_LAMBDA_NAME="TransactionExpireHandler"


echo "Creating Scheduler Lambda..."
awslocal lambda create-function \
  --function-name "$SCHEDULER_LAMBDA_NAME" \
  --zip-file fileb:///lambda/dbstream/lambda_transaction_expire_scheduler.zip \
  --role arn:aws:iam::000000000000:role/lambda-role \
  --handler lambda_handler_schedule_expire.lambda_handler_schedule_expire \
  --timeout 50 \
  --runtime python3.9 \
  --environment Variables="{AWS_ENDPOINT_URL=http://aws-mock:4566,EXPIRE_LAMBDA_NAME=$HANDLER_LAMBDA_NAME,LAMBDA_HANDLER_EXPIRE_ROLE_ARN=arn:aws:iam::000000000000:role/lambda-role,ENVIRONMENT_TYPE=EE}"

echo "Waiting for $SCHEDULER_LAMBDA_NAME to become active..."
awslocal lambda wait function-active-v2 --function-name "$SCHEDULER_LAMBDA_NAME"

awslocal lambda put-function-concurrency --function-name "$SCHEDULER_LAMBDA_NAME" --reserved-concurrent-executions 1

awslocal sns subscribe \
  --topic-arn "$DYNAMODB_SNS_TOPIC_ARN" \
  --protocol lambda \
  --notification-endpoint arn:aws:lambda:${AWS_REGION}:000000000000:function:$SCHEDULER_LAMBDA_NAME

awslocal lambda add-permission \
  --function-name "$SCHEDULER_LAMBDA_NAME" \
  --statement-id "AllowExecutionFromSNSForScheduler" \
  --action lambda:InvokeFunction \
  --principal sns.amazonaws.com \
  --source-arn "$DYNAMODB_SNS_TOPIC_ARN"


echo "Creating Expiration handler Lambda..."
awslocal lambda create-function \
  --function-name "$HANDLER_LAMBDA_NAME" \
  --zip-file fileb:///lambda/dbstream/lambda_transaction_expire_handler.zip \
  --role arn:aws:iam::000000000000:role/lambda-role \
  --handler lambda_handler_expire_transaction.lambda_handler_expire_transaction \
  --timeout 50 \
  --runtime python3.9 \
  --environment Variables="{AWS_ENDPOINT_URL=http://aws-mock:4566,ENVIRONMENT_TYPE=EE}"

echo "Waiting for $HANDLER_LAMBDA_NAME to become active..."
awslocal lambda wait function-active-v2 --function-name "$HANDLER_LAMBDA_NAME"

awslocal lambda add-permission \
  --function-name "$HANDLER_LAMBDA_NAME" \
  --statement-id "AllowExecutionFromEvents" \
  --action lambda:InvokeFunction \
  --principal events.amazonaws.com \
  --source-arn "arn:aws:events:${AWS_REGION}:000000000000:rule/*"

echo "Transaction expiration lambdas deployment finished." 