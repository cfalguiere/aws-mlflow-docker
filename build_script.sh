#!/bin/bash

# must be run from wthe root of the git repository
# bash build_script.sh

set -o errexit
set -o nounset
set -o pipefail

function handle_exit() {
  # Add cleanup code here
  # for eg. rm -f /tmp/${lock_file}.lock
  # clean exit
  echo "terminated"
}

trap handle_exit 0 SIGHUP SIGINT SIGQUIT SIGABRT SIGTERM

# SETUP your conttext
export AWS_DEFAULT_REGION=eu-west-3
export AWS_ACCOUNT_ID=$( aws sts get-caller-identity --query "Account" --output text )
export IMAGE_TAG=latest
export IMAGE_REPO_NAME=mlflow

echo "AWS_ACCOUNT_ID=$AWS_ACCOUNT_ID"

echo "== Connecting to ECR..."
aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com

echo "== Building Docker image..."
docker build --tag $IMAGE_REPO_NAME:$IMAGE_TAG .

echo "== Pushing image to ECR..."
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:$IMAGE_TAG

echo "== DONE"