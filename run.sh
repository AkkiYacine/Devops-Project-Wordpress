#!/bin/sh

if [ ! -d "wordpress-test" ] || [ ! -d "wordpress-prod" ];
then
echo "Environment folders doesn't exist, can't run the docker containers"
exit 1
fi

cd wordpress-test
sudo docker-compose down --volumes --remove-orphans
sudo docker-compose up -d
cd ..

cd wordpress-prod
sudo docker-compose down --volumes --remove-orphans
sudo docker-compose up -d
cd ..
