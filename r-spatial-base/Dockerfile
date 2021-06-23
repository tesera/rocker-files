## Emacs, make this -*- mode: sh; -*-

## start with the Docker 'R-base' Debian-based image
FROM r-base:3.3.2

## maintainer of this script
MAINTAINER Alex Chubaty <alex.chubaty@gmail.com>

## Remain current
RUN apt-get update -qq \
  && apt-get dist-upgrade -y

## Prevent r-base-core from updating past 3.3.3
RUN apt-mark hold r-base-core

## additional build dependencies for R spatial packages
RUN apt-get install -y --no-install-recommends -t unstable \
      bwidget \
      ca-certificates \
      curl \
      gdal-bin \
      git \
      gsl-bin \
      libcairo2-dev \
      libcurl4-openssl-dev \
      libgdal-dev \
      libgeos-dev \
      libgit2-dev \
      libmagick++-dev \
      libproj-dev \
      libspatialite-dev \
      libprotobuf-dev \
      libprotoc-dev \
      libssh2-1-dev \
      libssl-dev \
      libudunits2-dev \
      libv8-dev \
      libxml2-dev \
      libxt-dev \
      netcdf-bin \
      pandoc pandoc-citeproc \
      protobuf-compiler \
      python-gdal \
      python3-gdal \
      qpdf \
      r-cran-tkrplot \
      xauth \
      xfonts-base \
      xvfb

## Note: install older version of r-cran-rgl which is compatible with 3.3.3
RUN apt-get install -y --no-install-recommends r-cran-rgl=0.96.0-1

RUN apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /var/lib/apt/lists

## install devtools
RUN install2.r devtools remotes

## install R spatial packages && cleanup
RUN xvfb-run -a install.r \
      classInt \
      gdalUtils \
      geoR \
      ggmap \
      ggvis \
      gstat \
      mapdata \
      maps \
      maptools \
      plotKML \
      RandomFields \
      RColorBrewer \
      rgdal \
      rgeos \
      sf \
      sp \
      spacetime \
      spatstat \
      raster \
      rasterVis \
      rts \
  && installGithub.r s-u/fastshp \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds
