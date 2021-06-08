#!/usr/bin/env bash
set -e

nginx -V
nginx -t
nginx
ps aux | grep '[n]ginx'
curl localhost:80
ps aux | grep '[P]assenger'
passenger-config --root
passenger-status
