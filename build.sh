#!/usr/bin/env bash

# Update parent image
docker pull jenkins/jenkins:lts

docker build --rm -t herychemo/jenkins:0.1.3 .

docker tag herychemo/jenkins:0.1.3 herychemo/jenkins:latest

IDS=`docker images | grep "\<none\>" | awk '{print $3}'`
if [[ ! -z "$IDS" ]]; then
  docker rmi -f $IDS
fi
