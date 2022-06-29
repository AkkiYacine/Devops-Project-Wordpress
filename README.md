
# Wordpress Devops Project

The project aims to enable the deployment of a Wordpress containerised application running with its database service and its nginx reverse proxy server. This deployment is to be performed in two environments, a test environment and a production environment.
## Solution

I solved this problem by using docker technology and more specifically docker-compose. The solution will generate, with the help of the scripting tool tools.sh, our two test and production environments by deploying, in each of them, the user's Wordpress site through the implementation of three containers: a nginx container which will be used as a reverse proxy server, a wordpress service site container and a mysql database container. This deployment will be possible through the use of a docker-compose.yml configuration file that will be created in each environment.

* Architecture of the test and production environments :

![architecture_devopsvfin](https://user-images.githubusercontent.com/101942400/176454958-bb6292f2-a907-4c53-89ae-ad54a045ca73.png)

### tools.sh

The tools.sh script is the base script file for the solution, once executed it will generate our two test and production environments within two folders called wordpress-test and wordpress-prod.
It will then create the files and folders needed to deploy the docker containers and configure the nginx proxy server for each environment. In addition to deploying, it will also ensure that each environment has the correct configuration by using specific environment variables.
Among these variables are the name of the site and the name of the user which will be requested at the time of the execution of the tool.



#### docker-compose.yml

The docker-compose.yml file is a configuration file that deploys the nginx reverse proxy server, the Wordpress site and the MySQL database.
This file is generated using the tools.sh script and is edited differently for test and production environments, using environment variables. For example the PORT variable used on the host by the nginx server container which will be 8080 for the test environment and 80 for production. 

#### volumes

I use a volume configuration in the docker-compose.yml files to persist the data of the different docker services and also make these volumes accessible for these services.


#### default.conf

This file is used to configure the nginx proxy server and allows this service to deliver the pages provided by the wordpress service. It is therefore also used to connect the nginx service to the wordpress service. The nginx server is therefore located between the client and the wordpress service, it plays its role of proxy server.



## List of containers

