#!/usr/bin/env bash
# set -x

CWD=$(pwd -P)

confirm(){
  echo $*
  read -p "Are you sure you want to proceed? (y/n) ${NORM}" choice
  case "$choice" in
    y|Y ) ;;
    * ) echo -e "Aborting\n" && exit 1;;
  esac
};

confirm "This will remove certs and destroy all terraform resources!"

echo "desploying cross_region_acm ..."
cd cross_region_acm || exit
mkdir -p tls
touch ./tls/cert.crt
touch ./tls/cert.key
touch ./tls/ca.crt
terraform destroy --auto-approve 2> /dev/null

cd "${CWD}" || exit

echo "desploying certs_bucket ..."
cd certs_bucket || exit
terraform destroy  --auto-approve 2> /dev/null

cd "${CWD}" || exit

echo "deleting **/tls and **/.terrafor* ..."
find . -type d -name "tls" -exec rm -rf {} \; 2> /dev/null
find . -name ".terrafor*" -exec rm -rf {} \; 2> /dev/null
