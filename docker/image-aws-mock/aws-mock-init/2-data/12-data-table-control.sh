#!/bin/bash
set -euo pipefail

CONTROL_NAME="control-for-test"

echo "Adding control {${CONTROL_NAME}} to {npgw.control} table..."
ITEM=$(cat <<EOF
{
  "controlCode": {"S": "Neutrino"},
  "controlName": {"S": "${CONTROL_NAME}"},
  "controlConfig": {"S": ""},
  "isActive": {"BOOL": true},
  "controlDisplayName": {"S": "control-for-test displayName"}
}
EOF
)

aws dynamodb put-item \
  --table-name npgw.control \
  --item "$ITEM" \
  --region "${AWS_REGION}" \
  --output text

CONTROL_NAME="control-for-test-2"

echo "Adding control {${CONTROL_NAME}} to {npgw.control} table..."
ITEM=$(cat <<EOF
{
  "controlCode": {"S": "NGenius"},
  "controlName": {"S": "${CONTROL_NAME}"},
  "controlConfig": {"S": ""},
  "isActive": {"BOOL": true},
  "controlDisplayName": {"S": "control-for-test-2 displayName"}
}
EOF
)

aws dynamodb put-item \
  --table-name npgw.control \
  --item "$ITEM" \
  --region "${AWS_REGION}" \
  --output text
