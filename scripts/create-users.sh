#!/usr/bin/env bash

# Setup Users
echo ""
echo "Setting up ccd import User"
./actions/create-user.sh "ccd-import@fake.hmcts.net" "CCD" "Import" "London01" "ccd-import" "[{\"code\":\"ccd-import\"}]"

echo "Setting up WA System User"
./actions/create-user.sh "${WA_SYSTEM_USERNAME}" "WASystem" "WaUser" "${WA_SYSTEM_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker\"}, { \"code\": \"caseworker-ia\"}, { \"code\": \"caseworker-ia-system\"}, { \"code\": \"caseworker-wa\"}, { \"code\": \"caseworker-wa-task-configuration\"}]"
./actions/create-user.sh "${RAS_SYSTEM_USERNAME}" "RASSystem" "RasUser" "${RAS_SYSTEM_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker-wa\"}, { \"code\": \"caseworker-ras-validation\"}, { \"code\": \"caseworker-ia\"}, { \"code\": \"caseworker\"}]"
#
#echo "Setting up WA Users and role assignments..."
#./actions/create-user.sh "${WA_CASEOFFICER_USERNAME}" "WaCaseOfficer" "case worker" "${WA_CASEOFFICER_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker\"}, { \"code\": \"caseworker-wa\"}, {\"code\": \"caseworker-wa-task-officer\"}]"
#./actions/organisational-role-assignment.sh "${WA_CASEOFFICER_USERNAME}" "${WA_CASEOFFICER_PASSWORD}" "PUBLIC" "case-allocator" '{"jurisdiction":"WA","primaryLocation":"765324"}'
#./actions/organisational-role-assignment.sh "${WA_CASEOFFICER_USERNAME}" "${WA_CASEOFFICER_PASSWORD}" "PUBLIC" "task-supervisor" '{"jurisdiction":"WA","primaryLocation":"765324"}'
#./actions/organisational-role-assignment.sh "${WA_CASEOFFICER_USERNAME}" "${WA_CASEOFFICER_PASSWORD}" "PUBLIC" "tribunal-caseworker" '{"jurisdiction":"WA","primaryLocation":"765324"}'
