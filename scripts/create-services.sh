#!/usr/bin/env bash

echo "Setting up Services..."
./actions/create-service.sh "ccd_gateway" "false" "ccd_gateway" "OOOOOOOOOOOOOOOO" "[\"${CCD_CASE_MANAGEMENT_WEB_URL}/oauth2redirect\", \"${XUI_URL}/oauth2/callback\", \"https://localhost:3000/redirectUrl\"]" "[\"caseworker\", \"caseworker-ia\", \"caseworker-ia-legalrep-solicitor\", \"pui-case-manager\"]" "CCD Gateway" "CCD scope manage-user create-user openid profile roles authorities"
./actions/create-service.sh "${WA_IDAM_CLIENT_ID}" "false" "${WA_IDAM_CLIENT_ID}" "${WA_IDAM_CLIENT_SECRET}" "[\"${CCD_CASE_MANAGEMENT_WEB_URL}/oauth2redirect\", \"${XUI_URL}/oauth2/callback\", \"https://localhost:3000/redirectUrl\"]" "[\"caseworker\", \"caseworker-ia\", \"caseworker-ia-legalrep-solicitor\", \"pui-case-manager\"]" "Work Allocation" "CCD scope manage-user create-user openid profile roles authorities"

# Setup Roles
echo ""
echo "Setting up Roles..."
./actions/create-role.sh "ccd-import"
./actions/create-role.sh "citizen"
./actions/create-role.sh "citizens"
./actions/create-role.sh "caseworker"
./actions/create-role.sh "caseworker-ia"
./actions/create-role.sh "caseworker-ia-caseofficer"
./actions/create-role.sh "caseworker-ia-judiciary"
./actions/create-role.sh "caseworker-ia-legalrep-solicitor"
./actions/create-role.sh "caseworker-ia-system"
./actions/create-role.sh "caseworker-ia-admofficer"
./actions/create-role.sh "caseworker-ia-homeofficeapc"
./actions/create-role.sh "caseworker-ia-homeofficelart"
./actions/create-role.sh "caseworker-ia-homeofficepou"
./actions/create-role.sh "caseworker-ia-respondentofficer"
./actions/create-role.sh "caseworker-ia-iacjudge"
./actions/create-role.sh "payments"

# Roles required for XUI
echo ""
echo "Setting up Roles required for XUI..."
./actions/create-role.sh "pui-case-manager"
./actions/create-role.sh "pui-user-manager"
./actions/create-role.sh "pui-organisation-manager"
./actions/create-role.sh "pui-finance-manager"

./actions/create-role.sh "caseworker-divorce"
./actions/create-role.sh "caseworker-divorce-solicitor"
./actions/create-role.sh "caseworker-divorce-financialremedy"
./actions/create-role.sh "caseworker-divorce-financialremedy-solicitor"

./actions/create-role.sh "caseworker-publiclaw"
./actions/create-role.sh "caseworker-publiclaw-solicitor"
./actions/create-role.sh "caseworker-probate"
./actions/create-role.sh "caseworker-probate-solicitor"
./actions/create-role.sh "caseworker-sscs"
./actions/create-role.sh "caseworker-sscs-dwpresponsewriter"

# Setup Users
echo ""
echo "Setting up required Users..."
./actions/create-user.sh "ccd-import@fake.hmcts.net" "CCD" "Import" "London01" "ccd-import" "[{ \"code\": \"ccd-import\"}]"
./actions/create-user.sh "${IA_SYSTEM_USERNAME}" "System" "user" "${IA_SYSTEM_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker-ia\"}, { \"code\": \"caseworker-ia-system\"}]"

echo "Setting up WA Users and role assignments..."

./actions/create-user.sh "${TEST_WA_CASEOFFICER_PUBLIC_A_USERNAME}" "CaseOfficer" "A-Public" "${TEST_WA_CASEOFFICER_PUBLIC_A_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker-ia\"}, { \"code\": \"caseworker-ia-system\"}]"
./actions/organisational-role-assignment.sh "${TEST_WA_CASEOFFICER_PUBLIC_A_USERNAME}" "${TEST_WA_CASEOFFICER_PUBLIC_A_PASSWORD}" "PUBLIC" "tribunal-caseworker" "[{ \"jurisdiction\": \"IA\"}]"

./actions/create-user.sh "${TEST_WA_CASEOFFICER_PUBLIC_B_USERNAME}" "CaseOfficer" "B-Public" "${TEST_WA_CASEOFFICER_PUBLIC_B_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker-ia\"}, { \"code\": \"caseworker-ia-system\"}]"
./actions/organisational-role-assignment.sh "${TEST_WA_CASEOFFICER_PUBLIC_B_USERNAME}" "${TEST_WA_CASEOFFICER_PUBLIC_B_PASSWORD}" "PUBLIC" "tribunal-caseworker" "[{ \"jurisdiction\": \"IA\"}, { \"region\": \"east-england\"} ]"

./actions/create-user.sh "${TEST_WA_CASEOFFICER_PUBLIC_C_USERNAME}" "CaseOfficer" "C-Public" "${TEST_WA_CASEOFFICER_PUBLIC_C_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker-ia\"}, { \"code\": \"caseworker-ia-system\"}]"
./actions/organisational-role-assignment.sh "${TEST_WA_CASEOFFICER_PUBLIC_C_USERNAME}" "${TEST_WA_CASEOFFICER_PUBLIC_C_PASSWORD}" "PUBLIC" "tribunal-caseworker" "[{ \"jurisdiction\": \"IA\"}, { \"primaryLocation\": \"765324\"} ]"

./actions/create-user.sh "${TEST_WA_CASEOFFICER_PUBLIC_D_USERNAME}" "CaseOfficer" "D-Public" "${TEST_WA_CASEOFFICER_PUBLIC_D_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker-ia\"}, { \"code\": \"caseworker-ia-system\"}]"
./actions/organisational-role-assignment.sh "${TEST_WA_CASEOFFICER_PUBLIC_D_USERNAME}" "${TEST_WA_CASEOFFICER_PUBLIC_D_PASSWORD}" "PUBLIC" "tribunal-caseworker" "[{ \"jurisdiction\": \"IA\"}, { \"region\": \"east-england\"}, { \"primaryLocation\": \"765324\"} ]"

./actions/create-user.sh "${TEST_WA_CASEOFFICER_RESTRICTED_A_USERNAME}" "CaseOfficer" "A-Restricted" "${TEST_WA_CASEOFFICER_RESTRICTED_A_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker-ia\"}, { \"code\": \"caseworker-ia-system\"}]"
./actions/organisational-role-assignment.sh "${TEST_WA_CASEOFFICER_RESTRICTED_A_USERNAME}" "${TEST_WA_CASEOFFICER_RESTRICTED_A_PASSWORD}" "RESTRICTED" "tribunal-caseworker" "[{ \"jurisdiction\": \"IA\"}]"

./actions/create-user.sh "${TEST_WA_CASEOFFICER_RESTRICTED_B_USERNAME}" "CaseOfficer" "B-Restricted" "${TEST_WA_CASEOFFICER_RESTRICTED_B_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker-ia\"}, { \"code\": \"caseworker-ia-system\"}]"
./actions/organisational-role-assignment.sh "${TEST_WA_CASEOFFICER_RESTRICTED_B_USERNAME}" "${TEST_WA_CASEOFFICER_RESTRICTED_B_PASSWORD}" "RESTRICTED" "tribunal-caseworker" "[{ \"jurisdiction\": \"IA\"}, { \"region\": \"east-england\"} ]"

./actions/create-user.sh "${TEST_WA_CASEOFFICER_RESTRICTED_C_USERNAME}" "CaseOfficer" "C-Restricted" "${TEST_WA_CASEOFFICER_RESTRICTED_C_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker-ia\"}, { \"code\": \"caseworker-ia-system\"}]"
./actions/organisational-role-assignment.sh "${TEST_WA_CASEOFFICER_RESTRICTED_C_USERNAME}" "${TEST_WA_CASEOFFICER_RESTRICTED_C_PASSWORD}" "RESTRICTED" "tribunal-caseworker" "[{ \"jurisdiction\": \"IA\"}, { \"primaryLocation\": \"765324\"} ]"

./actions/create-user.sh "${TEST_WA_CASEOFFICER_RESTRICTED_D_USERNAME}" "CaseOfficer" "D-Restricted" "${TEST_WA_CASEOFFICER_RESTRICTED_D_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker-ia\"}, { \"code\": \"caseworker-ia-system\"}]"
./actions/organisational-role-assignment.sh "${TEST_WA_CASEOFFICER_RESTRICTED_D_USERNAME}" "${TEST_WA_CASEOFFICER_RESTRICTED_D_PASSWORD}" "RESTRICTED" "tribunal-caseworker" "[{ \"jurisdiction\": \"IA\"}, { \"region\": \"east-england\"}, { \"primaryLocation\": \"765324\"} ]"

echo "Setting up IA Users..."
./actions/create-user.sh "${TEST_CASEOFFICER_USERNAME}" "Case" "Officer" "${TEST_CASEOFFICER_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker-ia\"}, { \"code\": \"caseworker-ia-caseofficer\"}, { \"code\": \"payments\"}]"
./actions/create-user.sh "${TEST_JUDICIARY_USERNAME}" "Tribunal" "Judge" "${TEST_JUDICIARY_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker-ia\"}, { \"code\": \"caseworker-ia-judiciary\"}]"
./actions/create-user.sh "${TEST_LAW_FIRM_A_USERNAME}" "A" "Legal Rep" "${TEST_LAW_FIRM_A_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker-ia\"}, { \"code\": \"caseworker-ia-legalrep-solicitor\"}, { \"code\": \"payments\"}]"
./actions/create-user.sh "${TEST_LAW_FIRM_B_USERNAME}" "B" "Legal Rep" "${TEST_LAW_FIRM_B_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker-ia\"}, { \"code\": \"caseworker-ia-legalrep-solicitor\"}, { \"code\": \"payments\"}]"
./actions/create-user.sh "${TEST_ADMINOFFICER_USERNAME}" "Admin" "Officer" "${TEST_ADMINOFFICER_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker-ia\"}, { \"code\": \"caseworker-ia-admofficer\"}, { \"code\": \"payments\"}]"
./actions/create-user.sh "${TEST_HOMEOFFICE_APC_USERNAME}" "Home Office" "APC" "${TEST_HOMEOFFICE_APC_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker-ia\"}, { \"code\": \"caseworker-ia-homeofficeapc\"}]"
./actions/create-user.sh "${TEST_HOMEOFFICE_LART_USERNAME}" "Home Office" "LART" "${TEST_HOMEOFFICE_LART_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker-ia\"}, { \"code\": \"caseworker-ia-homeofficelart\"}]"
./actions/create-user.sh "${TEST_HOMEOFFICE_POU_USERNAME}" "Home Office" "POU" "${TEST_HOMEOFFICE_POU_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker-ia\"}, { \"code\": \"caseworker-ia-homeofficepou\"}]"
./actions/create-user.sh "${TEST_HOMEOFFICE_GENERIC_USERNAME}" "Home Office" "Generic" "${TEST_HOMEOFFICE_GENERIC_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker-ia\"}, { \"code\": \"caseworker-ia-respondentofficer\"}]"
./actions/create-user.sh "${TEST_CITIZEN_USERNAME}" "Citizen" "User" "${TEST_CITIZEN_PASSWORD}" "citizens" "[{ \"code\": \"citizen\"}]"

./actions/create-user.sh "${TEST_LAW_FIRM_SHARE_CASE_ORG_USERNAME}" "Org Creator" "Legal Rep" "${TEST_LAW_FIRM_SHARE_CASE_ORG_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker-ia\"}, { \"code\": \"caseworker-ia-legalrep-solicitor\"}, { \"code\": \"pui-case-manager\"}, { \"code\": \"pui-user-manager\"}, { \"code\": \"pui-finance-manager\"}, { \"code\": \"pui-organisation-manager\"}, { \"code\": \"caseworker-divorce\"}, { \"code\": \"caseworker-divorce-financialremedy\"}, { \"code\": \"caseworker-divorce-financialremedy-solicitor\"}, { \"code\": \"caseworker-divorce-solicitor\"}, { \"code\": \"caseworker-publiclaw-solicitor\"}, { \"code\": \"caseworker-publiclaw\"}, { \"code\": \"caseworker-probate-solicitor\"}, { \"code\": \"caseworker-probate\"}, { \"code\": \"caseworker-sscs\"}, { \"code\": \"caseworker-sscs-dwpresponsewriter\"}, { \"code\": \"payments\"}]"
./actions/create-user.sh "${TEST_LAW_FIRM_SHARE_CASE_A_USERNAME}" "Share A" "Legal Rep" "${TEST_LAW_FIRM_SHARE_CASE_A_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker-ia\"}, { \"code\": \"caseworker-ia-legalrep-solicitor\"}, { \"code\": \"pui-case-manager\"}, { \"code\": \"payments\"}]"
./actions/create-user.sh "${TEST_LAW_FIRM_SHARE_CASE_B_USERNAME}" "Share B" "Legal Rep" "${TEST_LAW_FIRM_SHARE_CASE_B_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker-ia\"}, { \"code\": \"caseworker-ia-legalrep-solicitor\"}, { \"code\": \"pui-case-manager\"}, { \"code\": \"payments\"}]"

./actions/create-user.sh "${TEST_JUDGE_X_USERNAME}" "Judge" "X" "${TEST_JUDGE_X_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker-ia\"}, { \"code\": \"caseworker-ia-iacjudge\"}]"

# Setup role assignments
echo ""
echo "Setting up role assignments"
./actions/organisational-role-assignment.sh "${TEST_CASEOFFICER_USERNAME}" "${TEST_CASEOFFICER_PASSWORD}"

# Refresh cache
echo ""
echo "Refreshing cache..."

curl --silent --show-error -X POST "${IDAM_URL}/testing-support/cache/refresh" -H "accept: */*"

# Setup Profiles in CCD
echo ""
echo "Setting up profiles in CCD..."

USER_TOKEN="$(sh ./actions/idam-user-token.sh)"
SERVICE_TOKEN="$(sh ./actions/idam-service-token.sh)"

./actions/register-role.sh "caseworker-ia-caseofficer" "$USER_TOKEN" "$SERVICE_TOKEN"
./actions/register-role.sh "caseworker-ia-judiciary" "$USER_TOKEN" "$SERVICE_TOKEN"
./actions/register-role.sh "caseworker-ia-legalrep-solicitor" "$USER_TOKEN" "$SERVICE_TOKEN"
./actions/register-role.sh "caseworker-ia-system" "$USER_TOKEN" "$SERVICE_TOKEN"
./actions/register-role.sh "caseworker-ia-admofficer" "$USER_TOKEN" "$SERVICE_TOKEN"
./actions/register-role.sh "caseworker-ia-homeofficeapc" "$USER_TOKEN" "$SERVICE_TOKEN"
./actions/register-role.sh "caseworker-ia-homeofficelart" "$USER_TOKEN" "$SERVICE_TOKEN"
./actions/register-role.sh "caseworker-ia-homeofficepou" "$USER_TOKEN" "$SERVICE_TOKEN"
./actions/register-role.sh "caseworker-ia-respondentofficer" "$USER_TOKEN" "$SERVICE_TOKEN"
./actions/register-role.sh "caseworker-ia-iacjudge" "$USER_TOKEN" "$SERVICE_TOKEN"

./actions/register-role.sh "citizen" "$USER_TOKEN" "$SERVICE_TOKEN"

./actions/register-role.sh "pui-case-manager" "$USER_TOKEN" "$SERVICE_TOKEN"
./actions/register-role.sh "pui-user-manager" "$USER_TOKEN" "$SERVICE_TOKEN"

./actions/register-role.sh "pui-finance-manager" "$USER_TOKEN" "$SERVICE_TOKEN"
./actions/register-role.sh "pui-organisation-manager" "$USER_TOKEN" "$SERVICE_TOKEN"

./actions/register-role.sh "caseworker-divorce" "$USER_TOKEN" "$SERVICE_TOKEN"
./actions/register-role.sh "caseworker-divorce-financialremedy" "$USER_TOKEN" "$SERVICE_TOKEN"
./actions/register-role.sh "caseworker-divorce-financialremedy-solicitor" "$USER_TOKEN" "$SERVICE_TOKEN"
./actions/register-role.sh "caseworker-divorce-solicitor" "$USER_TOKEN" "$SERVICE_TOKEN"

./actions/register-role.sh "caseworker-publiclaw-solicitor" "$USER_TOKEN" "$SERVICE_TOKEN"
./actions/register-role.sh "caseworker-publiclaw" "$USER_TOKEN" "$SERVICE_TOKEN"

./actions/register-role.sh "caseworker-probate-solicitor" "$USER_TOKEN" "$SERVICE_TOKEN"
./actions/register-role.sh "caseworker-probate" "$USER_TOKEN" "$SERVICE_TOKEN"

./actions/register-role.sh "caseworker-sscs" "$USER_TOKEN" "$SERVICE_TOKEN"
./actions/register-role.sh "caseworker-sscs-dwpresponsewriter" "$USER_TOKEN" "$SERVICE_TOKEN"

./actions/register-role.sh "payments" "$USER_TOKEN" "$SERVICE_TOKEN"
echo ""
echo "Setting CCD Roles and Users is finished"

echo ""
echo "Setup Wiremock responses for Professional Reference Data based on existing Idam users..."
./actions/wiremock.sh
