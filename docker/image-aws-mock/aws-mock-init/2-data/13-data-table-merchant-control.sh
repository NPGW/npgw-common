#!/bin/bash
set -euo pipefail

CONTROL_NAME="control-for-test"
CONTROL_CODE="Neutrino"

echo "Adding {merchant-docker-test} to {npgw.merchant-control} table..."
ITEM=$(cat <<EOF
{
  "merchantId": {"S": "id.merchant-docker-test.rfyOe14jHYAAVODBqjTC-_Nr3HHSU_2zVeJN-VS-4tpwYLDf9PiqC4WPsw3KJytmkTg82wTajpLy3inhQqwK-w"},
  "controlList": {"L": [
    {
      "M": {
        "priority": {"N": "0"},
        "controlCode": {"S": "${CONTROL_CODE}"},
        "controlName": {"S": "${CONTROL_NAME}"},
        "controlDisplayName": {"S": "${CONTROL_NAME}"},
        "controlConfig": {"S": ""},
        "isActive": {"BOOL": true}
      }
    }
  ]}
}
EOF
)
aws dynamodb put-item \
  --table-name npgw.merchant-control \
  --item "$ITEM" \
  --region "${AWS_REGION}" \
  --output text

echo "Adding {merchant-docker-test-local} to {npgw.merchant-control} table..."
ITEM=$(cat <<EOF
{
  "merchantId": {"S": "id.merchant-docker-test-local.YPxPwXeNNekjVuP4B_ZSi-7jchJ4tPPGwuWjuhxN5PYvEjpm1E7JWoaAMoVXFw2K3iFJrLgGXeGfb9piuiOX0g"},
  "controlList": {"L": [
    {
      "M": {
        "priority": {"N": "0"},
        "controlCode": {"S": "${CONTROL_CODE}"},
        "controlName": {"S": "${CONTROL_NAME}"},
        "controlDisplayName": {"S": "${CONTROL_NAME}"},
        "controlConfig": {"S": ""},
        "isActive": {"BOOL": true}
      }
    }
  ]}
}
EOF
)
aws dynamodb put-item \
  --table-name npgw.merchant-control \
  --item "$ITEM" \
  --region "${AWS_REGION}" \
  --output text

echo "Adding {merchant-server-test} to {npgw.merchant-control} table..."
ITEM=$(cat <<EOF
{
  "merchantId": {"S": "id.merchant-server-test.H022XLHIh2iQqOenc6IP6p75XQNmDlLP1j0p8ou-EGJ9NDSROxZxlNZqoOa0TMeG_PSLh3Rv9Q6aQq6OsmW_rg"},
  "controlList": {"L": [
    {
      "M": {
        "priority": {"N": "0"},
        "controlCode": {"S": "${CONTROL_CODE}"},
        "controlName": {"S": "${CONTROL_NAME}"},
        "controlDisplayName": {"S": "${CONTROL_NAME}"},
        "controlConfig": {"S": ""},
        "isActive": {"BOOL": true}
      }
    }
  ]}
}
EOF
)
aws dynamodb put-item \
  --table-name npgw.merchant-control \
  --item "$ITEM" \
  --region "${AWS_REGION}" \
  --output text

echo "Adding {merchant-server-test-local} to {npgw.merchant-control} table..."
ITEM=$(cat <<EOF
{
  "merchantId": {"S": "id.merchant-server-test-local.NTz5YYvitRQ8o8p0qD7G3tuZk7PqnaTXDx6JC_AR_xGebls29FAC_DTi0xZNieAKSjVrIxgy7xBccmod3-vndg"},
  "controlList": {"L": [
    {
      "M": {
        "priority": {"N": "0"},
        "controlCode": {"S": "${CONTROL_CODE}"},
        "controlName": {"S": "${CONTROL_NAME}"},
        "controlDisplayName": {"S": "${CONTROL_NAME}"},
        "controlConfig": {"S": ""},
        "isActive": {"BOOL": true}
      }
    }
  ]}
}
EOF
)
aws dynamodb put-item \
  --table-name npgw.merchant-control \
  --item "$ITEM" \
  --region "${AWS_REGION}" \
  --output text

echo "Adding {merchant-docker-ngenius} to {npgw.merchant-control} table..."
ITEM=$(cat <<EOF
{
  "merchantId": {"S": "id.merchant-docker-ngenius.PNmqbErfhMBQjoKUc3o3mn9VZhev37vpi4wD-L5Fx_nwjLxFNzrg8maVxNgXXJLGmn24xcVNYez3CBaFXyOn4w"},
  "controlList": {"L": [
    {
      "M": {
        "priority": {"N": "0"},
        "controlCode": {"S": "${CONTROL_CODE}"},
        "controlName": {"S": "${CONTROL_NAME}"},
        "controlDisplayName": {"S": "${CONTROL_NAME}"},
        "controlConfig": {"S": ""},
        "isActive": {"BOOL": true}
      }
    }
  ]}
}
EOF
)
aws dynamodb put-item \
  --table-name npgw.merchant-control \
  --item "$ITEM" \
  --region "${AWS_REGION}" \
  --output text

echo "Adding {merchant-docker-ngenius-local} to {npgw.merchant-control} table..."
ITEM=$(cat <<EOF
{
  "merchantId": {"S": "id.merchant-docker-ngenius-local.eVhQr4O_UH_joNMAaVv6CrL_O2xFKM4xBzGk3vckTwSs3b_IlycYtPDTlsPYPYGPaXGkZ-7fV5W15NG0eszOkQ"},
  "controlList": {"L": [
    {
      "M": {
        "priority": {"N": "0"},
        "controlCode": {"S": "${CONTROL_CODE}"},
        "controlName": {"S": "${CONTROL_NAME}"},
        "controlDisplayName": {"S": "${CONTROL_NAME}"},
        "controlConfig": {"S": ""},
        "isActive": {"BOOL": true}
      }
    }
  ]}
}
EOF
)
aws dynamodb put-item \
  --table-name npgw.merchant-control \
  --item "$ITEM" \
  --region "${AWS_REGION}" \
  --output text

echo "Adding {merchant-server-ngenius} to {npgw.merchant-control} table..."
ITEM=$(cat <<EOF
{
  "merchantId": {"S": "id.merchant-server-ngenius.EmoNgIah-HdduYAOlhTEXrt2T6rbHMBnuZECOH-CVjV7VfTjdmQ53UIrxzoiqqflu2wrhjS4Kz9xRQWXnMRNLQ"},
  "controlList": {"L": [
    {
      "M": {
        "priority": {"N": "0"},
        "controlCode": {"S": "${CONTROL_CODE}"},
        "controlName": {"S": "${CONTROL_NAME}"},
        "controlDisplayName": {"S": "${CONTROL_NAME}"},
        "controlConfig": {"S": ""},
        "isActive": {"BOOL": true}
      }
    }
  ]}
}
EOF
)
aws dynamodb put-item \
  --table-name npgw.merchant-control \
  --item "$ITEM" \
  --region "${AWS_REGION}" \
  --output text

echo "Adding {merchant-server-ngenius-local} to {npgw.merchant-control} table..."
ITEM=$(cat <<EOF
{
  "merchantId": {"S": "id.merchant-server-ngenius-local.qTn68flBBBclgT-GnOQRKhO8N7QJhOHv52ltu3eeRH4Ysd2PQfy4OfZFoqbIk_CfgzNIkoqBXHfWti9tpHwlRA"},
  "controlList": {"L": [
    {
      "M": {
        "priority": {"N": "0"},
        "controlCode": {"S": "${CONTROL_CODE}"},
        "controlName": {"S": "${CONTROL_NAME}"},
        "controlDisplayName": {"S": "${CONTROL_NAME}"},
        "controlConfig": {"S": ""},
        "isActive": {"BOOL": true}
      }
    }
  ]}
}
EOF
)
aws dynamodb put-item \
  --table-name npgw.merchant-control \
  --item "$ITEM" \
  --region "${AWS_REGION}" \
  --output text

