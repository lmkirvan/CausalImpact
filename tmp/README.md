# How to Run CausalImpact as a Shiny Server on Ubuntu 16.04

1. create a new ubuntu 16.04 server installation
2. create a new user called `shiny` with sudo privileges:
  `sudo adduser shiny`
  `sudo usermod -aG sudo shiny`

3. Download the contents of this repo to a directory in the shiny user's home folder (SSH or other method)

4. Install docker `sudo apt-get install docker`

5. Create an account on dockerhub if not already registered.

6. Pull the docker ubuntu xenial image: `sudo docker pull ubuntu:16.04`

5. Then from the directory containing the repo contents run:

`sudo docker build -t shiny/causalimpact:v1 .`
`sudo docker run -d shiny/causalimpact:v1`

Now the shiny server should be accessible at http://ip.adress.of.server:3838

Note that you will need to make sure port 3838 is open for incoming connections, or potentially put in place an IP mask if you want to restrict access.
