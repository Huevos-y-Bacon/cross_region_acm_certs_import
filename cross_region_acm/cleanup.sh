#!/usr/bin/env bash

mkdir -p tls
touch ./tls/cert.crt
touch ./tls/cert.key
touch ./tls/ca.crt

terraform destroy $*
