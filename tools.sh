#!/bin/sh

#SITENAME and USERNAME of the user
read -p "Site name : " SITENAME
read -p "Nom utilisateur : " USERNAME

#PORT of production and test environments
PORT_PROD="80"
PORT_TEST="8081"

#DATABASE NAME of production and test environments
DB_TEST="db_test"
DB_PROD="db_prod"

#Check if environment folders exists
if [ -d "wordpress-test" ] || [ -d "wordpress-prod" ];
then
echo "The script has already been executed in this folder"
exit 1
fi

#Creating of the two environments folder
echo "Creating production environments folder"
mkdir wordpress-prod
echo "Creating test environments folder"
mkdir wordpress-test

#Rights on both environments
chmod -R 777 *
chmod -R 777 wordpress-test
chmod -R 777 wordpress-prod
echo "Rights on both environments"

# --------------- We go in the test environment folder for deploying containers and configuration files ---------------
cd wordpress-test

#We create and edit the docker-compose.yml file for the configuration and deployment of docker containers in test environment
echo "
version: '3.8'

services:
  nginx:
    image: nginx
    ports:
      - ${PORT_TEST}:80
    restart: always
    environment:
      - NGINX_HOST=localhost
    volumes: 
      - ./nginx:/etc/nginx/conf.d
      - ./wordpress_data/${SITENAME}:/var/www/html
    networks:
      - proxytest
    
  db:
    image: mysql:5.7
    volumes:
      - ./db_data_wp/${DB_TEST}:/var/lib/mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: ${DB_TEST}-mysqldb
      MYSQL_USER: ${USERNAME}
      MYSQL_PASSWORD: ${USERNAME}
    networks:
      - proxytest
    
  wordpresstest:
    depends_on:
      - db
    image: wordpress:php7.4-fpm-alpine
    volumes:
      - ./wordpress_data/${SITENAME}:/var/www/html
    restart: always
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: ${USERNAME}
      WORDPRESS_DB_PASSWORD: ${USERNAME}
      WORDPRESS_DB_NAME: ${DB_TEST}-mysqldb
    networks:
      - proxytest

volumes:
  db_data_wp: {}
  wordpress_data: {}

networks:
  proxytest:
    driver: bridge
" > docker-compose.yml
echo "docker-compose.yml created in the test environment"

#We create the folder nginx that will contain de configuration of the reverse proxy nginx server
mkdir nginx
cd nginx

#We create and edit the default.conf file that will contain the configuration of the reverse proxy nginx server
echo "
server {
    listen 80;

    server_name ${SITENAME}.test www.${SITENAME}.test;

    root /var/www/html;
    index index.php;
    
        location / {
            include /etc/nginx/mime.types;
            try_files \$uri \$uri/ /index.php?\$args;
        }
        # Proxying the connections connections
        location ~ \.php$ {
            try_files \$uri =404;
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            fastcgi_pass wordpresstest:9000;
            fastcgi_index index.php;
            include fastcgi_params; 
            fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name; 
            fastcgi_param SCRIPT_NAME \$fastcgi_script_name; 
        }
}
" > default.conf
cd ..
echo "Configuration file of reverse proxy nginx server created in the test environment"

#sudo docker-compose down --remove-orphans
#sudo docker-compose down --volumes
#sudo docker-compose up -d

#We left the test environment folder
cd ..

# --------------- We go in the production environment folder for deploying containers and configuration files ---------------
cd wordpress-prod

#We create and edit the docker-compose.yml file for the configuration and deployment of docker containers in test environment
echo "
version: '3.8'

services:
  nginx:
    image: nginx
    ports:
      - ${PORT_PROD}:80
    restart: always
    environment:
      - NGINX_HOST=localhost
    volumes: 
      - ./nginx:/etc/nginx/conf.d
      - ./wordpress_data/${SITENAME}:/var/www/html
    networks:
      - proxytest
    
  db:
    image: mysql:5.7
    volumes:
      - ./db_data_wp/${DB_PROD}:/var/lib/mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: ${DB_PROD}-mysqldb
      MYSQL_USER: ${USERNAME}
      MYSQL_PASSWORD: ${USERNAME}
    networks:
      - proxytest
    
  wordpresstest:
    depends_on:
      - db
    image: wordpress:php7.4-fpm-alpine
    volumes:
      - ./wordpress_data/${SITENAME}:/var/www/html
    restart: always
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: ${USERNAME}
      WORDPRESS_DB_PASSWORD: ${USERNAME}
      WORDPRESS_DB_NAME: ${DB_PROD}-mysqldb
    networks:
      - proxytest

volumes:
  db_data_wp: {}
  wordpress_data: {}

networks:
  proxytest:
    driver: bridge
" > docker-compose.yml
echo "docker-compose.yml created in the production environment"

#We create the folder nginx that will contain de configuration of the reverse proxy nginx server
mkdir nginx
cd nginx

#We create and edit the default.conf file that will contain the configuration of the reverse proxy nginx server
echo "
server {
    listen 80;

    server_name ${SITENAME}.prod www.${SITENAME}.prod;

    root /var/www/html;
    index index.php;
    
        location / {
            include /etc/nginx/mime.types;
            try_files \$uri \$uri/ /index.php?\$args;
        }
        # Proxying the connections connections
        location ~ \.php$ {
            try_files \$uri =404;
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            fastcgi_pass wordpresstest:9000;
            fastcgi_index index.php;
            include fastcgi_params; 
            fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name; 
            fastcgi_param SCRIPT_NAME \$fastcgi_script_name; 
        }
}
" > default.conf
cd ..
echo "Configuration file of reverse proxy nginx server created in the production environment"

#sudo docker-compose down --remove-orphans
#sudo docker-compose down --volumes
#sudo docker-compose up -d

#We left the production environment folder
cd ..








