#!/usr/bin/env bash

docker build --rm -t herychemo/jenkins:0.1.2 .

docker tag herychemo/jenkins:0.1.2 herychemo/jenkins:latest
