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

confirm "This will create terraform resources!"

echo "creating CA and certs ..."
bash gen_certs.sh || exit
echo "deploying certs_bucket ..."
cd "${CWD}/certs_bucket" || exit
terraform init && terraform apply --auto-approve || exit
echo "deploying cross_region_acm ..."
cd "${CWD}/cross_region_acm" || exit
terraform init && terraform apply --auto-approve || exit
cd "${CWD}"
