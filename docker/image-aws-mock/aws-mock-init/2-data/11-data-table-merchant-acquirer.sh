#!/bin/bash
set -euo pipefail

ACQUIRER_NAME="acquirer-for-test"

echo "Adding {merchant-docker-test} to {npgw.merchant-acquirer} table..."
ITEM=$(cat <<EOF
{
  "merchantId": {"S": "id.merchant-docker-test.rfyOe14jHYAAVODBqjTC-_Nr3HHSU_2zVeJN-VS-4tpwYLDf9PiqC4WPsw3KJytmkTg82wTajpLy3inhQqwK-w"},
  "acquirerList": {"L": [
    {
      "M": {
        "priority": {"N": "0"},
        "acquirerCode": {"S": "Test"},
        "acquirerName": {"S": "${ACQUIRER_NAME}"},
        "acquirerDisplayName": {"S": "${ACQUIRER_NAME}"},
        "acquirerConfig": {"S": "{\"passcodeUrl\": \"http://merchant-service:8080/merchant-v1/page/post/passcode\"}"},
        "isActive": {"BOOL": true},
        "currencyList": {"L": [{"S": "EUR"}]},
        "systemConfig": {"M": {
                "challengeUrl": {"S": "http://merchant-service:8080/merchant-v1/challenge"},
                "fingerprintUrl": {"S": "http://merchant-service:8080/merchant-v1/fingerprint"},
                "notificationQueue": {"S": "notification.fifo"},
                "resourceUrl": {"S": "http://merchant-service:8080/merchant-v1/resource"}}}
      }
    }
  ]}
}
EOF
)
aws dynamodb put-item \
  --table-name npgw.merchant-acquirer \
  --item "$ITEM" \
  --region "${AWS_REGION}" \
  --output text

echo "Adding {merchant-docker-test-local} to {npgw.merchant-acquirer} table..."
ITEM=$(cat <<EOF
{
  "merchantId": {"S": "id.merchant-docker-test-local.YPxPwXeNNekjVuP4B_ZSi-7jchJ4tPPGwuWjuhxN5PYvEjpm1E7JWoaAMoVXFw2K3iFJrLgGXeGfb9piuiOX0g"},
  "acquirerList": {"L": [
    {
      "M": {
        "priority": {"N": "0"},
        "acquirerCode": {"S": "Test"},
        "acquirerName": {"S": "${ACQUIRER_NAME}"},
        "acquirerDisplayName": {"S": "${ACQUIRER_NAME}"},
        "acquirerConfig": {"S": "{\"passcodeUrl\": \"http://localhost:8080/merchant-v1/page/post/passcode\"}"},
        "isActive": {"BOOL": true},
        "currencyList": {"L": [{"S": "EUR"}]},
        "systemConfig": {"M": {
                "challengeUrl": {"S": "http://localhost:8080/merchant-v1/challenge"},
                "fingerprintUrl": {"S": "http://localhost:8080/merchant-v1/fingerprint"},
                "notificationQueue": {"S": "notification.fifo"},
                "resourceUrl": {"S": "http://localhost:8080/merchant-v1/resource"}}}
      }
    }
  ]}
}
EOF
)
aws dynamodb put-item \
  --table-name npgw.merchant-acquirer \
  --item "$ITEM" \
  --region "${AWS_REGION}" \
  --output text

echo "Adding {merchant-server-test} to {npgw.merchant-acquirer} table..."
ITEM=$(cat <<EOF
{
  "merchantId": {"S": "id.merchant-server-test.H022XLHIh2iQqOenc6IP6p75XQNmDlLP1j0p8ou-EGJ9NDSROxZxlNZqoOa0TMeG_PSLh3Rv9Q6aQq6OsmW_rg"},
  "acquirerList": {"L": [
    {
      "M": {
        "priority": {"N": "0"},
        "acquirerCode": {"S": "Test"},
        "acquirerName": {"S": "${ACQUIRER_NAME}"},
        "acquirerDisplayName": {"S": "${ACQUIRER_NAME}"},
        "acquirerConfig": {"S": "{\"passcodeUrl\": \"http://localhost:8080/merchant-v1/page/post/passcode\"}"},
        "isActive": {"BOOL": true},
        "currencyList": {"L": [{"S": "EUR"}]},
        "systemConfig": {"M": {
                "challengeUrl": {"S": "https://${ENVIRONMENT_NAME}.npgw.xyz/merchant-v1/challenge"},
                "fingerprintUrl": {"S": "https://${ENVIRONMENT_NAME}.npgw.xyz/merchant-v1/fingerprint"},
                "notificationQueue": {"S": "notification.fifo"},
                "resourceUrl": {"S": "https://${ENVIRONMENT_NAME}.npgw.xyz/merchant-v1/resource"}}}
      }
    }
  ]}
}
EOF
)
aws dynamodb put-item \
  --table-name npgw.merchant-acquirer \
  --item "$ITEM" \
  --region "${AWS_REGION}" \
  --output text

echo "Adding {merchant-server-test-local} to {npgw.merchant-acquirer} table..."
ITEM=$(cat <<EOF
{
  "merchantId": {"S": "id.merchant-server-test-local.NTz5YYvitRQ8o8p0qD7G3tuZk7PqnaTXDx6JC_AR_xGebls29FAC_DTi0xZNieAKSjVrIxgy7xBccmod3-vndg"},
  "acquirerList": {"L": [
    {
      "M": {
        "priority": {"N": "0"},
        "acquirerCode": {"S": "Test"},
        "acquirerName": {"S": "${ACQUIRER_NAME}"},
        "acquirerDisplayName": {"S": "${ACQUIRER_NAME}"},
        "acquirerConfig": {"S": "{\"passcodeUrl\": \"http://localhost:8080/merchant-v1/page/post/passcode\"}"},
        "isActive": {"BOOL": true},
        "currencyList": {"L": [{"S": "EUR"}]},
        "systemConfig": {"M": {
                "challengeUrl": {"S": "http://localhost:8080/merchant-v1/challenge"},
                "fingerprintUrl": {"S": "http://localhost:8080/merchant-v1/fingerprint"},
                "notificationQueue": {"S": "notification.fifo"},
                "resourceUrl": {"S": "http://localhost:8080/merchant-v1/resource"}}}
      }
    }
  ]}
}
EOF
)
aws dynamodb put-item \
  --table-name npgw.merchant-acquirer \
  --item "$ITEM" \
  --region "${AWS_REGION}" \
  --output text

echo "Adding {merchant-docker-ngenius} to {npgw.merchant-acquirer} table..."
ITEM=$(cat <<EOF
{
  "merchantId": {"S": "id.merchant-docker-ngenius.PNmqbErfhMBQjoKUc3o3mn9VZhev37vpi4wD-L5Fx_nwjLxFNzrg8maVxNgXXJLGmn24xcVNYez3CBaFXyOn4w"},
  "acquirerList": {"L": [
    {
      "M": {
        "priority": {"N": "0"},
        "acquirerCode": {"S": "NGenius"},
        "acquirerName": {"S": "${ACQUIRER_NAME}"},
        "acquirerDisplayName": {"S": "${ACQUIRER_NAME}"},
        "acquirerConfig": {"S": "{\"tokenUrl\": \"http://mock-acquirer-ngenius-service/identity/auth/access-token\", \
\"apiKey\": \"ZmE1NWY1MmItNDFmNC00YzQ5LThlOWYtMWM1YTkyY2ZjMjIwOjRlYjRmMmJhLTk1MTYtNDA1ZS04ZGYwLTkwNjkwNjRkOTQxYw==\", \
\"paymentUrl\": \"http://mock-acquirer-ngenius-service/transactions/outlets/9af51c82-3525-491b-b4f1-4708d8a8608f/payment/card\", \
\"captureUrl\":\"http://mock-acquirer-ngenius-service/transactions/outlets/9af51c82-3525-491b-b4f1-4708d8a8608f/orders/%s/payments/%s/captures\", \
\"refundUrl\":\"http://mock-acquirer-ngenius-service/transactions/outlets/9af51c82-3525-491b-b4f1-4708d8a8608f/orders/%s/payments/%s/purchases/%s/refund\", \
\"refundCaptureUrl\":\"http://mock-acquirer-ngenius-service/transactions/outlets/9af51c82-3525-491b-b4f1-4708d8a8608f/orders/%s/payments/%s/captures/%s/refund\", \
\"cancelUrl\":\"http://mock-acquirer-ngenius-service/transactions/outlets/9af51c82-3525-491b-b4f1-4708d8a8608f/orders/%s/payments/%s/cancel\", \
\"serviceUrl\":\"http://acquirer-ngenius-service:8082/ngenius-v1/token\",\"transactionMinAmount\":1000,\"transactionMaxAmount\":250000}"},
        "isActive": {"BOOL": true},
        "currencyList": {"L": [{"S": "EUR"}]},
        "systemConfig": {"M": {
                "challengeUrl": {"S": "http://merchant-service:8080/merchant-v1/challenge"},
                "fingerprintUrl": {"S": "http://merchant-service:8080/merchant-v1/fingerprint"},
                "notificationQueue": {"S": "notification.fifo"},
                "resourceUrl": {"S": "http://merchant-service:8080/merchant-v1/resource"}}}
      }
    }
  ]}
}
EOF
)
aws dynamodb put-item \
  --table-name npgw.merchant-acquirer \
  --item "$ITEM" \
  --region "${AWS_REGION}" \
  --output text

echo "Adding {merchant-docker-ngenius-local} to {npgw.merchant-acquirer} table..."
ITEM=$(cat <<EOF
{
  "merchantId": {"S": "id.merchant-docker-ngenius-local.eVhQr4O_UH_joNMAaVv6CrL_O2xFKM4xBzGk3vckTwSs3b_IlycYtPDTlsPYPYGPaXGkZ-7fV5W15NG0eszOkQ"},
  "acquirerList": {"L": [
    {
      "M": {
        "priority": {"N": "0"},
        "acquirerCode": {"S": "NGenius"},
        "acquirerName": {"S": "${ACQUIRER_NAME}"},
        "acquirerDisplayName": {"S": "${ACQUIRER_NAME}"},
        "acquirerConfig": {"S": "{\"tokenUrl\": \"http://mock-acquirer-ngenius-service/identity/auth/access-token\", \
\"apiKey\": \"ZmE1NWY1MmItNDFmNC00YzQ5LThlOWYtMWM1YTkyY2ZjMjIwOjRlYjRmMmJhLTk1MTYtNDA1ZS04ZGYwLTkwNjkwNjRkOTQxYw==\", \
\"paymentUrl\": \"http://mock-acquirer-ngenius-service/transactions/outlets/9af51c82-3525-491b-b4f1-4708d8a8608f/payment/card\", \
\"captureUrl\":\"http://mock-acquirer-ngenius-service/transactions/outlets/9af51c82-3525-491b-b4f1-4708d8a8608f/orders/%s/payments/%s/captures\", \
\"refundUrl\":\"http://mock-acquirer-ngenius-service/transactions/outlets/9af51c82-3525-491b-b4f1-4708d8a8608f/orders/%s/payments/%s/purchases/%s/refund\", \
\"refundCaptureUrl\":\"http://mock-acquirer-ngenius-service/transactions/outlets/9af51c82-3525-491b-b4f1-4708d8a8608f/orders/%s/payments/%s/captures/%s/refund\", \
\"cancelUrl\":\"http://mock-acquirer-ngenius-service/transactions/outlets/9af51c82-3525-491b-b4f1-4708d8a8608f/orders/%s/payments/%s/cancel\", \
\"serviceUrl\":\"http://acquirer-ngenius-service:8082/ngenius-v1/token\",\"transactionMinAmount\":1000,\"transactionMaxAmount\":250000}"},
        "isActive": {"BOOL": true},
        "currencyList": {"L": [{"S": "EUR"}]},
        "systemConfig": {"M": {
                "challengeUrl": {"S": "http://localhost:8080/merchant-v1/challenge"},
                "fingerprintUrl": {"S": "http://localhost:8080/merchant-v1/fingerprint"},
                "notificationQueue": {"S": "notification.fifo"},
                "resourceUrl": {"S": "http://localhost:8080/merchant-v1/resource"}}}
      }
    }
  ]}
}
EOF
)
aws dynamodb put-item \
  --table-name npgw.merchant-acquirer \
  --item "$ITEM" \
  --region "${AWS_REGION}" \
  --output text

echo "Adding {merchant-server-ngenius} to {npgw.merchant-acquirer} table..."
ITEM=$(cat <<EOF
{
  "merchantId": {"S": "id.merchant-server-ngenius.EmoNgIah-HdduYAOlhTEXrt2T6rbHMBnuZECOH-CVjV7VfTjdmQ53UIrxzoiqqflu2wrhjS4Kz9xRQWXnMRNLQ"},
  "acquirerList": {"L": [
    {
      "M": {
        "priority": {"N": "0"},
        "acquirerCode": {"S": "NGenius"},
        "acquirerName": {"S": "${ACQUIRER_NAME}"},
        "acquirerDisplayName": {"S": "${ACQUIRER_NAME}"},
        "acquirerConfig": {"S": "{\"tokenUrl\": \"https://api-gateway.sandbox.ngenius-payments.com/identity/auth/access-token\", \
\"apiKey\": \"ZmE1NWY1MmItNDFmNC00YzQ5LThlOWYtMWM1YTkyY2ZjMjIwOjRlYjRmMmJhLTk1MTYtNDA1ZS04ZGYwLTkwNjkwNjRkOTQxYw==\", \
\"paymentUrl\": \"https://api-gateway.sandbox.ngenius-payments.com/transactions/outlets/9af51c82-3525-491b-b4f1-4708d8a8608f/payment/card\", \
\"captureUrl\":\"https://api-gateway.sandbox.ngenius-payments.com/transactions/outlets/9af51c82-3525-491b-b4f1-4708d8a8608f/orders/%s/payments/%s/captures\", \
\"refundUrl\":\"https://api-gateway.sandbox.ngenius-payments.com/transactions/outlets/9af51c82-3525-491b-b4f1-4708d8a8608f/orders/%s/payments/%s/purchases/%s/refund\", \
\"refundCaptureUrl\":\"https://api-gateway.sandbox.ngenius-payments.com/transactions/outlets/9af51c82-3525-491b-b4f1-4708d8a8608f/orders/%s/payments/%s/captures/%s/refund\", \
\"cancelUrl\":\"https://api-gateway.sandbox.ngenius-payments.com/transactions/outlets/9af51c82-3525-491b-b4f1-4708d8a8608f/orders/%s/payments/%s/cancel\", \
\"serviceUrl\":\"http://acquirer-ngenius.acquirer-ngenius-terraform:8082/ngenius-v1/token\",\"transactionMinAmount\":1000,\"transactionMaxAmount\":250000}"},
        "isActive": {"BOOL": true},
        "currencyList": {"L": [{"S": "EUR"}]},
        "systemConfig": {"M": {
                "challengeUrl": {"S": "https://${ENVIRONMENT_NAME}.npgw.xyz/merchant-v1/challenge"},
                "fingerprintUrl": {"S": "https://${ENVIRONMENT_NAME}.npgw.xyz/merchant-v1/fingerprint"},
                "notificationQueue": {"S": "notification.fifo"},
                "resourceUrl": {"S": "https://${ENVIRONMENT_NAME}.npgw.xyz/merchant-v1/resource"}}}
      }
    }
  ]}
}
EOF
)
aws dynamodb put-item \
  --table-name npgw.merchant-acquirer \
  --item "$ITEM" \
  --region "${AWS_REGION}" \
  --output text

echo "Adding {merchant-server-ngenius-local} to {npgw.merchant-acquirer} table..."
ITEM=$(cat <<EOF
{
  "merchantId": {"S": "id.merchant-server-ngenius-local.qTn68flBBBclgT-GnOQRKhO8N7QJhOHv52ltu3eeRH4Ysd2PQfy4OfZFoqbIk_CfgzNIkoqBXHfWti9tpHwlRA"},
  "acquirerList": {"L": [
    {
      "M": {
        "priority": {"N": "0"},
        "acquirerCode": {"S": "NGenius"},
        "acquirerName": {"S": "${ACQUIRER_NAME}"},
        "acquirerDisplayName": {"S": "${ACQUIRER_NAME}"},
        "acquirerConfig": {"S": "{\"tokenUrl\": \"https://api-gateway.sandbox.ngenius-payments.com/identity/auth/access-token\", \
\"apiKey\": \"ZmE1NWY1MmItNDFmNC00YzQ5LThlOWYtMWM1YTkyY2ZjMjIwOjRlYjRmMmJhLTk1MTYtNDA1ZS04ZGYwLTkwNjkwNjRkOTQxYw==\", \
\"paymentUrl\": \"https://api-gateway.sandbox.ngenius-payments.com/transactions/outlets/9af51c82-3525-491b-b4f1-4708d8a8608f/payment/card\", \
\"captureUrl\":\"https://api-gateway.sandbox.ngenius-payments.com/transactions/outlets/9af51c82-3525-491b-b4f1-4708d8a8608f/orders/%s/payments/%s/captures\", \
\"refundUrl\":\"https://api-gateway.sandbox.ngenius-payments.com/transactions/outlets/9af51c82-3525-491b-b4f1-4708d8a8608f/orders/%s/payments/%s/purchases/%s/refund\", \
\"refundCaptureUrl\":\"https://api-gateway.sandbox.ngenius-payments.com/transactions/outlets/9af51c82-3525-491b-b4f1-4708d8a8608f/orders/%s/payments/%s/captures/%s/refund\", \
\"cancelUrl\":\"https://api-gateway.sandbox.ngenius-payments.com/transactions/outlets/9af51c82-3525-491b-b4f1-4708d8a8608f/orders/%s/payments/%s/cancel\", \
\"serviceUrl\":\"http://localhost:8082/ngenius-v1/token\",\"transactionMinAmount\":1000,\"transactionMaxAmount\":250000}"},
        "isActive": {"BOOL": true},
        "currencyList": {"L": [{"S": "EUR"}]},
        "systemConfig": {"M": {
                "challengeUrl": {"S": "http://localhost:8080/merchant-v1/challenge"},
                "fingerprintUrl": {"S": "http://localhost:8080/merchant-v1/fingerprint"},
                "notificationQueue": {"S": "notification.fifo"},
                "resourceUrl": {"S": "http://localhost:8080/merchant-v1/resource"}}}
      }
    }
  ]}
}
EOF
)
aws dynamodb put-item \
  --table-name npgw.merchant-acquirer \
  --item "$ITEM" \
  --region "${AWS_REGION}" \
  --output text