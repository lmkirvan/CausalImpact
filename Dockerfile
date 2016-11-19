# Dockerfile to build Shiny Server container image for CausalImpact
# Based on Ubuntu
# ===============================================================================

# Set the base image to Ubuntu.
# Testing of the Dockerfile has been done on Ubuntu 16.04 64-bit server edition
# "Xenial Xerus".
FROM ubuntu:16.04

# File Author / Maintainer
MAINTAINER Kyle Polich / kyle@dataskeptic.com

# Update the repository sources list
RUN apt-get update

# Installation
# ------------------------------------------------------------------------------

RUN apt-get install libssl-dev

# R (latest version from CRAN)
# --------------------------------------

# 1. Add the correct repository to /etc/apt/sources.list.
RUN sh -c 'echo "deb http://cran.rstudio.com/bin/linux/ubuntu xenial/" >> /etc/apt/sources.list'

# 2. Add the CRAN authentication key:
RUN gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9

# 3. Add the key to apt:
RUN gpg -a --export E084DAB9 | apt-key add -

# 4. Update the list of available packages:
RUN apt-get update

# 5. Install R. (-y flag to automatically answer Yes when asked if we are sure we want to download the package):

RUN apt-get install r-base
RUN apt-get install libcurl4-openssl-dev

# Not required but very helpful
# --------------------------------------
RUN apt-get install net-tools

# Shiny Server
# --------------------------------------
# gdebi is a simple tool for installing .deb files
RUN apt-get -y install gdebi-core
RUN apt-get -y install wget
RUN wget https://download3.rstudio.org/ubuntu-12.04/x86_64/shiny-server-1.4.2.786-amd64.deb
RUN gdebi --n shiny-server-1.4.2.786-amd64.deb

# Shiny App
# --------------------------------------

# 1. Clean up the shiny server directory:
RUN rm -rfv /srv/shiny-server/*

# 2. Change the ownership of the shiny app directory:
RUN chown -R shiny /srv/shiny-server

# 3. Clone the shiny app into the default server directory:
RUN apt-get install -y git
RUN git clone https://github.com/data-skeptic/CausalImpact /srv/shiny-server
# Move files to the default location specified in `shiny-server.conf`
RUN mv /srv/shiny-server/shinyapp/* /srv/shiny-server/
COPY global.R /srv/shiny-server/

# Getting the App Ready
RUN apt-get -y install libssl-dev
RUN apt-get -y install libcurl4-openssl-dev


# Installing R packages
# --------------------------------------
WORKDIR "/srv/shiny-server"

# Start shiny-server
# --------------------------------------
RUN systemctl start shiny-server

R -e "install.packages('shiny', repos='http://cran.rstudio.com/')"
R -e "install.packages('devtools', repos='http://cran.rstudio.com/')"
R -e "install.packages('causalimpact', repos='http://cran.rstudio.com/')"
R -e "devtools::install_github('google/CausalImpact')"

R -e "shiny::runApp('/srv/shiny-server', host='0.0.0.0', port=2718)"


# Expose - Since Shiny picks random ports, I picked this as my "official"
#          port.  I list it here as a hint that this is the port you want
#          to expose.  You will need to expose it when you run the
#          container.

EXPOSE 2718
