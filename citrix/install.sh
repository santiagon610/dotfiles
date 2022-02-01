#!/usr/bin/env bash

set -ex

CITRIX_SERVER_URL="cvw.corp.cigna.com:443"

openssl s_client -showcerts -connect "${CITRIX_SERVER_URL}" </dev/null 2>/dev/null|openssl x509 -outform PEM >"${PWD}/certchain.pem"
