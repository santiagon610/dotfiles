#!/usr/bin/env bash
#
# usage: retrieve-cert.sh remote.host.name [port]
#
REMHOST=$1
REMPORT=${2:-443}
CERT_DESTINATION="/opt/Citrix/ICAClient/keystore/cacerts"

if [ -z "${REMHOST}" ]; then
    echo "Please specify an FQDN"
    exit 1
fi

if [ "$(basename "$(pwd)")" != "citrix" ]; then
    echo "Please run this script from within the Citrix directory"
    exit 1
else
    echo "" | \
        openssl s_client -host "${REMHOST}" -port "${REMPORT}" -showcerts | \
        awk '/BEGIN CERT/ {p=1} ; p==1; /END CERT/ {p=0}' > allcerts.pem
fi
