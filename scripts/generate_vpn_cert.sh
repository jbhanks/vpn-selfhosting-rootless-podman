#!/usr/bin/env bash
set -euo pipefail

DOMAIN="$1"
BASE_DIR="$2"

OUTDIR="${BASE_DIR}/certs/${DOMAIN}"
CA_DIR="${BASE_DIR}/ca"

mkdir -p "${OUTDIR}"
umask 077

# Key
if [ ! -f "${OUTDIR}/${DOMAIN}.key" ]; then
    openssl genrsa -out "${OUTDIR}/${DOMAIN}.key" 2048
fi

# CSR
if [ ! -f "${OUTDIR}/${DOMAIN}.csr" ]; then
    openssl req -new \
        -key "${OUTDIR}/${DOMAIN}.key" \
        -out "${OUTDIR}/${DOMAIN}.csr" \
        -subj "/CN=${DOMAIN}"
fi

# ext file
EXT_FILE="${OUTDIR}/${DOMAIN}.ext"

if [ ! -f "${EXT_FILE}" ]; then
cat > "${EXT_FILE}" <<EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage=digitalSignature,keyEncipherment
extendedKeyUsage=serverAuth
subjectAltName=@alt_names

[alt_names]
DNS.1=${DOMAIN}
EOF
fi

# Signed cert
if [ ! -f "${OUTDIR}/${DOMAIN}.crt" ]; then
    openssl x509 -req \
        -in "${OUTDIR}/${DOMAIN}.csr" \
        -CA "${CA_DIR}/ca.crt" \
        -CAkey "${CA_DIR}/ca.key" \
        -CAcreateserial \
        -out "${OUTDIR}/${DOMAIN}.crt" \
        -days 825 -sha256 \
        -extfile "${EXT_FILE}"
fi
