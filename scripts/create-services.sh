#!/usr/bin/env bash

echo "Setting up Services..."
./actions/create-service.sh "ccd_gateway" "false" "ccd_gateway" "OOOOOOOOOOOOOOOO" "[\"${CCD_CASE_MANAGEMENT_WEB_URL}/oauth2redirect\", \"${XUI_URL}/oauth2/callback\", \"https://localhost:3000/redirectUrl\"]" "[\"caseworker\", \"caseworker-ia\", \"caseworker-ia-legalrep-solicitor\", \"pui-case-manager\"]" "CCD Gateway" "CCD scope manage-user create-user openid profile roles authorities"
./actions/create-service.sh "${WA_IDAM_CLIENT_ID}" "false" "${WA_IDAM_CLIENT_ID}" "${WA_IDAM_CLIENT_SECRET}" "[\"${CCD_CASE_MANAGEMENT_WEB_URL}/oauth2redirect\", \"${XUI_URL}/oauth2/callback\", \"https://localhost:3000/redirectUrl\"]" "[\"caseworker\", \"caseworker-ia\", \"caseworker-ia-legalrep-solicitor\", \"pui-case-manager\"]" "Work Allocation" "CCD scope manage-user create-user openid profile roles authorities"

