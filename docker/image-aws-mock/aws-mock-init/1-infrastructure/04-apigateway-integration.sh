#!/bin/bash
echo "Creating api gateway integration..."

API_ID=$(awslocal apigateway get-rest-apis --query 'items[0].id' --output text --region ${AWS_REGION})
USER_POOL_ID=$(awslocal cognito-idp list-user-pools --max-results 1 --query 'UserPools[0].Id' --output text --region ${AWS_REGION})
ROOT_RESOURCE_ID=$(awslocal apigateway get-resources --rest-api-id "${API_ID}" --query "items[?path=='/'].id" --output text --region ${AWS_REGION})

COGNITO_AUTHORIZER_ID=$(
  awslocal apigateway create-authorizer \
    --rest-api-id "$API_ID" \
    --name "CognitoAuthorizer" \
    --type "COGNITO_USER_POOLS" \
    --provider-arns "arn:aws:cognito-idp:${AWS_REGION}:000000000000:userpool/${USER_POOL_ID}" \
    --identity-source "method.request.header.Authorization" \
    --region "${AWS_REGION}" \
    --query 'id' \
    --output text
)

USER_RESOURCE_ID=$(
  awslocal apigateway create-resource \
    --rest-api-id "${API_ID}" \
    --parent-id "${ROOT_RESOURCE_ID}" \
    --path-part "user" \
    --region "${AWS_REGION}" \
    --output text \
    --query 'id'
)

TOKEN_RESOURCE_ID=$(
  awslocal apigateway create-resource \
    --rest-api-id "${API_ID}" \
    --parent-id "${USER_RESOURCE_ID}" \
    --path-part "token" \
    --region "${AWS_REGION}" \
    --output text \
    --query 'id'
)

awslocal apigateway put-method \
  --rest-api-id "${API_ID}" \
  --resource-id "${TOKEN_RESOURCE_ID}" \
  --http-method POST \
  --authorization-type NONE \
  --region "${AWS_REGION}"

awslocal apigateway put-integration \
  --rest-api-id "${API_ID}" \
  --resource-id "${TOKEN_RESOURCE_ID}" \
  --http-method POST \
  --type HTTP_PROXY \
  --integration-http-method POST \
  --uri "http://portal-service:8090/portal-v1/user/token" \
  --region "${AWS_REGION}"

awslocal apigateway put-method-response \
  --rest-api-id "${API_ID}" \
  --resource-id "${TOKEN_RESOURCE_ID}" \
  --http-method POST \
  --status-code 200 \
  --region "${AWS_REGION}"

awslocal apigateway put-method \
  --rest-api-id "${API_ID}" \
  --resource-id "${USER_RESOURCE_ID}" \
  --http-method GET \
  --authorization-type COGNITO_USER_POOLS \
  --authorizer-id "${COGNITO_AUTHORIZER_ID}" \
  --request-parameters "method.request.querystring.email=true" \
  --region "${AWS_REGION}"

awslocal apigateway put-integration \
  --rest-api-id "${API_ID}" \
  --resource-id "${USER_RESOURCE_ID}" \
  --http-method GET \
  --type HTTP \
  --integration-http-method GET \
  --uri "http://portal-service:8090/portal-v1/user" \
  --request-parameters "integration.request.querystring.email=method.request.querystring.email" \
  --region "${AWS_REGION}"

awslocal apigateway put-method-response \
  --rest-api-id "${API_ID}" \
  --resource-id "${USER_RESOURCE_ID}" \
  --http-method GET \
  --status-code 200 \
  --response-models '{"application/json": "Empty"}' \
  --region "${AWS_REGION}"

awslocal apigateway put-integration-response \
  --rest-api-id "${API_ID}" \
  --resource-id "${USER_RESOURCE_ID}" \
  --http-method GET \
  --status-code 200 \
  --selection-pattern "" \
  --response-templates '{"application/json": ""}' \
  --region "${AWS_REGION}"

awslocal apigateway create-deployment \
  --rest-api-id "${API_ID}" \
  --stage-name dev \
  --region "${AWS_REGION}" \
  --output text \
  --query 'id'

echo "API_ID=$API_ID"