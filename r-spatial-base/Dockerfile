## Emacs, make this -*- mode: sh; -*-

## start with the rocker 'r-ver' Ubuntu-based image:
## R built from source + littler, CRAN set to Posit Package Manager (P3M) binaries,
## no RStudio Server. See https://github.com/rocker-org/rocker-versioned2
FROM rocker/r-ver:4.6.2

## maintainer of this script
LABEL maintainer="Alex Chubaty <alex.chubaty@gmail.com>"

## System libraries for R spatial packages (P3M binaries link against these),
## plus tools used by downstream images. Update, install and clean up in a single
## layer so the apt cache/lists are not baked into the image.
## jq     - Workflows and dp-manage-files use jq
## xvfb   - some downstream images run `xvfb-run -a install.r ...`
## libv8  - V8 (needed by h3jsr, concaveman in downstream images)
## GDAL runtime only (via gdal-bin): libgdal-dev is omitted because it pulls in ~290 MB
## of -dev packages (Boost, Poppler, HDF4, ...) that are only needed to compile
## GDAL-linked R packages from source; P3M binaries don't need it.
RUN apt-get update -qq \
 && apt-get upgrade -y \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      ca-certificates curl git jq unzip xauth xfonts-base xvfb \
      gdal-bin libgeos-dev libproj-dev libudunits2-dev \
      libsqlite3-dev libnetcdf-dev netcdf-bin libgsl-dev libabsl-dev \
      libxml2-dev libcurl4-openssl-dev libssl-dev libgit2-dev libssh2-1-dev \
      libcairo2-dev libharfbuzz-dev libfribidi-dev libfreetype6-dev libfontconfig1-dev \
      libpng-dev libtiff-dev libjpeg-dev libxt-dev \
      libv8-dev libmagick++-dev libprotobuf-dev protobuf-compiler \
      python3-gdal qpdf bwidget \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

## rocker images only link install2.r and installGithub.r; downstream images use install.r
RUN ln -sf "${R_HOME}/site-library/littler/examples/install.r" /usr/local/bin/install.r

## install R packages in separate steps so a failure is easy to pinpoint.
## install2.r --error stops the build if a package fails.
## P3M binaries are not stripped, so each step strips the shared libraries it
## installed (-newer stamp); stripping files from an earlier layer would copy them
## into this layer and grow the image.
## (rgdal, rgeos, gdalUtils dropped: archived on CRAN in 2023; use sf/terra instead)

## install devtools
RUN touch /tmp/stamp \
 && install2.r --error --skipinstalled remotes devtools \
 && find /usr/local/lib/R/site-library -name '*.so' -newer /tmp/stamp -exec strip --strip-debug {} + \
 && rm -rf /tmp/stamp /tmp/downloaded_packages /tmp/*.rds

## install R spatial statistics packages
RUN touch /tmp/stamp \
 && install2.r --error --skipinstalled classInt geoR gstat \
 && find /usr/local/lib/R/site-library -name '*.so' -newer /tmp/stamp -exec strip --strip-debug {} + \
 && rm -rf /tmp/stamp /tmp/downloaded_packages /tmp/*.rds

## install R spatial vector/point-pattern packages
RUN touch /tmp/stamp \
 && install2.r --error --skipinstalled sf sp spacetime spatstat \
 && find /usr/local/lib/R/site-library -name '*.so' -newer /tmp/stamp -exec strip --strip-debug {} + \
 && rm -rf /tmp/stamp /tmp/downloaded_packages /tmp/*.rds

## install R spatial raster packages
RUN touch /tmp/stamp \
 && install2.r --error --skipinstalled raster rasterVis rts terra \
 && find /usr/local/lib/R/site-library -name '*.so' -newer /tmp/stamp -exec strip --strip-debug {} + \
 && rm -rf /tmp/stamp /tmp/downloaded_packages /tmp/*.rds

## install R lidar packages that need xvfb
RUN touch /tmp/stamp \
 && xvfb-run -a install2.r --error --skipinstalled lidR geometry concaveman \
 && find /usr/local/lib/R/site-library -name '*.so' -newer /tmp/stamp -exec strip --strip-debug {} + \
 && rm -rf /tmp/stamp /tmp/downloaded_packages /tmp/*.rds

## install AWS CLI v2 and remove the installer
RUN curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscliv2.zip \
 && unzip -q /tmp/awscliv2.zip -d /tmp \
 && /tmp/aws/install \
 && rm -rf /tmp/awscliv2.zip /tmp/aws
