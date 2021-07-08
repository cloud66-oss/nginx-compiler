#!/usr/bin/env bash
set -e

if [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -z "$3" ]]; then
    echo "FATAL: Expected ARGS:"
    echo "1. os-version: 18.04"
    echo "2. nginx-version: ie. 1.18.0"
    echo "3. passenger-version: 6.0.9"
    echo "4. release-version: 1.0.0"
    echo ""
    echo "Usage Examples:"
    echo "./extract_nginx.sh 18.04 1.18.0 6.0.9 1.0.0"
    exit 22
fi

output="output/binaries"
mkdir -p $output
docker run --rm --entrypoint cat cloud66-nginx:ubuntu-${1}-nginx-${2}-passenger-${3}-release-${4} /nginx.tar.gz > ${output}/ubuntu-${1}-nginx-${4}.tar.gz
PASSENGER_ENTERPRISE_LICENSE="passenger_enterprise/passenger-enterprise-license"
PASSENGER_ENTERPRISE_TARBALL="passenger_enterprise/passenger-enterprise-server-${3}.tar.gz"
if [[ -f "${PASSENGER_ENTERPRISE_LICENSE}" ]] && [[ -f "${PASSENGER_ENTERPRISE_TARBALL}" ]]; then
    docker run --rm --entrypoint cat cloud66-nginx:ubuntu-${1}-nginx-${2}-passenger-${3}-release-${4} /passenger-enterprise.tar.gz > ${output}/ubuntu-${1}-passenger-enterprise-${4}.tar.gz
fi
