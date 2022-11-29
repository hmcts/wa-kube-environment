#!/usr/bin/env bash

# Setup Users
echo ""
echo "Setting up required Users..."
./actions/create-user.sh "ccd-import@fake.hmcts.net" "CCD" "Import" "London01" "ccd-import" "[{\"code\":\"ccd-import\"}]"

echo "Setting up WA test accounts"
./actions/create-user.sh "${TEST_WA_CASEOFFICER_A_USERNAME}" "CaseOfficer" "TestPurposes A" "${TEST_WA_CASEOFFICER_A_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker\"}, { \"code\": \"caseworker-wa\"}, { \"code\": \"caseworker-wa-caseofficer\"}]"
./actions/create-user.sh "${TEST_WA_CASEOFFICER_B_USERNAME}" "CaseOfficer" "TestPurposes B" "${TEST_WA_CASEOFFICER_B_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker\"}, { \"code\": \"caseworker-wa\"}, { \"code\": \"caseworker-wa-caseofficer\"}]"
./actions/create-user.sh "${TEST_WA_LAW_FIRM_USERNAME}" "LegalRep" "TestPurposes" "${TEST_WA_LAW_FIRM_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker\"}, { \"code\": \"caseworker-wa\"}, { \"code\": \"caseworker-wa-system\"}, { \"code\": \"caseworker-wa-legalrep-solicitor\"}, { \"code\": \"payments\"}]"
./actions/organisational-role-assignment.sh "${TEST_WA_LAW_FIRM_USERNAME}" "${TEST_WA_LAW_FIRM_PASSWORD}" "PUBLIC" "case-allocator" '{"jurisdiction":"WA","primaryLocation":"765324"}'
./actions/organisational-role-assignment.sh "${TEST_WA_LAW_FIRM_USERNAME}" "${TEST_WA_LAW_FIRM_PASSWORD}" "PUBLIC" "task-supervisor" '{"jurisdiction":"WA","primaryLocation":"765324"}'
./actions/organisational-role-assignment.sh "${TEST_WA_LAW_FIRM_USERNAME}" "${TEST_WA_LAW_FIRM_PASSWORD}" "PUBLIC" "tribunal-caseworker" '{"jurisdiction":"WA","primaryLocation":"765324"}'

echo "Setting up WA Users and role assignments..."
./actions/create-user.sh "${WA_SYSTEM_USERNAME}" "WASystem" "WaUser" "${WA_SYSTEM_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker\"}, { \"code\": \"caseworker-wa\"}, { \"code\": \"caseworker-wa-task-configuration\"}]"

./actions/create-user.sh "${WA_CASEOFFICER_USERNAME}" "WaCaseOfficer" "case worker" "${WA_CASEOFFICER_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker\"}, { \"code\": \"caseworker-wa\"}, {\"code\": \"caseworker-wa-task-officer\"}]"
./actions/organisational-role-assignment.sh "${WA_CASEOFFICER_USERNAME}" "${WA_CASEOFFICER_USERNAME}" "PUBLIC" "case-allocator" '{"jurisdiction":"WA","primaryLocation":"765324"}'
./actions/organisational-role-assignment.sh "${WA_CASEOFFICER_USERNAME}" "${WA_CASEOFFICER_USERNAME}" "PUBLIC" "task-supervisor" '{"jurisdiction":"WA","primaryLocation":"765324"}'
./actions/organisational-role-assignment.sh "${WA_CASEOFFICER_USERNAME}" "${WA_CASEOFFICER_USERNAME}" "PUBLIC" "tribunal-caseworker" '{"jurisdiction":"WA","primaryLocation":"765324"}'

./actions/create-user.sh "${TEST_WA_CASEOFFICER_PUBLIC_A_USERNAME}" "CaseOfficer" "A-Public" "${TEST_WA_CASEOFFICER_PUBLIC_A_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker\"}, { \"code\": \"caseworker-wa\"}, { \"code\": \"caseworker-wa-caseofficer\"}]"
./actions/organisational-role-assignment.sh "${TEST_WA_CASEOFFICER_PUBLIC_A_USERNAME}" "${TEST_WA_CASEOFFICER_PUBLIC_A_PASSWORD}" "PUBLIC" "case-allocator" '{"jurisdiction":"WA","primaryLocation":"765324"}'
./actions/organisational-role-assignment.sh "${TEST_WA_CASEOFFICER_PUBLIC_A_USERNAME}" "${TEST_WA_CASEOFFICER_PUBLIC_A_PASSWORD}" "PUBLIC" "task-supervisor" '{"jurisdiction":"WA","primaryLocation":"765324"}'
./actions/organisational-role-assignment.sh "${TEST_WA_CASEOFFICER_PUBLIC_A_USERNAME}" "${TEST_WA_CASEOFFICER_PUBLIC_A_PASSWORD}" "PUBLIC" "tribunal-caseworker" '{"jurisdiction":"WA","primaryLocation":"765324"}'

./actions/create-user.sh "${TEST_WA_CASEOFFICER_PUBLIC_B_USERNAME}" "CaseOfficer" "B-Public" "${TEST_WA_CASEOFFICER_PUBLIC_B_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker\"}, { \"code\": \"caseworker-wa\"}, { \"code\": \"caseworker-wa-caseofficer\"}]"
./actions/organisational-role-assignment.sh "${TEST_WA_CASEOFFICER_PUBLIC_B_USERNAME}" "${TEST_WA_CASEOFFICER_PUBLIC_B_PASSWORD}" "PUBLIC" "case-allocator" '{"jurisdiction":"WA","region":"east-england","primaryLocation":"765324"}'
./actions/organisational-role-assignment.sh "${TEST_WA_CASEOFFICER_PUBLIC_B_USERNAME}" "${TEST_WA_CASEOFFICER_PUBLIC_B_PASSWORD}" "PUBLIC" "task-supervisor" '{"jurisdiction":"WA","region":"east-england","primaryLocation":"765324"}'
./actions/organisational-role-assignment.sh "${TEST_WA_CASEOFFICER_PUBLIC_B_USERNAME}" "${TEST_WA_CASEOFFICER_PUBLIC_B_PASSWORD}" "PUBLIC" "tribunal-caseworker" '{"jurisdiction":"WA","region":"east-england","primaryLocation":"765324"}'

./actions/create-user.sh "${TEST_WA_CASEOFFICER_PUBLIC_C_USERNAME}" "CaseOfficer" "C-Public" "${TEST_WA_CASEOFFICER_PUBLIC_C_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker\"}, { \"code\": \"caseworker-wa\"}, { \"code\": \"caseworker-wa-caseofficer\"}]"
./actions/organisational-role-assignment.sh "${TEST_WA_CASEOFFICER_PUBLIC_C_USERNAME}" "${TEST_WA_CASEOFFICER_PUBLIC_C_PASSWORD}" "PUBLIC" "case-allocator" '{"jurisdiction":"WA","primaryLocation":"765324"}'
./actions/organisational-role-assignment.sh "${TEST_WA_CASEOFFICER_PUBLIC_C_USERNAME}" "${TEST_WA_CASEOFFICER_PUBLIC_C_PASSWORD}" "PUBLIC" "task-supervisor" '{"jurisdiction":"WA","primaryLocation":"765324"}'
./actions/organisational-role-assignment.sh "${TEST_WA_CASEOFFICER_PUBLIC_C_USERNAME}" "${TEST_WA_CASEOFFICER_PUBLIC_C_PASSWORD}" "PUBLIC" "tribunal-caseworker" '{"jurisdiction":"WA","primaryLocation":"765324"}'

./actions/create-user.sh "${TEST_WA_CASEOFFICER_PUBLIC_D_USERNAME}" "CaseOfficer" "D-Public" "${TEST_WA_CASEOFFICER_PUBLIC_D_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker\"}, { \"code\": \"caseworker-wa\"}, { \"code\": \"caseworker-wa-caseofficer\"}]"
./actions/organisational-role-assignment.sh "${TEST_WA_CASEOFFICER_PUBLIC_D_USERNAME}" "${TEST_WA_CASEOFFICER_PUBLIC_D_PASSWORD}" "PUBLIC" "case-allocator" '{"jurisdiction":"WA","region":"east-england","primaryLocation":"765324"}'
./actions/organisational-role-assignment.sh "${TEST_WA_CASEOFFICER_PUBLIC_D_USERNAME}" "${TEST_WA_CASEOFFICER_PUBLIC_D_PASSWORD}" "PUBLIC" "task-supervisor" '{"jurisdiction":"WA","region":"east-england","primaryLocation":"765324"}'
./actions/organisational-role-assignment.sh "${TEST_WA_CASEOFFICER_PUBLIC_D_USERNAME}" "${TEST_WA_CASEOFFICER_PUBLIC_D_PASSWORD}" "PUBLIC" "tribunal-caseworker" '{"jurisdiction":"WA","region":"east-england","primaryLocation":"765324"}'
