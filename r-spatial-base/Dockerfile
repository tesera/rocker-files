## Emacs, make this -*- mode: sh; -*-

## start with the Docker 'R-base' Debian-based image
FROM r-base:4.6.2

## maintainer of this script
LABEL maintainer="Alex Chubaty <alex.chubaty@gmail.com>"

## Remain current, install build dependencies for R spatial packages, and clean up
## in a single layer so the apt cache/lists are not baked into the image.
## jq - Workflows and dp-manage-files use jq
RUN apt-get update -qq \
 && apt-get dist-upgrade -y \
 && apt-get install -y --no-install-recommends -t unstable \
      bwidget ca-certificates curl gdal-bin git gsl-bin jq libabsl-dev \
      libcairo2-dev libcurl4-openssl-dev libgdal-dev libgeos-dev libgit2-dev \
      libmagick++-dev libproj-dev libspatialite-dev libprotobuf-dev libprotoc-dev \
      libssh2-1-dev libssl-dev libudunits2-dev libv8-dev libxml2-dev libxt-dev \
      netcdf-bin protobuf-compiler python3-gdal qpdf r-cran-tkrplot \
      xauth xfonts-base xvfb libharfbuzz-dev libfribidi-dev unzip \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

## install R packages in separate steps so a failure is easy to pinpoint.
## install2.r --error stops the build if a package fails (install.r only warns),
## and it strips compiled libraries during install (_R_SHLIB_STRIP_).
## (rgdal, rgeos, gdalUtils dropped: archived on CRAN in 2023; use sf/terra instead)

## s2 (needed by sf) builds a bundled Abseil with cmake on Linux by default;
## use the system libabsl-dev instead
ENV S2_FORCE_BUNDLED_ABSEIL=false

## install devtools
RUN install2.r --error remotes devtools \
 && rm -rf /tmp/downloaded_packages /tmp/*.rds

## install R spatial statistics packages
RUN xvfb-run -a install2.r --error classInt geoR gstat \
 && rm -rf /tmp/downloaded_packages /tmp/*.rds

## install R spatial vector/point-pattern packages
RUN xvfb-run -a install2.r --error sf sp spacetime spatstat \
 && rm -rf /tmp/downloaded_packages /tmp/*.rds

## install R spatial raster packages
RUN xvfb-run -a install2.r --error raster rasterVis rts terra \
 && rm -rf /tmp/downloaded_packages /tmp/*.rds

## install AWS CLI v2 and remove the installer
RUN curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscliv2.zip \
 && unzip -q /tmp/awscliv2.zip -d /tmp \
 && /tmp/aws/install \
 && rm -rf /tmp/awscliv2.zip /tmp/aws
