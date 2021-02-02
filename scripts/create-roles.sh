#!/usr/bin/env bash

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

echo ""
echo "Setting up Roles required for WA only..."
./actions/create-role.sh "caseworker-wa-task-configuration"

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
