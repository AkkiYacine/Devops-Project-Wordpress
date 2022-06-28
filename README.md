# Wordpress Devops Project

The project aims to enable the deployment of a Wordpress containerised application running with its database service and its nginx reverse proxy server. This deployment is to be performed in two environments, a test environment and a production environment.

## Solution

I solved this problem by using docker technology and more specifically docker-compose. The solution will generate, with the help of the scripting tool tools.sh, our two test and production environments by deploying, in each of them, the user's Wordpress site through the implementation of three containers: a nginx container which will be used as a reverse proxy server, a wordpress service site container and a mysql database container. This deployment will be possible through the use of a docker-compose.yml configuration file that will be created in each environment.

* Architecture of the test and production environments :

### tools.sh

#### docker-compose.yml

The docker-compose.yml file is a configuration file that deploys the nginx reverse proxy server, the Wordpress site and the MySQL database.

#### Volumes
