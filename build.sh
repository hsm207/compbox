#!/bin/bash

docker login -u $1 -p $2 && \
    docker build -t $1/compbox . && \
    docker push $1/compbox:latest
