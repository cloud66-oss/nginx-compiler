#!/usr/bin/env bash
set -e

if [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -z "$3" ]] || [[ -z "$4" ]] || [[ -z "$5" ]]; then
    echo "FATAL: Expected ARGS:"
    echo "1. os-version: 18.04"
    echo "2. nginx-version: ie. 1.18.0"
    echo "3. passenger-version: 6.0.10"
    echo "4. release-version: 1.0.0"
    echo "5. architecture: amd64"
    echo ""
    echo "Usage Examples:"
    echo "./extract_nginx.sh 18.04 1.18.0 6.0.10 1.0.0 amd64"
    exit 22
fi

PASSENGER_ENTERPRISE_LICENSE="passenger_enterprise/passenger-enterprise-license"
PASSENGER_ENTERPRISE_TARBALL="passenger_enterprise/passenger-enterprise-server-${3}.tar.gz"
output="output.passenger/binaries"
passenger_edition="passenger"
if [[ -f "${PASSENGER_ENTERPRISE_LICENSE}" ]] && [[ -f "${PASSENGER_ENTERPRISE_TARBALL}" ]]; then
    output="output.passenger_enterprise/binaries"
    passenger_edition="passenger-enterprise"
fi
mkdir -p $output
tarball="${output}/ubuntu-${1}-${5}-nginx-${4}.tar.gz"
# NOTE: - the image tag must match the one compile_nginx.sh builds
#       - the tarball is written to a temporary file and renamed only once the copy succeeds: bulk-generate.rb counts any
#         existing tarball as done, so a failed extraction mustn't leave a partial one behind
docker run --rm --platform "linux/${5}" --entrypoint cat cloud66-nginx:ubuntu-${1}-${5}-nginx-${2}-${passenger_edition}-${3}-release-${4} /nginx.tar.gz > "${tarball}.tmp" || { rm -f "${tarball}.tmp"; exit 1; }
mv "${tarball}.tmp" "${tarball}"
