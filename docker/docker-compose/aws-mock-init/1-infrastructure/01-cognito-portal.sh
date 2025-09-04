#!/bin/bash
set -euo pipefail

echo "Create portal user pool..."
USER_POOL_ID=$(
  awslocal cognito-idp create-user-pool \
    --pool-name "TestPortalPool" \
    --schema Name="userRole",AttributeDataType="String",Mutable=true Name="merchantIds",AttributeDataType="String",Mutable=true \
    --username-attributes email \
    --auto-verified-attributes email \
    --region "${AWS_REGION}" \
    --query 'UserPool.Id' \
    --output text
)
echo "Portal user pool id: $USER_POOL_ID"

echo "Create parameter /portal/cognito/pool-id"
awslocal ssm put-parameter \
  --name "/portal/cognito/pool-id" \
  --value "${USER_POOL_ID}" \
  --type "String" \
  --region "${AWS_REGION}" \
  --overwrite

echo "Create client..."
CLIENT_ID=$(
  awslocal cognito-idp create-user-pool-client \
    --user-pool-id "${USER_POOL_ID}" \
    --client-name "TestAppName" \
    --region "${AWS_REGION}" \
    --query 'UserPoolClient.ClientId' \
    --output text
)
echo "Client id: $CLIENT_ID"

echo "Create parameter /portal/cognito/client-id"
awslocal ssm put-parameter \
  --name "/portal/cognito/client-id" \
  --value "${CLIENT_ID}" \
  --type "String" \
  --region "${AWS_REGION}" \
  --overwrite

export USER_POOL_ID