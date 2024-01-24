#!/usr/bin/env bash
set -e

if [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -z "$3" ]]; then
    echo "FATAL: Expected ARGS:"
    echo "1. os-version: 18.04"
    echo "2. nginx-version: ie. 1.18.0"
    echo "3. passenger-version: 6.0.10"
    echo "4. release-version: 1.0.0"
    echo ""
    echo "Usage Examples:"
    echo "./extract_nginx.sh 18.04 1.18.0 6.0.10 1.0.0"
    exit 22
fi

output="output/binaries"
mkdir -p $output
docker run --rm --entrypoint cat cloud66-nginx:ubuntu-${1}-nginx-${2}-passenger-${3}-release-${4} /nginx.tar.gz > ${output}/ubuntu-${1}-nginx-${4}.tar.gz
