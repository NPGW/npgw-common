#!/bin/bash

COMPANY_NAME="CompanyForTestRunOnly Inc."

echo "Adding {${COMPANY_NAME}} to {npgw.company} table..."
ITEM=$(cat <<EOF
{
  "companyName": {"S": "${COMPANY_NAME}"},
  "companyType": {"S": ""},
  "companyAddress": {"M": {
          "city": {"S": ""},
          "state": {"S": ""},
          "zip": {"S": ""},
          "country": {"S": ""},
          "phone": {"S": ""},
          "mobile": {"S": ""},
          "fax": {"S": ""}}},
  "merchantList": {
    "L": [
      {
        "M": {
          "merchantId": {
            "S": "id.merchant-server-ngenius.EmoNgIah-HdduYAOlhTEXrt2T6rbHMBnuZECOH-CVjV7VfTjdmQ53UIrxzoiqqflu2wrhjS4Kz9xRQWXnMRNLQ"
          },
          "merchantTitle": {
            "S": "Merchant${COMPANY_NAME}"
          }
        }
      }
    ]
  },
  "description": {"S": ""},
  "website": {"S": ""},
  "primaryContact": {"S": ""},
  "email": {"S": ""},
  "isPortalActive": {"BOOL": true},
  "isApiActive": {"BOOL": true}
}
EOF
)
aws dynamodb put-item \
  --table-name npgw.company \
  --item "$ITEM" \
  --region "${AWS_REGION}" \
  --output text

COMPANY_NAME_2="company&for&test"

echo "Adding {${COMPANY_NAME_2}} to {npgw.company} table..."
ITEM=$(cat <<EOF
{
  "companyName": {"S": "${COMPANY_NAME_2}"},
  "companyType": {"S": ""},
  "companyAddress": {"M": {
          "city": {"S": ""},
          "state": {"S": ""},
          "zip": {"S": ""},
          "country": {"S": ""},
          "phone": {"S": ""},
          "mobile": {"S": ""},
          "fax": {"S": ""}}},
  "merchantList": {
    "L": [
      {
        "M": {
          "merchantId": {
            "S": "id.merchant.1"
          },
          "merchantTitle": {
            "S": "Merchant for test 1"
          }
        }
      },
      {
        "M": {
          "merchantId": {
            "S": "id.merchant.2"
          },
          "merchantTitle": {
            "S": "Merchant for test 2"
          }
        }
      },
      {
        "M": {
          "merchantId": {
            "S": "id.merchant.3"
          },
          "merchantTitle": {
            "S": "Merchant for test 3"
          }
        }
      }
    ]
  },
  "description": {"S": ""},
  "website": {"S": ""},
  "primaryContact": {"S": ""},
  "email": {"S": ""},
  "isPortalActive": {"BOOL": true},
  "isApiActive": {"BOOL": true}
}
EOF
)
aws dynamodb put-item \
  --table-name npgw.company \
  --item "$ITEM" \
  --region "${AWS_REGION}" \
  --output text
