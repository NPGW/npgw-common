FROM localstack/localstack-pro:stable
HEALTHCHECK --interval=20s --timeout=20s --start-period=20s --retries=10 \
  CMD curl -sf http://localhost:4566/_localstack/init/ready | grep -q '"completed": true' || exit 1
