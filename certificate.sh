#!/bin/bash

if [ -z $1 ]; then
	echo "Usage: bash certificate.sh <domain>"
	exit
fi

DOMAIN=$1

cat > openssl.cnf << EOF
[ req ]
distinguished_name      = req_distinguished_name
x509_extensions         = v3_ca
prompt					= no
string_mask             = nombstr

[ req_distinguished_name ]
countryName                     = DE
stateOrProvinceName             = Nordrhein-Westfalen
localityName                    = Düsseldorf
0.organizationName              = ACME
organizationalUnitName          = Development
commonName                      = $DOMAIN
emailAddress                    = development@localhost

[ v3_ca ]
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = $DOMAIN
DNS.2 = *.$DOMAIN
EOF

openssl req -newkey rsa:4096 \
            -x509 \
            -sha256 \
            -days 3650 \
            -nodes \
            -out $DOMAIN.crt \
            -keyout $DOMAIN.key \
            -config openssl.cnf

rm openssl.cnf
