#!/bin/bash
#
# deploy-container.sh
#
# This is a simple helper script to deploy a container to amazon ecr.

echo "deploy container"

ACCOUNT="712635442529"
REGION="us-west-2"
CONTAINER="tesera/r-spatial-base"
BUILD_PROFILE="hris-workflows"
ECR_IMAGE_NAME="${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/${CONTAINER}"
echo $ECR_IMAGE_NAME

image_tag="dev"

# check for tag 
if [ ! -z ${TAG+x} ] ; then
  echo "tag specified"
  image_tag=$TAG
fi

# Login to AWS ECR
aws ecr get-login-password --region $REGION --profile $BUILD_PROFILE | docker login --username AWS --password-stdin $ACCOUNT.dkr.ecr.$REGION.amazonaws.com


# Create a repository for $CONTAINER if not exists
echo $CONTAINER
echo $(aws ecr describe-repositories --profile $BUILD_PROFILE | grep "$CONTAINER")

if [[ -z `aws ecr describe-repositories --profile $BUILD_PROFILE | grep "$CONTAINER"` ]]; then
  echo "Creating Repository"
  REPO_CREATED=$(aws ecr create-repository --repository-name $CONTAINER --profile $BUILD_PROFILE)
fi

# Push image to AWS ECR
docker push ${ECR_IMAGE_NAME}:$image_tag