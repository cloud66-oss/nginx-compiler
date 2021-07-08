<img src="http://cdn2-cloud66-com.s3.amazonaws.com/images/oss-sponsorship.png" width=150/>

# NGINX compiler
This project is used to compile a self-contained NGINX that comes with useful modules and generate a deb file for easy installation on Debian based systems.

It is used by Cloud 66 to compile the default NGINX + Passenger installation for all servers. It can also be used by Cloud 66 users to generate their own NGINX installation and then upload it to a public location and tell Cloud 66 to install it via the [manifest](https://help.cloud66.com/rails/references/manifest-web-settings.html#nginx).

## Requirements
This project uses Docker to compile NGINX. You must have Docker installed on your host machine for the scripts to work.

## Compilation
You can compile NGINX for a specific combination of Ubuntu + NGINX + Passenger + release versions. The release version is used to cover dependencies that are not covered by the other versions, e.g. build dependency/NGINX module update. For Ubuntu 18.04, NGINX 1.20.1, Passenger 6.0.9 and release 1.0.0, this is done by running the following:
```bash
./compile_nginx.sh 18.04 1.20.1 6.0.9 1.0.0
```

This will result in a Docker image which will contain NGINX + Passenger in separate tarballs.

### Passenger Enterprise
You can optionally compile Passenger Enterprise. To do this, you must have both the `passenger_enterprise/passenger-enterprise-license` (containing the Passenger Enterprise license) and `passenger_enterprise/passenger-enterprise-server-${PASSENGER_VERSION}.tar.gz` (containing the Passenger Enterprise source code) files present in the source root. Both can be acquired from the Passenger Enterprise portal.

## Extraction
To extract the tarballs from the Docker image, you can run the following (for your combination of Ubuntu + NGINX + Passenger + release versions):
```
./extract_nginx.sh 18.04 1.20.1 6.0.9 1.0.0
```

This will place the resulting tarballs in the `output` directory. For the previous extraction example, you will find one file under `output/binaries`: `ubuntu-18.04-nginx-1.0.0.tar.gz`.

### Passenger Enterprise
If you have also compiled Passenger Enterprise, then there will be an additional file in the `output/binaries` directory: `ubuntu-18.04-passenger-enterprise-1.0.0.tar.gz`.

## Installation
The resulting tarballs from the extraction step can be uploaded to the target server and installed as follows:
```
tar -C / -zxvf <TARBALL(S)>
```

Doing this for the NGINX and Passenger tarballs will result in the following files under `/usr/local/debs`:
```
$ find /usr/local/debs/
/usr/local/debs/
/usr/local/debs/ubuntu-18.04-nginx-1.0.0
/usr/local/debs/ubuntu-18.04-nginx-1.0.0/passenger-module
/usr/local/debs/ubuntu-18.04-nginx-1.0.0/passenger-module/nginx-module-http-passenger_6.0.9+nginx1.20.1-1.0.0~bionic1_amd64.deb
/usr/local/debs/ubuntu-18.04-nginx-1.0.0/nginx
/usr/local/debs/ubuntu-18.04-nginx-1.0.0/nginx/nginx_1.20.1-1.0.0~bionic1_amd64.deb
/usr/local/debs/ubuntu-18.04-nginx-1.0.0/prerequisites
/usr/local/debs/ubuntu-18.04-nginx-1.0.0/prerequisites/openresty-lua-lrucache_0.10-1.0.0~bionic1_amd64.deb
/usr/local/debs/ubuntu-18.04-nginx-1.0.0/prerequisites/modsecurity_3.0.4-1.0.0~bionic1_amd64.deb
/usr/local/debs/ubuntu-18.04-nginx-1.0.0/prerequisites/openresty-luajit_2.1-20210510-1.0.0~bionic1_amd64.deb
/usr/local/debs/ubuntu-18.04-nginx-1.0.0/prerequisites/openresty-lua-core_0.1.21-1.0.0~bionic1_amd64.deb
/usr/local/debs/ubuntu-18.04-nginx-1.0.0/passenger
/usr/local/debs/ubuntu-18.04-nginx-1.0.0/passenger/passenger_6.0.9-1.0.0~bionic1_amd64.deb
```

You can then install NGINX with the following:
```
sudo apt-get install /usr/local/debs/ubuntu-18.04-nginx-1.0.0/prerequisites/*.deb /usr/local/debs/ubuntu-18.04-nginx-1.0.0/nginx/*.deb
```

and Passenger (which depends on this NGINX installation) with the following:
```
sudo apt-get install /usr/local/debs/ubuntu-18.04-nginx-1.0.0/passenger/*.deb /usr/local/debs/ubuntu-18.04-nginx-1.0.0/passenger-module/*.deb
```

For Passenger Enterprise, you will also have the `/usr/local/debs/ubuntu-18.04-nginx-1.0.0/passenger-enterprise` and `/usr/local/debs/ubuntu-18.04-nginx-1.0.0/passenger-enterprise-module` directories, which you can install instead of the standard Passenger installation as follows:
```
sudo apt-get install /usr/local/debs/ubuntu-18.04-nginx-1.0.0/passenger-enterprise/*.deb /usr/local/debs/ubuntu-18.04-nginx-1.0.0/passenger-enterprise-module/*.deb
```

Be sure to purge any traces of previous NGINX or Passenger installations before attempting this.

## Cloud 66 Integration
You can use these scripts to compile a version of NGINX for Cloud 66 (for example, with additional modules, or a different version of Passenger).

In order to do this, perform the [compilation](#compilation) and [extraction](#extraction) steps on your local machine, and then upload the resulting tarball to a public location (for example, using S3). You can then link to this location via the [manifest](https://help.cloud66.com/rails/references/manifest-web-settings.html#nginx), and this will result in your version of NGINX being installed for new servers.

Please make sure that the name of the tarball is not changed when uploaded to your public location.

## Tested Versions
Each release will be compiled for a specific version of NGINX + Passenger. Please see the [releases](https://github.com/cloud66-oss/nginx-compiler/releases) for specific versions.
