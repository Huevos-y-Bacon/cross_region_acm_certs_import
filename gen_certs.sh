#!/usr/bin/env bash

# Source: https://arminreiter.com/2022/01/create-your-own-certificate-authority-ca-using-openssl/

# 1. Create a private key for our own CA
# 2. Create a certificate for the CA
# 3. [SKIPPED] Add this certificate to the “Trusted Root Certificate Authorities” store of the clients so that it becomes trusted
# 4. Create a certificate for our webserver
# 5. Sign this certificate with our CA (which is trusted and therefore, also this new certificate becomes trusted)
# 6. [SKIPPED] Deploy the certificate


CANAME=ca
CERT=cert
CERT_CN="*.acme.org"
CERT_ORG=ACME

path_prefix="tls"  # ! make sure this matches path_prefix in tf scripts


# 1. Create a private key for the CA
create_ca_key(){
  # optional
  mkdir -p ${path_prefix}; cd ${path_prefix} || exit
  # generate aes encrypted private key
  openssl genrsa \
    -aes256 \
    -out ${CANAME}.key 4096 || exit
}

# 2. Create Certificate of the CA
create_ca_crt(){
  # create certificate, 1826 days = 5 years
  openssl req \
    -x509 \
    -new \
    -nodes \
    -key ${CANAME}.key \
    -sha256 \
    -days 1826 \
    -out ${CANAME}.crt \
    -subj '/CN=Dummy CA/C=GB/ST=London/L=London/O='"${CERT_ORG}" || exit
}

# 3. [SKIPPED] Add the CA certificate to the trusted root certificates

# 4. Create a certificate for the webserver
create_server_crt(){
  openssl req \
    -new \
    -nodes \
    -out ${CERT}.csr \
    -newkey rsa:4096 \
    -keyout ${CERT}.key \
    -subj '/CN='"${CERT_CN}"'/C=GB/ST=London/L=London/O='"${CERT_ORG}" || exit
}
# 5. Sign the certificate
sign_server_cert(){
  openssl x509 \
    -req \
    -in ${CERT}.csr \
    -CA ${CANAME}.crt \
    -CAkey ${CANAME}.key \
    -CAcreateserial \
    -out ${CERT}.crt \
    -days 730 \
    -sha256 || exit
}

#  6. [SKIPPED] Deploy the certificate

create_ca_key && \
create_ca_crt && \
create_server_crt && \
sign_server_cert

set -x
TARGET="../certs_bucket/${path_prefix}"
mkdir -p "${TARGET}"
cp ${CERT}.crt ${CERT}.key "${TARGET}/"
cp ${CANAME}.crt "${TARGET}/ca.crt"
set +x

# CLEANUP:
# tf destroy cross_region_acm
# tf destroy certs_bucket:
# bash delete tls folders:      find . -type d -name tls -exec rm -rf {} \;
# bash remove state and backup: find . -type f -iname "terraform.tfstate*" -delete
# bash remove .terraform*:      find . -name ".terraform*" -exec rm -rf {} \;
