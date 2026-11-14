# rocker-files/r-spatial-base

Dockerfile based on the [`rocker`](https://github.com/rocker-org/rocker) project by @eddelbuettel and @cboettig.

`r-spatial-base` adds various R spatial/mapping tools to the [`rocker/r-base`](https://hub.docker.com/r/rocker/r-base/) container.
See [rocker issue 119](https://github.com/rocker-org/rocker/issues/119).

[![](https://images.microbadger.com/badges/image/achubaty/r-spatial-base.svg)](https://microbadger.com/images/achubaty/r-spatial-base)

## Using this image

Some spatial packages require an X server, so `R` should be started using:

```
docker run --rm -it achubaty/r-spatial-base bash

xvfb-run -a R
```

## Container versions

`hris-development/tesera/r-spatial-base:4.1.0` : updates FROM r-base:3.3.2 to FROM r-base:4.1.0

`hris-development/tesera/r-spatial-base:4.1.1` : adds AWSCLI v2

`hris-development/tesera/r-spatial-base:4.4.1` : updates FROM r-base:4.1.0 to FROM r-base:4.4.1

`hris-development/tesera/r-spatial-base:4.4.2` : updates r-spatial-base:4.4.1 with jq

`hris-development/tesera/r-spatial-base:4.6.2` : updates FROM r-base:4.4.1 to FROM r-base:4.6.2 (fewer base image vulnerabilities); slims the image by merging apt and AWS CLI install/cleanup into single layers; installs R packages with `install2.r --error` in separate steps so failures stop the build; drops rgdal, rgeos and gdalUtils (archived on CRAN)
