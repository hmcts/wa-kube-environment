#!/usr/bin/env bash

# Setup Users
echo ""
echo "Setting up required Users..."

./actions/create-user.sh "ccd-import@fake.hmcts.net" "CCD" "Import" "London01" "ccd-import" "[\"ccd-import\"]"
./actions/create-user.sh "${IA_SYSTEM_USERNAME}" "System" "user" "${IA_SYSTEM_PASSWORD}" "caseworker" "[\"caseworker\", \"caseworker-ia\", \"caseworker-ia-system\"]"
./actions/create-user.sh "${WA_SYSTEM_USERNAME}" "WASystem" "WaUser" "${WA_SYSTEM_PASSWORD}" "caseworker" "[\"caseworker\", \"caseworker-ia\", \"caseworker-ia-system\", \"caseworker-wa-task-configuration\"]"


echo "Setting up WA test accounts"
./actions/create-user.sh "${TEST_WA_CASEOFFICER_A_USERNAME}" "CaseOfficer" "TestPurposes A" "${TEST_WA_CASEOFFICER_A_PASSWORD}" "caseworker" "[\"caseworker\", \"caseworker-ia\", \"caseworker-ia-caseofficer\"]"
./actions/create-user.sh "${TEST_WA_CASEOFFICER_B_USERNAME}" "CaseOfficer" "TestPurposes B" "${TEST_WA_CASEOFFICER_B_PASSWORD}" "caseworker" "[\"caseworker\", \"caseworker-ia\", \"caseworker-ia-caseofficer\"]"
./actions/create-user.sh "${TEST_WA_LAW_FIRM_USERNAME}" "LegalRep" "TestPurposes" "${TEST_WA_LAW_FIRM_PASSWORD}" "caseworker" "[\"caseworker\", \"caseworker-ia\", \"caseworker-ia-system\", \"caseworker-ia-legalrep-solicitor\", \"payments\"]"

echo "Setting up WA Users and role assignments..."

./actions/create-user.sh "${TEST_WA_CASEOFFICER_PUBLIC_A_USERNAME}" "CaseOfficer" "A-Public" "${TEST_WA_CASEOFFICER_PUBLIC_A_PASSWORD}" "caseworker" "[\"caseworker\", \"caseworker-ia\", \"caseworker-ia-caseofficer\"]"
./actions/organisational-role-assignment.sh "${TEST_WA_CASEOFFICER_PUBLIC_A_USERNAME}" "${TEST_WA_CASEOFFICER_PUBLIC_A_PASSWORD}" "PUBLIC" "tribunal-caseworker" '{"jurisdiction":"IA","primaryLocation":"765324"}'

./actions/create-user.sh "${TEST_WA_CASEOFFICER_PUBLIC_B_USERNAME}" "CaseOfficer" "B-Public" "${TEST_WA_CASEOFFICER_PUBLIC_B_PASSWORD}" "caseworker" "[\"caseworker\", \"caseworker-ia\", \"caseworker-ia-caseofficer\"]"
./actions/organisational-role-assignment.sh "${TEST_WA_CASEOFFICER_PUBLIC_B_USERNAME}" "${TEST_WA_CASEOFFICER_PUBLIC_B_PASSWORD}" "PUBLIC" "tribunal-caseworker" '{"jurisdiction":"IA","region":"east-england","primaryLocation":"765324"}'

./actions/create-user.sh "${TEST_WA_CASEOFFICER_PUBLIC_C_USERNAME}" "CaseOfficer" "C-Public" "${TEST_WA_CASEOFFICER_PUBLIC_C_PASSWORD}" "caseworker" "[\"caseworker\", \"caseworker-ia\", \"caseworker-ia-caseofficer\"]"
./actions/organisational-role-assignment.sh "${TEST_WA_CASEOFFICER_PUBLIC_C_USERNAME}" "${TEST_WA_CASEOFFICER_PUBLIC_C_PASSWORD}" "PUBLIC" "tribunal-caseworker" '{"jurisdiction":"IA","primaryLocation":"765324"}'

./actions/create-user.sh "${TEST_WA_CASEOFFICER_PUBLIC_D_USERNAME}" "CaseOfficer" "D-Public" "${TEST_WA_CASEOFFICER_PUBLIC_D_PASSWORD}" "caseworker" "[\"caseworker\", \"caseworker-ia\", \"caseworker-ia-caseofficer\"]"
./actions/organisational-role-assignment.sh "${TEST_WA_CASEOFFICER_PUBLIC_D_USERNAME}" "${TEST_WA_CASEOFFICER_PUBLIC_D_PASSWORD}" "PUBLIC" "tribunal-caseworker" '{"jurisdiction":"IA","region":"east-england","primaryLocation":"765324"}'

echo "Setting up IA Users..."
./actions/create-user.sh "${TEST_CASEOFFICER_USERNAME}" "Case" "Officer" "${TEST_CASEOFFICER_PASSWORD}" "caseworker" "[\"caseworker\", \"caseworker-ia\", \"caseworker-ia-caseofficer\", \"payments\"]"
./actions/organisational-role-assignment.sh "${TEST_CASEOFFICER_USERNAME}" "${TEST_CASEOFFICER_PASSWORD}" "PUBLIC" "tribunal-caseworker" '{"jurisdiction":"IA","primaryLocation":"765324"}'

./actions/create-user.sh "${TEST_JUDICIARY_USERNAME}" "Tribunal" "Judge" "${TEST_JUDICIARY_PASSWORD}" "caseworker" "[\"caseworker\", \"caseworker-ia\", \"caseworker-ia-judiciary\"]"
./actions/create-user.sh "${TEST_LAW_FIRM_A_USERNAME}" "A" "Legal Rep" "${TEST_LAW_FIRM_A_PASSWORD}" "caseworker" "[\"caseworker\", \"caseworker-ia\", \"caseworker-ia-system\", \"caseworker-ia-legalrep-solicitor\", \"payments\"]"
./actions/create-user.sh "${TEST_LAW_FIRM_B_USERNAME}" "B" "Legal Rep" "${TEST_LAW_FIRM_B_PASSWORD}" "caseworker" "[\"caseworker\", \"caseworker-ia\", \"caseworker-ia-legalrep-solicitor\", \"payments\"]"
./actions/create-user.sh "${TEST_ADMINOFFICER_USERNAME}" "Admin" "Officer" "${TEST_ADMINOFFICER_PASSWORD}" "caseworker" "[\"caseworker\", \"caseworker-ia\", \"caseworker-ia-admofficer\", \"payments\"]"
./actions/create-user.sh "${TEST_HOMEOFFICE_APC_USERNAME}" "Home Office" "APC" "${TEST_HOMEOFFICE_APC_PASSWORD}" "caseworker" "[\"caseworker\", \"caseworker-ia\", \"caseworker-ia-homeofficeapc\"]"
./actions/create-user.sh "${TEST_HOMEOFFICE_LART_USERNAME}" "Home Office" "LART" "${TEST_HOMEOFFICE_LART_PASSWORD}" "caseworker" "[\"caseworker\", \"caseworker-ia\", \"caseworker-ia-homeofficelart\"]"
./actions/create-user.sh "${TEST_HOMEOFFICE_POU_USERNAME}" "Home Office" "POU" "${TEST_HOMEOFFICE_POU_PASSWORD}" "caseworker" "[\"caseworker\", \"caseworker-ia\", \"caseworker-ia-homeofficepou\"]"
./actions/create-user.sh "${TEST_HOMEOFFICE_GENERIC_USERNAME}" "Home Office" "Generic" "${TEST_HOMEOFFICE_GENERIC_PASSWORD}" "caseworker" "[\"caseworker\", \"caseworker-ia\", \"caseworker-ia-respondentofficer\"]"
./actions/create-user.sh "${TEST_CITIZEN_USERNAME}" "Citizen" "User" "${TEST_CITIZEN_PASSWORD}" "citizens" "[\"citizen\"]"

./actions/create-user.sh "${TEST_LAW_FIRM_SHARE_CASE_ORG_USERNAME}" "Org Creator" "Legal Rep" "${TEST_LAW_FIRM_SHARE_CASE_ORG_PASSWORD}" "caseworker" "[\"caseworker\", \"caseworker-ia\", \"caseworker-ia-legalrep-solicitor\", \"pui-case-manager\", \"pui-user-manager\", \"pui-finance-manager\", \"pui-organisation-manager\", \"caseworker-divorce\", \"caseworker-divorce-financialremedy\", \"caseworker-divorce-financialremedy-solicitor\", \"caseworker-divorce-solicitor\", \"caseworker-publiclaw-solicitor\", \"caseworker-publiclaw\", \"caseworker-probate-solicitor\", \"caseworker-probate\", \"caseworker-sscs\", \"caseworker-sscs-dwpresponsewriter\", \"payments\"]"
./actions/create-user.sh "${TEST_LAW_FIRM_SHARE_CASE_A_USERNAME}" "Share A" "Legal Rep" "${TEST_LAW_FIRM_SHARE_CASE_A_PASSWORD}" "caseworker" "[\"caseworker\", \"caseworker-ia\", \"caseworker-ia-legalrep-solicitor\", \"pui-case-manager\", \"payments\"]"
./actions/create-user.sh "${TEST_LAW_FIRM_SHARE_CASE_B_USERNAME}" "Share B" "Legal Rep" "${TEST_LAW_FIRM_SHARE_CASE_B_PASSWORD}" "caseworker" "[\"caseworker\", \"caseworker-ia\", \"caseworker-ia-legalrep-solicitor\", \"pui-case-manager\", \"payments\"]"

./actions/create-user.sh "${TEST_JUDGE_X_USERNAME}" "Judge" "X" "${TEST_JUDGE_X_PASSWORD}" "caseworker" "[\"caseworker\", \"caseworker-ia\", \"caseworker-ia-iacjudge\"]"
