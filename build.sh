#!/bin/bash


docker login -u $1 -p $2
docker build -t $DOCKERHUB_USERNAME/compbox . && \
    docker push $DOCKERHUB_USERNAME/compbox:latest
