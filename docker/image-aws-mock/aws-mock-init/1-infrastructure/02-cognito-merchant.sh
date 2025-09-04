#!/bin/bash
set -euo pipefail

echo "Create merchant user pool..."
MERCHANT_USER_POOL_ID=$(
  awslocal cognito-idp create-user-pool \
    --pool-name "TestMerchantPool" \
    --schema Name="merchantId",AttributeDataType="String",Mutable=true \
    --username-attributes email \
    --auto-verified-attributes email \
    --region "${AWS_REGION}" \
    --query 'UserPool.Id' \
    --output text
)
echo "Merchant user pool id: ${MERCHANT_USER_POOL_ID}"

echo "Saving parameter /merchant/cognito/pool-id"
awslocal ssm put-parameter \
  --name "/merchant/cognito/pool-id" \
  --value "${MERCHANT_USER_POOL_ID}" \
  --type "String" \
  --region "${AWS_REGION}" \
  --overwrite

echo "Creating client..."
MERCHANT_CLIENT_ID=$(
  awslocal cognito-idp create-user-pool-client \
    --user-pool-id "${MERCHANT_USER_POOL_ID}" \
    --client-name "TestAppName" \
    --region "${AWS_REGION}" \
    --query 'UserPoolClient.ClientId' \
    --output text
)
echo "Merchant Client id: ${MERCHANT_CLIENT_ID}"

echo "Saving parameter /merchant/cognito/client-id"
awslocal ssm put-parameter \
  --name "/merchant/cognito/client-id" \
  --value "${MERCHANT_CLIENT_ID}" \
  --type "String" \
  --region "${AWS_REGION}" \
  --overwrite

export MERCHANT_USER_POOL_ID
export MERCHANT_CLIENT_ID