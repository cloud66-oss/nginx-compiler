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
    echo "./compile_nginx.sh 18.04 1.18.0 6.0.9 1.0.0"
    exit 22
fi

case $1 in
    18.04)
	OPERATING_SYSTEM_CODENAME=bionic
	;;
    20.04)
	OPERATING_SYSTEM_CODENAME=focal
	;;
    *)
	echo "Unknown operating system"
	exit 1
	;;
esac

INCLUDE_PASSENGER_ENTERPRISE=false
PASSENGER_ENTERPRISE_LICENSE="passenger_enterprise/passenger-enterprise-license"
PASSENGER_ENTERPRISE_TARBALL="passenger_enterprise/passenger-enterprise-server-${3}.tar.gz"
if [[ -f "${PASSENGER_ENTERPRISE_LICENSE}" ]] && [[ -f "${PASSENGER_ENTERPRISE_TARBALL}" ]]; then
    INCLUDE_PASSENGER_ENTERPRISE=true
fi

# create output build logs folder
mkdir -p output/build_logs
# define build log file
build_log_file="output/build_logs/build-ubuntu-$1-nginx-$2-passenger-$3-release-$4.log"
# define the next tag
tag="cloud66-nginx:ubuntu-$1-nginx-$2-passenger-$3-release-$4"
# remove previous build
docker rmi --force $tag >/dev/null 2>&1
# build new version
docker build --rm --build-arg OPERATING_SYSTEM_VERSION=$1 --build-arg OPERATING_SYSTEM_CODENAME=$OPERATING_SYSTEM_CODENAME --build-arg NGINX_VERSION=$2 --build-arg PASSENGER_VERSION=$3 --build-arg RELEASE_VERSION=$4 --build-arg INCLUDE_PASSENGER_ENTERPRISE=$INCLUDE_PASSENGER_ENTERPRISE --tag $tag . >$build_log_file 2>&1
