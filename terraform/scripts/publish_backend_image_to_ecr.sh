#!/bin/bash

ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
IMAGE_TAG=${IMAGE_TAG:-latest}
echo "IMAGE_TAG is ${IMAGE_TAG}"

aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.eu-west-2.amazonaws.com

docker build -t backend:$IMAGE_TAG ./backend

docker tag backend:$IMAGE_TAG $ACCOUNT_ID.dkr.ecr.eu-west-2.amazonaws.com/jool-dev-backend:$IMAGE_TAG

docker push $ACCOUNT_ID.dkr.ecr.eu-west-2.amazonaws.com/jool-dev-backend:$IMAGE_TAG

