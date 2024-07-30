#!/bin/sh

FORCE_REBUILD=false
REGION="us-west-2"
ACCOUNT="712635442529"
CONTAINER="tesera/r-spatial-base"
BUILD_PROFILE="hris-workflows"
ECR_IMAGE_NAME=${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com/${CONTAINER}
echo $ECR_IMAGE_NAME

FORCE_REBUILD=FALSE

image_tag="dev"

# check for tag 
if [ ! -z ${TAG+x} ] ; then
  echo "tag specified"
  image_tag=$TAG
fi

aws ecr get-login-password --region $REGION --profile $BUILD_PROFILE | docker login --username AWS --password-stdin $ACCOUNT.dkr.ecr.$REGION.amazonaws.com

usage() { printf "Usage: $0 [-f]\n  -f  Force docker re-build from nothing. (uses docker --no-cache)\n" 1>&2; exit 1; }

while getopts ":fh" opt; do
  case $opt in
    f)
      FORCE_REBUILD=TRUE
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      usage
      exit 1
      ;;
    h)
      usage
      exit 0;
      ;;
  esac
done

if $FORCE_REBUILD; then
    docker build --no-cache -t $ECR_IMAGE_NAME:$image_tag .
else
    docker build -t $ECR_IMAGE_NAME:$image_tag .
fi
