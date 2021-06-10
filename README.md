
This project is used to compile a self-contained NGINX that comes with useful modules and generate a deb file for easy installation on Debian based systems.

It is used by Cloud 66 to compile the default NGINX + Passenger installation for all servers. It can also be used by Cloud 66 users to generate their own NGINX installation and then upload it to a public location and tell Cloud 66 to install it via the [manifest](https://help.cloud66.com/rails/references/manifest-web-settings.html).

## Supported Versions
### Operating Systems
Ubuntu 18.04
### NGINX
1.20.1
### Passenger
5.3.0-6.0.9
