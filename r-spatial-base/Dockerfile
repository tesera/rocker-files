## Emacs, make this -*- mode: sh; -*-

## start with the Docker 'R-base' Debian-based image
FROM r-base:4.4.1

## maintainer of this script
LABEL maintainer="Alex Chubaty <alex.chubaty@gmail.com>"

## Remain current
RUN apt-get update -qq \
  && apt-get dist-upgrade -y

# ## Prevent r-base-core from updating past 3.3.3
# RUN apt-mark hold r-base-core

#### additional build dependencies for R spatial packages
RUN apt-get install -y --no-install-recommends -t unstable \
      bwidget \
      ca-certificates \
      curl \
      gdal-bin \
      git
RUN apt-get install -y --no-install-recommends -t unstable \
      gsl-bin \
      libcairo2-dev \
      libcurl4-openssl-dev
RUN apt-get install -y --no-install-recommends -t unstable \
      libgdal-dev \
      libgeos-dev \
      libgit2-dev \
      libmagick++-dev \
      libproj-dev \
      libspatialite-dev
RUN apt-get install -y --no-install-recommends -t unstable \
      libprotobuf-dev \
      libprotoc-dev \
      libssh2-1-dev \
      libssl-dev \
      libudunits2-dev
RUN apt-get install -y --no-install-recommends -t unstable \
      libv8-dev \
      libxml2-dev \
      libxt-dev \
      netcdf-bin \
####      pandoc pandoc-citeproc \
      protobuf-compiler
####      python-gdal \
RUN apt-get install -y --no-install-recommends -t unstable \
      python3-gdal \
      qpdf \
      r-cran-tkrplot \
      xauth \
      xfonts-base \
      xvfb \
      libharfbuzz-dev \
      libfribidi-dev

# ## Note: install older version of r-cran-rgl which is compatible with 3.3.3
# RUN apt-get install -y --no-install-recommends r-cran-rgl
# 
RUN apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /var/lib/apt/lists

## install devtools
RUN install.r devtools remotes

## install R spatial packages && cleanup
RUN xvfb-run -a install.r \
      classInt \
      gdalUtils \
      geoR \
####      ggmap \ # no visualization required in HRIS containers
####      ggvis \ # no visualization required in HRIS containers
      gstat
# RUN xvfb-run -a install.r \
# ####       mapdata \ # retired
# ####       maps \ # retired
# ####       maptools \ # retired
# ####       plotKML # retired
RUN xvfb-run -a install.r \
####       RandomFields \ # retired
####       RColorBrewer \ # no visualization required in HRIS containers
      rgdal \
      rgeos
RUN xvfb-run -a install.r \
      sf \
      sp \
      spacetime \
      spatstat \
      raster \
      rasterVis \
      rts \
      terra \
##  && installGithub.r s-u/fastshp \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

