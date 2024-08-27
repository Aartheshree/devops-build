#!/bin/bash

# Check if the event is a push to the dev branch
if [[ $GIT_BRANCH == "dev" ]]; then
    echo "Build and pushing Docker image to dev repository in Docker Hub."
        
    docker tag ctn:a1 aartheshree/dev:latest
    docker login -u $dockerhubusername -p $dockerhubpassword
    docker push aartheshree/dev:tagname

# Check if the event is a merge from dev to master
elif [[ $GIT_BRANCH == "main" ]]; then
    echo "Build and pushing Docker image to prod repository in Docker Hub."
    
    docker tag ctn:a1 aartheshree/prod:latest
    docker login -u $dockerhubusername -p $dockerhubpassword
    docker push aartheshree/prod:tagname
fi
