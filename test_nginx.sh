#!/usr/bin/env bash
set -e

echo "Checking NGINX version"
nginx -V

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
