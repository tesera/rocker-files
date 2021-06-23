## Emacs, make this -*- mode: sh; -*-

## start with the Docker 'R-base' Debian-based image
FROM achubaty/spades-project

## maintainer of this script
MAINTAINER Alex Chubaty <achubaty@for-cast.ca>

## install additional R packages && cleanup
ARG GITHUB_PAT=$GITHUB_PAT
RUN xvfb-run -a /usr/local/bin/installGithub.r "PredictiveEcology/LandWebUtils@development" \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

