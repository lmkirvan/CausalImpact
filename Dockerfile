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
#RUN apt-get update

# Getting the App Ready
RUN dpkg --configure -a --force-all
RUN apt-get clean
RUN apt-get update
RUN apt-get -y -f install libssl-dev
RUN apt-get -y install libcurl4-openssl-dev


# Installation
# ------------------------------------------------------------------------------


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

RUN apt-get -y install r-base


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
RUN git clone https://github.com/data-skeptic/CausalImpact.git /srv/shiny-server
# Move files to the default location specified in `shiny-server.conf`
RUN mv /srv/shiny-server/shinyapp/* /srv/shiny-server/
COPY global.R /srv/shiny-server/


# Installing R packages
# --------------------------------------
WORKDIR "/srv/shiny-server"
RUN Rscript /srv/shiny-server/global.R


# Start shiny-server
# --------------------------------------
USER shiny

# Expose the port
# --------------------------------------
EXPOSE 3838
#CMD systemctl start shiny-server
CMD shiny-server
