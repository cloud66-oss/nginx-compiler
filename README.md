
# NGINX compiler
This project is used to compile a self-contained NGINX that comes with useful modules and generate a deb file for easy installation on Debian based systems.

It is used by Cloud 66 to compile the default NGINX + Passenger installation for all servers. It can also be used by Cloud 66 users to generate their own NGINX installation and then upload it to a public location and tell Cloud 66 to install it via the [manifest](https://help.cloud66.com/rails/references/manifest-web-settings.html).

## Requirements
This project uses Docker to compile NGINX using a Dockerfile. You must have Docker installed on your host machine for the scripts to work.

## Compilation
You can compile NGINX for a specific combination of Ubuntu + NGINX + Passenger. For Ubuntu 18.04, NGINX 1.20.1 and Passenger 6.0.9, this is done by running the following:
```bash
./compile_nginx.sh 18.04 1.20.1 6.0.9
```

This will result in a Docker image which will contain with NGINX + Passenger in a tarball.

## Extraction
To extract the tarball, you can run the following (for your combination of Ubuntu + NGINX + Passenger version):
```
./extract_nginx.sh 18.04 1.20.1 6.0.9
```

This will place the resulting tarballs in the `output` directory. For the previous extraction example, you will find two files under `output/binaries/ubuntu/18.04/x86_64`: `nginx-1.20.1.tar.gz` and `nginx-1.20.1-passenger-6.0.9.tar.gz`.

## Resulting Tarballs
The resulting tarballs from the extraction step can be uploaded and installed on the target server as follows:
```
tar -C / -zxvf <TARBALL>
```

Doing this for the NGINX and Passenger tarballs will result in the following files under `/usr/local/debs`:
```
$ find /usr/local/debs/
/usr/local/debs/
/usr/local/debs/nginx-1.20.1
/usr/local/debs/nginx-1.20.1/nginx
/usr/local/debs/nginx-1.20.1/nginx/nginx_1.20.1-1~bionic1_amd64.deb
/usr/local/debs/nginx-1.20.1/prerequisites
/usr/local/debs/nginx-1.20.1/prerequisites/openresty-luajit_2.1-20210510-1~bionic1_amd64.deb
/usr/local/debs/nginx-1.20.1/prerequisites/openresty-lua-lrucache_0.10-1~bionic1_amd64.deb
/usr/local/debs/nginx-1.20.1/prerequisites/modsecurity_3.0.4-1~bionic1_amd64.deb
/usr/local/debs/nginx-1.20.1/prerequisites/openresty-lua-core_0.1.21-1~bionic1_amd64.deb
/usr/local/debs/nginx-1.20.1-passenger-6.0.9
/usr/local/debs/nginx-1.20.1-passenger-6.0.9/passenger-module
/usr/local/debs/nginx-1.20.1-passenger-6.0.9/passenger-module/nginx-module-http-passenger_6.0.9+nginx1.20.1-1~bionic1_amd64.deb
/usr/local/debs/nginx-1.20.1-passenger-6.0.9/passenger
/usr/local/debs/nginx-1.20.1-passenger-6.0.9/passenger/passenger_6.0.9-1~bionic1_amd64.deb
```

You can then install NGINX with the following:
```
sudo apt-get install /usr/local/debs/nginx-1.20.1/**/*.deb
```

and Passenger (which depends on this NGINX installation) with the following:
```
sudo apt-get install /usr/local/debs/nginx-1.20.1-passenger-6.0.9/**/*.deb
```

## Supported Versions
### Operating Systems
Ubuntu 18.04
### NGINX
1.20.1
### Passenger
5.3.0-6.0.9