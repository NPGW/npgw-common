FROM mcr.microsoft.com/playwright/java:v1.53.0

# run container:
#   docker run
#       -e ENVIRONMENT_TYPE=AWS
#       -e SERVICE_MERCHANT_URL=<merchantServiceUrl>
#       -e SERVICE_MERCHANT_ID_TEST=<merchantId>
#       -e SERVICE_MERCHANT_ID_NGENIUS=<merchantId>
#       -e SERVICE_MERCHANT_USER_EMAIL=<email>
#       -e SERVICE_MERCHANT_USER_PASSWORD=<password>
#       load-test:latest

USER root
WORKDIR /

RUN apt-get update && \
    apt-get install -y openjdk-17-jre-headless && \
    apt-get clean;

ENV PLAYWRIGHT_BROWSER=${PLAYWRIGHT_BROWSER:-chromium}
ENV PLAYWRIGHT_OPTIONS_CONTEXT=${PLAYWRIGHT_OPTIONS_CONTEXT:-setLocale=en-US;setTimezoneId=Europe/Berlin;setViewportSize=1920,1080;setUserAgent=Chromium;setExtraHTTPHeaders=sec-ch-ua:"Chromium"}

VOLUME /tmp

COPY merchant-api-test/target/merchant-api-test-*-test-jar-with-dependencies.jar merchant-api-test-jar-with-dependencies.jar

ENTRYPOINT ["sh", "-c", "java -jar merchant-api-test-jar-with-dependencies.jar"]
