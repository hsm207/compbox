# Introduction
 
 This repo contains a Dockerfile to create an environment to do computational experiments.

 # Content

 The container will contain:

 1. the latest version of Julia from `julia:buster`
 2. the latest version of Python from miniconda3
 3. the latest version of R from `http://cran.asia/bin/linux/debian buster-cran35`
 4. rstan
 5. jupyter notebook
 6. A non-root user named `user`

 # Usage
 In this project's directory, execute:

 ```bash
bash build.sh DOCKERHUB_USERNAME DOCKERHUB_PASSWORD
 ```
 This will build and push the image to DockerHub with the name `DOCKERHUB_USERNAME/compbox:latest`