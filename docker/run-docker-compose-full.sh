#!/bin/bash
#
# Usage:
#   ./run-docker-compose-full.sh <image_version> <npgw-root profile name locally>
#

IMAGE_VERSION=$1
AWS_PROFILE=$2

if [ -z "$IMAGE_VERSION" ]; then
  echo "Usage: $0 <image_version>"
  exit 1
fi

AWS_REGION="eu-central-1"
ECR_REPO="214404897309.dkr.ecr.eu-central-1.amazonaws.com"

echo "Checking AWS SSO login..."
aws sso login --profile $AWS_PROFILE
if [ $? -ne 0 ]; then
  echo "AWS SSO login failed!"
  exit 1
fi

echo "Logging into AWS ECR..."
aws ecr get-login-password --profile $AWS_PROFILE --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO

if [ $? -ne 0 ]; then
  echo "AWS ECR login failed!"
  exit 1
fi

IMAGE_VERSION=$IMAGE_VERSION docker compose -f ./docker-compose-full.yml up