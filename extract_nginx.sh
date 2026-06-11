#!/usr/bin/env bash
set -e

if [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -z "$3" ]] || [[ -z "$5" ]]; then
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
if [[ -f "${PASSENGER_ENTERPRISE_LICENSE}" ]] && [[ -f "${PASSENGER_ENTERPRISE_TARBALL}" ]]; then
    output="output.passenger_enterprise/binaries"
fi
mkdir -p $output
docker run --rm --entrypoint cat cloud66-nginx:ubuntu-${1}-${5}-nginx-${2}-passenger-${3}-release-${4} /nginx.tar.gz > ${output}/ubuntu-${1}-${5}-nginx-${4}.tar.gz
