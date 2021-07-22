#!/usr/bin/env bash

# Setup Wiremock responses for Professional Reference Data based on existing Idam users

share_case_org_code="$(sh ./actions/idam-user-token.sh "${TEST_LAW_FIRM_SHARE_CASE_ORG_USERNAME}" "${TEST_LAW_FIRM_SHARE_CASE_ORG_PASSWORD}")"
share_case_org_id="$(curl --silent --show-error -X GET "${IDAM_URL}/details" -H "accept: application/json" -H "authorization: Bearer ${share_case_org_code}" | jq -r .id)"

share_case_a_code="$(sh ./actions/idam-user-token.sh "${TEST_LAW_FIRM_SHARE_CASE_A_USERNAME}" "${TEST_LAW_FIRM_SHARE_CASE_A_PASSWORD}")"
share_case_a_id="$(curl --silent --show-error -X GET "${IDAM_URL}/details" -H "accept: application/json" -H "authorization: Bearer ${share_case_a_code}" | jq -r .id)"

share_case_b_code="$(sh ./actions/idam-user-token.sh "${TEST_LAW_FIRM_SHARE_CASE_B_USERNAME}" "${TEST_LAW_FIRM_SHARE_CASE_B_PASSWORD}")"
share_case_b_id="$(curl --silent --show-error -X GET "${IDAM_URL}/details" -H "accept: application/json" -H "authorization: Bearer ${share_case_b_code}" | jq -r .id)"


# ccd-elasticsearch as part of the RWA-645
curl -X POST \
  --data '{
    "request": {
        "method": "POST",
        "url": "/searchCases?ctid=Asylum",
        "headers": {
              "Content-Type": {
                "equalTo": "application/json"
              },
              "Authorization": {
                "contains": "Bearer"
              },
              "ServiceAuthorization": {
                "contains": "Bearer"
              }
        },
        "bodyPatterns" : [ {
                "equalToJson" : "{\r\n    \"query\": {\r\n        \"bool\": {\r\n            \"must\": [\r\n                {\r\n                    \"match\": {\r\n                        \"state\": \"caseUnderReview\"\r\n                    }\r\n                }\r\n            ],\r\n            \"filter\": [\r\n                {\r\n                    \"range\": {\r\n                        \"last_state_modified_date\": {\r\n                            \"lte\": \"2021-07-12\",\r\n                            \"gte\": \"2021-05-13\"\r\n                        }\r\n                    }\r\n                }\r\n            ]\r\n        }\r\n    }\r\n}"
        } ]
    },
    "response": {
        "status": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "jsonBody": {
                    "total": 5,
                    "cases": [
                      {
                        "id": 1619996688685650,
                        "jurisdiction": "IA",
                        "state": "caseUnderReview"
                      }
                    ],
                    "case_types_results": [
                      {
                        "total": 5,
                        "case_type_id": "Asylum"
                      }
                    ]
                  }
    }
}' \
  ${WIREMOCK_URL}/__admin/mappings/new


curl -X POST \
--data '{
          "request": {
            "method": "GET",
            "urlPath": "/refdata/external/v1/organisations"
          },
          "response": {
            "status": 200,
            "headers": {
              "Content-Type": "application/json"
            },
            "jsonBody":  {
              "contactInformation": [
                {
                  "addressLine1": "45 Lunar House",
                  "addressLine2": "Spa Road",
                  "addressLine3": "Woolworth",
                  "county": "London",
                  "townCity": "London",
                  "country": "UK",
                  "postCode": "SE1 3HP"
                }
              ],
              "organisationIdentifier": "D1HRWLA",
              "name": "Fake Org Ltd"
          }
        }
      }' \
${WIREMOCK_URL}/__admin/mappings/new

curl -X POST \
  --data '{
          "request": {
            "method": "GET",
            "url": "/refdata/external/v1/organisations/users"
          },
          "response": {
            "status": 200,
            "headers": {
              "Content-Type": "application/json"
            },
            "jsonBody": {
              "users": [
                {
                  "userIdentifier": "'"${share_case_org_id}"'",
                  "firstName": "Org Creator",
                  "lastName": "Legal Rep",
                  "email": "'"${TEST_LAW_FIRM_SHARE_CASE_ORG_USERNAME}"'",
                  "roles": [
                    "caseworker-publiclaw-solicitor",
                    "pui-case-manager",
                    "caseworker",
                    "caseworker-divorce-solicitor",
                    "caseworker-ia",
                    "pui-user-manager",
                    "caseworker-publiclaw",
                    "caseworker-ia-legalrep-solicitor",
                    "caseworker-probate-solicitor",
                    "pui-organisation-manager",
                    "caseworker-divorce",
                    "caseworker-divorce-financialremedy",
                    "prd-admin",
                    "pui-finance-manager",
                    "caseworker-probate",
                    "caseworker-divorce-financialremedy-solicitor"
                  ],
                  "idamStatus": "ACTIVE",
                  "idamStatusCode": "200",
                  "idamMessage": "11 OK"
                },
                {
                  "userIdentifier": "'"${share_case_a_id}"'",
                  "firstName": "Share A",
                  "lastName": "Legal Rep",
                  "email": "'"${TEST_LAW_FIRM_SHARE_CASE_A_USERNAME}"'",
                  "roles": [
                    "caseworker-publiclaw-solicitor",
                    "pui-case-manager",
                    "caseworker",
                    "caseworker-divorce",
                    "caseworker-divorce-financialremedy",
                    "caseworker-divorce-solicitor",
                    "caseworker-probate",
                    "caseworker-ia",
                    "caseworker-divorce-financialremedy-solicitor",
                    "caseworker-publiclaw",
                    "caseworker-ia-legalrep-solicitor",
                    "caseworker-probate-solicitor"
                  ],
                  "idamStatus": "ACTIVE",
                  "idamStatusCode": "200",
                  "idamMessage": "11 OK"
                },
                {
                  "userIdentifier": "'"${share_case_b_id}"'",
                  "firstName": "Share B",
                  "lastName": "Legal Rep",
                  "email": "'"${TEST_LAW_FIRM_SHARE_CASE_B_USERNAME}"'",
                  "roles": [
                    "caseworker-publiclaw-solicitor",
                    "pui-case-manager",
                    "caseworker",
                    "caseworker-divorce",
                    "caseworker-divorce-financialremedy",
                    "caseworker-divorce-solicitor",
                    "caseworker-probate",
                    "caseworker-ia",
                    "caseworker-divorce-financialremedy-solicitor",
                    "caseworker-publiclaw",
                    "caseworker-ia-legalrep-solicitor",
                    "caseworker-probate-solicitor"
                  ],
                  "idamStatus": "ACTIVE",
                  "idamStatusCode": "200",
                  "idamMessage": "11 OK"
                }
              ]
            }
          }
        }' \
  ${WIREMOCK_URL}/__admin/mappings/new

curl -X POST \
  --data '{
    "request": {
        "method": "GET",
        "url": "/health"
    },
    "response": {
        "status": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "jsonBody": {
            "status": "UP",
            "components": {
                "db": {
                    "status": "UP",
                    "details": {
                        "database": "PostgreSQL",
                        "result": 1,
                        "validationQuery": "SELECT 1"
                    }
                },
                "diskSpace": {
                    "status": "UP",
                    "details": {
                        "total": 33685291008,
                        "free": 9184305152,
                        "threshold": 10485760
                    }
                },
                "hystrix": {
                    "status": "UP"
                },
                "liveness": {
                    "status": "UP"
                },
                "ping": {
                    "status": "UP"
                },
                "refreshScope": {
                    "status": "UP"
                },
                "serviceAuth": {
                    "status": "UP"
                }
            }
        }
    }
}' \
  ${WIREMOCK_URL}/__admin/mappings/new

# fee-register response for fee with hearinng
curl -X POST \
  --data '{
    "request": {
        "method": "GET",
        "url": "/fees-register/fees/lookup?channel=default&event=issue&jurisdiction1=tribunal&jurisdiction2=immigration%20and%20asylum%20chamber&keyword=ABC&service=other"
    },
    "response": {
        "status": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "jsonBody": {
            "code": "FEE0238",
            "description": "Appeal determined with a hearing",
            "version": 2,
            "fee_amount": "140.00"
        }
    }
}' \
  ${WIREMOCK_URL}/__admin/mappings/new

# fee-register response for fee without hearing
curl -X POST \
  --data '{
    "request": {
        "method": "GET",
        "url": "/fees-register/fees/lookup?channel=default&event=issue&jurisdiction1=tribunal&jurisdiction2=immigration%20and%20asylum%20chamber&keyword=DEF&service=other"
    },
    "response": {
        "status": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "jsonBody": {
            "code": "FEE0456",
            "description": "Appeal determined with a hearing",
            "version": 2,
            "fee_amount": "80.00"
        }
    }
}' \
  ${WIREMOCK_URL}/__admin/mappings/new

curl -X POST \
  --data '{
          "request": {
            "method": "POST",
            "url": "/credit-account-payments",
            "headers": {
              "Content-Type": {
                "equalTo": "application/json"
              }
            }
          },
          "response": {
            "status": 201,
            "headers": {
              "Content-Type": "application/json"
            },
            "jsonBody": {
                "reference": "RC-1590-6786-1063-9996",
                "date_created": "2020-05-28T15:10:10.694+0000",
                "status": "Success",
                "payment_group_reference": "2020-1590678609071",
                "status_histories": [
                  {
                    "status": "success",
                    "date_created": "2020-05-28T15:10:10.700+0000",
                    "date_updated": "2020-05-28T15:10:10.700+0000"
                  }
                ]
            }
          }
        }' \
  ${WIREMOCK_URL}/__admin/mappings/new

#PBA accounts
curl -X POST \
  --data '{
          "request": {
            "method": "GET",
            "urlPath": "/refdata/external/v1/organisations/pbas"
          },
          "response": {
            "status": 200,
            "headers": {
              "Content-Type": "application/json"
            },
            "jsonBody": {
              "organisationEntityResponse" : {
                "organisationIdentifier": "0UFUG4Z",
                "name": "ia-legal-rep-org",
                "status": "ACTIVE",
                "sraId": null,
                "sraRegulated": false,
                "companyNumber": null,
                "companyUrl": null,
                "superUser": {
                  "firstName": "legalrep",
                  "lastName": "orgcreator",
                  "email": "'"${TEST_LAW_FIRM_SHARE_CASE_ORG_USERNAME}"'"
                },
                "paymentAccount": [
                  "PBA1234567",
                  "PBA7654321",
                  "PBA1232123"
                ],
                "contactInformation": null
              }
            }
          }
        }' \
  ${WIREMOCK_URL}/__admin/mappings/new

## rd-casewoker-ref-api
curl -X POST \
  --data '{
          "request": {
            "method": "POST",
            "urlPath": "/refdata/case-worker/users/fetchUsersById",
            "headers": {
              "Content-Type": {
                "equalTo": "application/json"
              },
              "Authorization": {
                "contains": "Bearer"
              },
              "ServiceAuthorization": {
                "contains": "Bearer"
              }
            },
            "bodyPatterns" : [{
              "contains" : "userIds"
            }]
          },
          "response": {
            "status": 200,
            "headers": {
              "Content-Type": "application/json"
            },
            "jsonBody": [
                {
                    "id": "e7013580-ac60-40fd-9cb5-8cd968db9201",
                    "first_name": "Case",
                    "last_name": "Officer",
                    "region_id": 1,
                    "user_type": "CTSC",
                    "suspended": "false",
                    "created_time": "2021-01-28T13:24:22.132928",
                    "last_updated_time": "2021-01-28T13:24:22.132939",
                    "email_id": "ia.caseofficer.3.ccd@protonmail.com",
                    "region": null,
                    "base_location": [
                        {
                            "created_time": "2021-01-28T13:24:22.135158",
                            "last_updated_time": "2021-01-28T13:24:22.135181",
                            "location_id": 2,
                            "location": "test location",
                            "is_primary": true
                        }
                    ],
                    "user_type_id": 1,
                    "role": [
                        {
                            "role_id": "2",
                            "created_time": "2021-01-28T13:24:22.137558",
                            "last_updated_time": "2021-01-28T13:24:22.137569",
                            "role": "Tribunal Caseworker",
                            "is_primary": true
                        }
                    ],
                    "work_area": [
                        {
                            "service_code": "BAA1",
                            "area_of_work": "Non-Money Claims",
                            "created_time": "2021-01-28T13:24:22.14034",
                            "last_updated_time": "2021-01-28T13:24:22.140348"
                        }
                    ]
                }
            ]
          }
        }' \
  ${WIREMOCK_URL}/__admin/mappings/new

# make responses persistent in Docker volume
curl -X POST ${WIREMOCK_URL}/__admin/mappings/save
