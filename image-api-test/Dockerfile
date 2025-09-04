FROM mcr.microsoft.com/playwright/java:v1.53.0
#FROM playwright/chromium:playwright-1.53.2

# run container:
#   docker run
#       -e SERVICE_MERCHANT_URL=<merchantServiceUrl>
#       -e SERVICE_MERCHANT_ID_TEST=<merchantId>
#       -e SERVICE_MERCHANT_ID_NGENIUS=<merchantId>
#       -e SERVICE_MERCHANT_USER_EMAIL=<email>
#       -e SERVICE_MERCHANT_USER_PASSWORD=<password>
#       -e SERVICE_PORTAL_URL=<portalServiceUrl>
#       -e SERVICE_PORTAL_ID_TEST=<merchantId>
#       -e SERVICE_PORTAL_ID_NGENIUS=<merchantId>
#       -e SERVICE_PORTAL_USER_EMAIL=<email>
#       -e SERVICE_PORTAL_USER_PASSWORD=<password>
#       api-test:latest

USER root
WORKDIR /

RUN apt-get update && \
    apt-get install -y openjdk-17-jre-headless && \
    apt-get clean && \
    mkdir -p /allure-results

ENV PLAYWRIGHT_BROWSER=${PLAYWRIGHT_BROWSER:-chromium}
ENV PLAYWRIGHT_OPTIONS_CONTEXT=${PLAYWRIGHT_OPTIONS_CONTEXT:-setLocale=en-US;setTimezoneId=Europe/Berlin;setViewportSize=1920,1080;setUserAgent=Chromium;setExtraHTTPHeaders=sec-ch-ua:"Chromium"}

VOLUME /tmp

COPY merchant-api-test/target/merchant-api-test-*-test-jar-with-dependencies.jar merchant-api-test-jar-with-dependencies.jar
COPY portal-api-test/target/portal-api-test-*-test-jar-with-dependencies.jar portal-api-test-jar-with-dependencies.jar

ENTRYPOINT ["sh", "-c", "java -jar merchant-api-test-jar-with-dependencies.jar && java -jar portal-api-test-jar-with-dependencies.jar"]
