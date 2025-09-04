#!/bin/bash
set -euo pipefail

echo "Fetching User Pool ID"
USER_POOL_ID=$(
  aws ssm get-parameter \
    --name "/portal/cognito/pool-id" \
    --region "${AWS_REGION}" \
    --query "Parameter.Value" \
    --output text \
    --with-decryption
)

PORTAL_USERS_CONFIG=(
  "${SERVICE_PORTAL_USER_EMAIL}|SUPER|[]|super"
  "admin.for.test@email.com|ADMIN|[]|company&for&test"
  "user.for.test@email.com|USER|[\"id.merchant.1\",\"id.merchant.2\"]|company&for&test"
  "admin-test@email.com|ADMIN|[]|CompanyForTestRunOnly Inc."
  "user-test@email.com|USER|[\"id.merchant-server-ngenius.EmoNgIah-HdduYAOlhTEXrt2T6rbHMBnuZECOH-CVjV7VfTjdmQ53UIrxzoiqqflu2wrhjS4Kz9xRQWXnMRNLQ\",\"id.merchant-server-test.H022XLHIh2iQqOenc6IP6p75XQNmDlLP1j0p8ou-EGJ9NDSROxZxlNZqoOa0TMeG_PSLh3Rv9Q6aQq6OsmW_rg\",\"id.merchant-server-test-local.NTz5YYvitRQ8o8p0qD7G3tuZk7PqnaTXDx6JC_AR_xGebls29FAC_DTi0xZNieAKSjVrIxgy7xBccmod3-vndg\",\"id.merchant-docker-ngenius.PNmqbErfhMBQjoKUc3o3mn9VZhev37vpi4wD-L5Fx_nwjLxFNzrg8maVxNgXXJLGmn24xcVNYez3CBaFXyOn4w\",\"id.merchant-docker-ngenius-local.eVhQr4O_UH_joNMAaVv6CrL_O2xFKM4xBzGk3vckTwSs3b_IlycYtPDTlsPYPYGPaXGkZ-7fV5W15NG0eszOkQ\",\"id.merchant-docker-test.rfyOe14jHYAAVODBqjTC-_Nr3HHSU_2zVeJN-VS-4tpwYLDf9PiqC4WPsw3KJytmkTg82wTajpLy3inhQqwK-w\",\"id.merchant-docker-test-local.YPxPwXeNNekjVuP4B_ZSi-7jchJ4tPPGwuWjuhxN5PYvEjpm1E7JWoaAMoVXFw2K3iFJrLgGXeGfb9piuiOX0g\"]|CompanyForTestRunOnly Inc."
)

for CONFIG in "${PORTAL_USERS_CONFIG[@]}"; do
  IFS='|' read -r PORTAL_USER_EMAIL ROLE MERCHANT_IDS FAMILY_NAME <<< "$CONFIG"

  echo "Checking if portal user exists: ${PORTAL_USER_EMAIL}"
  if aws cognito-idp admin-get-user \
      --user-pool-id "${USER_POOL_ID}" \
      --username "${PORTAL_USER_EMAIL}" \
      --region "${AWS_REGION}" > /dev/null 2>&1; then

    echo "User ${PORTAL_USER_EMAIL} already exists. Deleting..."
    aws cognito-idp admin-delete-user \
      --user-pool-id "${USER_POOL_ID}" \
      --username "${PORTAL_USER_EMAIL}" \
      --region "${AWS_REGION}"
  fi

  echo "Creating portal user: ${PORTAL_USER_EMAIL}"
  aws cognito-idp admin-create-user \
    --user-pool-id "${USER_POOL_ID}" \
    --username "${PORTAL_USER_EMAIL}" \
    --temporary-password "${SERVICE_PORTAL_USER_PASSWORD}" \
    --user-attributes \
      Name="custom:userRole",Value="${ROLE}" \
      Name="custom:merchantIds",Value="'${MERCHANT_IDS}'" \
      Name="family_name",Value="${FAMILY_NAME}" \
    --region "${AWS_REGION}"

  echo "Setting portal user password for user ${PORTAL_USER_EMAIL}"
  aws cognito-idp admin-set-user-password \
    --user-pool-id "${USER_POOL_ID}" \
    --username "${PORTAL_USER_EMAIL}" \
    --password "${SERVICE_PORTAL_USER_PASSWORD}" \
    --permanent \
    --region "${AWS_REGION}"
done
