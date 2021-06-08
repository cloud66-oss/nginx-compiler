#!/usr/bin/env bash
set -e

if [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -z "$3" ]]; then
    echo "FATAL: Expected ARGS:"
    echo "1. os-version: 18.04"
    echo "2. nginx-version: ie. 1.18.0"
    echo "3. passenger-version: 6.0.8"
    echo ""
    echo "Usage Examples:"
    echo "./extract_nginx.sh 18.04 1.18.0 6.0.8"
    exit 22
fi

output="output/binaries/ubuntu/${1}/x86_64"
mkdir -p $output
docker run --rm --entrypoint cat cloud66-nginx:ubuntu-${1}-nginx-${2}-passenger-${3} /nginx.tar.gz > ${output}/nginx-${2}.tar.gz
docker run --rm --entrypoint cat cloud66-nginx:ubuntu-${1}-nginx-${2}-passenger-${3} /passenger.tar.gz > ${output}/nginx-${2}-passenger-${3}.tar.gz
# docker run --rm --entrypoint cat cloud66-nginx:ubuntu-${1}-nginx-${2}-passenger-${3} /passenger-enterprise.tar.gz > ${output}/nginx-${2}-passenger-enterprise-${3}.tar.gz
