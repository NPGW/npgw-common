#!/bin/bash
set -euo pipefail

echo "Fetching Merchant Pool ID..."
MERCHANT_USER_POOL_ID=$(
  aws ssm get-parameter \
    --name "/merchant/cognito/pool-id" \
    --region "${AWS_REGION}" \
    --query "Parameter.Value" \
    --output text \
    --with-decryption
)

echo "Checking if merchant exists: ${SERVICE_MERCHANT_USER_EMAIL}"
if aws cognito-idp admin-get-user \
    --user-pool-id "${MERCHANT_USER_POOL_ID}" \
    --username "${SERVICE_MERCHANT_USER_EMAIL}" \
    --region "${AWS_REGION}" > /dev/null 2>&1; then

  echo "Merchant user ${SERVICE_MERCHANT_USER_EMAIL} already exists. Deleting..."
  aws cognito-idp admin-delete-user \
    --user-pool-id "${MERCHANT_USER_POOL_ID}" \
    --username "${SERVICE_MERCHANT_USER_EMAIL}" \
    --region "${AWS_REGION}"
fi

echo "Creating merchant user: ${SERVICE_MERCHANT_USER_EMAIL}"
aws cognito-idp admin-create-user \
  --user-pool-id "${MERCHANT_USER_POOL_ID}" \
  --username "${SERVICE_MERCHANT_USER_EMAIL}" \
  --temporary-password "${SERVICE_MERCHANT_USER_PASSWORD}" \
  --user-attributes Name="custom:merchantId",Value="''" \
  --region "${AWS_REGION}"

echo "Setting password: ${SERVICE_MERCHANT_USER_PASSWORD} for merchant user ${SERVICE_MERCHANT_USER_EMAIL}"
aws cognito-idp admin-set-user-password \
  --user-pool-id "${MERCHANT_USER_POOL_ID}" \
  --username "${SERVICE_MERCHANT_USER_EMAIL}" \
  --password "${SERVICE_MERCHANT_USER_PASSWORD}" \
  --permanent \
  --region "${AWS_REGION}"