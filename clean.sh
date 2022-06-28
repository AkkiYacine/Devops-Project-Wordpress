#!/bin/sh

if [ ! -d "wordpress-test" ] || [ ! -d "wordpress-prod" ];
then
echo "Environment folders doesn't exist"
exit 1
fi

cd wordpress-test
sudo docker-compose down --volumes --remove-orphans
sudo docker-compose ps
cd ..

cd wordpress-prod
sudo docker-compose down --volumes --remove-orphans
sudo docker-compose ps
cd ..

sudo rm -rf wordpress-*
