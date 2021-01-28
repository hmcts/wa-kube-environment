#!/usr/bin/env bash

# Setup Wiremock responses for Professional Reference Data based on existing Idam users

share_case_org_code="$(sh ./actions/idam-user-token.sh "${TEST_LAW_FIRM_SHARE_CASE_ORG_USERNAME}" "${TEST_LAW_FIRM_SHARE_CASE_ORG_PASSWORD}")"
share_case_org_id="$(curl --silent --show-error -X GET "${IDAM_URL}/details" -H "accept: application/json" -H "authorization: Bearer ${share_case_org_code}" | jq -r .id)"

share_case_a_code="$(sh ./actions/idam-user-token.sh "${TEST_LAW_FIRM_SHARE_CASE_A_USERNAME}" "${TEST_LAW_FIRM_SHARE_CASE_A_PASSWORD}")"
share_case_a_id="$(curl --silent --show-error -X GET "${IDAM_URL}/details" -H "accept: application/json" -H "authorization: Bearer ${share_case_a_code}" | jq -r .id)"

share_case_b_code="$(sh ./actions/idam-user-token.sh "${TEST_LAW_FIRM_SHARE_CASE_B_USERNAME}" "${TEST_LAW_FIRM_SHARE_CASE_B_PASSWORD}")"
share_case_b_id="$(curl --silent --show-error -X GET "${IDAM_URL}/details" -H "accept: application/json" -H "authorization: Bearer ${share_case_b_code}" | jq -r .id)"

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
              "equalToJson" : { "userIds": ["${json-unit.any-string}"]}
            }]
          },
          "response": {
            "status": 200,
            "headers": {
              "Content-Type": "application/json"
            },
            "jsonBody": [{
              "caseWorkerId": "string",
              "caseWorkerLocations": [
                {
                  "caseWorkerId": "string",
                  "caseWorkerLocationId": 0,
                  "createdDate": "2021-01-18T16:35:45.194Z",
                  "lastUpdate": "2021-01-18T16:35:45.194Z",
                  "location": "string",
                  "locationId": 0,
                  "primaryFlag": true
                }
              ],
              "caseWorkerRoles": [
                {
                  "caseWorkerId": "string",
                  "caseWorkerRoleId": 0,
                  "createdDate": "2021-01-18T16:35:45.194Z",
                  "lastUpdate": "2021-01-18T16:35:45.194Z",
                  "primaryFlag": true,
                  "roleId": 0,
                  "roleType": {
                    "caseWorkerIdamRoleAssociations": [
                      {
                        "createdDate": "2021-01-18T16:35:45.194Z",
                        "cwIdamRoleAssociationId": 0,
                        "idamRole": "string",
                        "lastUpdate": "2021-01-18T16:35:45.194Z",
                        "roleId": 0,
                        "serviceCode": "string"
                      }
                    ],
                    "caseWorkerRoles": [
                      null
                    ],
                    "createdDate": "2021-01-18T16:35:45.194Z",
                    "description": "string",
                    "lastUpdate": "2021-01-18T16:35:45.194Z",
                    "roleId": 0
                  }
                }
              ],
              "caseWorkerWorkAreas": [
                {
                  "areaOfWork": "string",
                  "caseWorkerId": "string",
                  "caseWorkerWorkAreaId": 0,
                  "createdDate": "2021-01-18T16:35:45.194Z",
                  "lastUpdate": "2021-01-18T16:35:45.194Z",
                  "serviceCode": "string"
                }
              ],
              "createdDate": "2021-01-18T16:35:45.194Z",
              "emailId": "string",
              "firstName": "firstName",
              "lastName": "lastName",
              "lastUpdate": "2021-01-18T16:35:45.194Z",
              "region": "string",
              "regionId": 0,
              "suspended": true,
              "userType": {
                "caseWorkerProfiles": [
                  null
                ],
                "createdDate": "2021-01-18T16:35:45.194Z",
                "description": "string",
                "lastUpdate": "2021-01-18T16:35:45.194Z",
                "userTypeId": 0
              },
              "userTypeId": 0
            }]
          }
        }' \
  ${WIREMOCK_URL}/__admin/mappings/new

# make responses persistent in Docker volume
curl -X POST ${WIREMOCK_URL}/__admin/mappings/save
