#!/usr/bin/env bash
set -e

echo "Checking NGINX version"
nginx -V

# this test may fail if the system OpenSSL is the same as the OpenSSL that NGINX was built with but it's very unlikely to happen
echo "Testing NGINX is using system OpenSSL"
nginx -V 2>&1 | grep "running with OpenSSL"

# this test is not foolproof - I previously accidentally statically compiled NGINX and something was still using libssl from the system
echo "Ensuring that OpenSSL is dynamically linked"
ldd $(which nginx) | grep libssl

echo "Testing NGINX configuration"
nginx -t

echo "Starting up NGINX"
nginx

echo "Testing NGINX process is up"
ps aux | grep '[n]ginx'

echo "Testing Passenger process is up"
curl localhost:80
ps aux | grep '[P]assenger'

echo "Testing Passenger passenger-config executable"
passenger-config --root

echo "Testing Passenger passenger-status executable"
passenger-status

echo "Testing NGINX mruby module"
curl localhost:80/mruby | grep "mruby success"

echo "Testing NGINX lua module"
curl localhost:80/lua | grep "lua success"
