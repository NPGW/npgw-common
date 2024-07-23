## 👋 Welcome to the NPGW GitHub 👋

NPGW provides various APIs to help you accept payments on your website or mobile application.

This repository contains NPGW API definition files, represented in the [OpenAPI Specification](https://www.openapis.org/) standard (formerly known as Swagger Specification).

The NPGW APIs have been created using the principles of REST. They will accept and return JSON-encoded bodies and responses, while using standard HTTP response codes & authentication.

### Merchant Registration

1. Once you have been successfully setup, our team will provide you with your unique `merchantId`.
2. Additionally a Merchant Service Account will be created for you to access the APIs.

## 📜 Documentation

* [Technical Documentation](https://npgw.github.io/npgw-api-specification/)
* [OpenAPI specification](https://editor.swagger.io/?url=https://raw.githubusercontent.com/NPGW/npgw-api-specification/main/api-merchant.yaml)

### Usage

There are multiple ways you can use the OpenAPI definition to explore the NPGW APIs:

* By using the classic Swagger toolset, upload these definitions to the [Swagger Editor](http://editor.swagger.io/) or [SwaggerHub](https://swaggerhub.com/).
* By using [Postman](https://www.getpostman.com/postman) to import the API definition and create your personal collection of requests.

### Test cards

Below you will find test cards to be used in the Sandbox/Stage environment for testing the listed transaction senarios.

| PAN | 3DS2 test scenario | Outcome |
| :--- | :--- | :--- |
| 2303779999000275 | Frictionless (3DS Status != C) | Success |
| 2303779999000408 | Challenge (3DS Status == C) | Success |
| 2303779999000291 | Frictionless (3DS Status == N) | Failed (Not Authenticated) |
| 2303779999000317 | Frictionless (3DS Status == U) | Failed (Unavailable) |
| 2303779999000424 | Challenge (3DS Status == N) | Failed (Not Authenticated) |
| 2303779999000432 | Challenge (3DS Status == U) | Failed (Unavailable) |
| 4093191766216474 | None 3DS enabled Card | Failed (Not attempted) |
| 4154939775666626 | Challenge (3DS Status == C) | Failed (Issuer Decline) |

❕ **NOTE:**
* _Any text for cardholder name, a future date for expiry, and three (3) numbers for cvv are accepted_
* _Enter any four (4) numbers if presented with a challenge prompt for 3DS_
* _Test cards will not be accepted on Production_

## 👩‍💻 Support

If you have a feature request, spotted a bug or a technical problem, contact our [Team](mailto:helpdesk@expefast.com).
