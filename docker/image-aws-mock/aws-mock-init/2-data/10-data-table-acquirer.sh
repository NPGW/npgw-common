#!/bin/bash
set -euo pipefail

ACQUIRER_NAME="acquirer-for-test"

echo "Adding acquirer {${ACQUIRER_NAME}} to {npgw.acquirer} table..."
ITEM=$(cat <<EOF
{
  "acquirerCode": {"S": "NGenius"},
  "acquirerName": {"S": "${ACQUIRER_NAME}"},
  "acquirerConfig": {"S": "{\"passcodeUrl\": \"http://merchant-service:8080/merchant-v1/resource/test/passcode.html\"}"},
  "systemConfig": {"M": {
          "challengeUrl": {"S": "http://merchant-service:8080/merchant-v1/challenge"},
          "fingerprintUrl": {"S": "http://merchant-service:8080/merchant-v1/fingerprint"},
          "notificationQueue": {"S": "notification.fifo"},
          "resourceUrl": {"S": "http://merchant-service:8080/merchant-v1/resource"}}},
  "currencyList": {"L": [{"S": "EUR"}, {"S": "USD"}]},
  "isActive": {"BOOL": true}
}
EOF
)

aws dynamodb put-item \
  --table-name npgw.acquirer \
  --item "$ITEM" \
  --region "${AWS_REGION}" \
  --output text
