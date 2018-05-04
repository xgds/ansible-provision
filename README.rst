.. __BEGIN_LICENSE__
..  Copyright (c) 2015, United States Government, as represented by the
..  Administrator of the National Aeronautics and Space Administration.
..  All rights reserved.
.. 
..  The xGDS platform is licensed under the Apache License, Version 2.0
..  (the "License"); you may not use this file except in compliance with the License.
..  You may obtain a copy of the License at
..  http://www.apache.org/licenses/LICENSE-2.0.
.. 
..  Unless required by applicable law or agreed to in writing, software distributed
..  under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
..  CONDITIONS OF ANY KIND, either express or implied. See the License for the
..  specific language governing permissions and limitations under the License.
.. __END_LICENSE__

Generic provising for a new xGDS instance with Ansible under Ubuntu 16.04 LTS (other releases my work, but are untested).
First you need a virtual machine within which to provision xGDS.  For Docker usage, see the docker-setup directory,
specifically DockerfileBase to build a base image, and DockerfileCheckoutPrep for an xGDS configured Docker image.

You should be able to get xGDS running as follows:

- install an out-of-box server instance with remote ssh access and git packages installed via apt-get (or as part of initial installation).

- Check this repository out of github.

- cd *ansible-provision*

- run: *prep-provisioning.sh*

- **reboot**: *sudo /sbin/reboot*

- run: *provision-xgds.sh*

Building a docker image:

- **To build a new generic docker image**:  tagname should be something like xgds-base:todaysdate ie xgds-base:20180329
   - cd docker-setup
   - docker build --build-arg XGDS_SITENAME=yoursitename --build-arg XGDS_BING_MAP_KEY=yourbingmapskey -t tagname --squash --compress -f ./DockerfileBase .

- **To build a new docker image for a specific xgds**, you must have that already created as a repository.  basetagname is the tagname from your generic docker image
tagname is the name for your new complete image, ie xgds-yoursitename:todaysdate ie xgds-demo:20180329:
   - follow instructions to create a repository: https://github.com/xgds/xgds_baseline/blob/master/README.md
   - docker build --build-arg BASE_IMAGE_TAG=basetagname --build-arg XGDS_SITENAME=yoursitename --build-arg XGDS_BING_MAP_KEY=yourbingmapskey -t tagname --squash --compress -f ./DockerfileCheckoutPrep .
   - docker create -v /var -v /home/xgds -v /etc -v /usr/local --name yoursitename-data-store xgds-yoursitename:tagname /bin/true

- **To run the new complete container**, tagname is the name for your new complete image. $1=path to codebase on your laptop.  $2=path to xgds_3dview code on your laptop if you have it do:
   - docker run -t -d -v $1:/home/xgds/xgds_yoursitename -v $2:/home/xgds/xgds_3dview --volumes-from yoursitename-data-store --name yoursitename-container -p 80:80 -p 3306:3306 -p 7500:7500  -p 222:22 -p 443:443 -p 3001:3001 -p 5000:5000 -p 5984:5984 -p 8080:8080 -p 8181:8181 -p 9090:9090 -p 9191:9191 tagname

- To get into the new container after it's running, do:
   - ssh -p 222 xgds@localhost



- docker-setup/Dockerfile gets the base ubuntu packages, pip and node packages gets xgds code and setup.
- docker-setup/DockerfileBase just gets the base ubutntu packages, pip and node packages
- docker-setup/DockerfileCheckoutPrep does the xgds code pull and setup

Run these commands in the docker-setup directory to provision the docker instance,
replace yoursitename with the name of the site you are building (ie subsea)
replace todaysdate with today's date, ie 20180604
replace yourdockerimagename with the name of the docker image you are building, for example xgds-subsea

'''
docker build -f DockerfileBase -t xgds-base:todaysdate --squash --compress --build-arg XGDS_SITENAME=yoursitename .
docker build -f DockerfileCheckoutPrep --compress --squash -t yourdockerimagename --build-arg XGDS_SITENAME=yoursitename --build-arg BASE_IMAGE_TAG=todaysdate .
'''

In case you have a different url for your git repository and different username, password and if it doesn't end with .git (GIT_SUFFIX DEFAULTS TO .git), do like this:
'''
docker build -f DockerfileCheckoutPrep --compress --squash -t yourdockerimagename --build-arg GIT_USER=yourgituser --build-arg GIT_PASSWORD=yourgitpassword --build-arg GIT_SUFFIX=yourgitsuffix --build-arg XGDS_SITENAME=yoursitename --build-arg BASE_IMAGE_TAG=todaysdate .
'''

Run this command from outside to save the new image:

'''
docker ps -a  # get the id of the container you are running
docker commit <containerID> xgds-basalt
docker save -o xgds_basalt_docker.tar xgds-basalt
bzip2 xgds_basalt_docker.tar
'''

For xgds usage, scp it to daikon here:
/Library/Server/Web/Data/Sites/Default/downloads


Status as of 6/6/17:  Has been tested with xgds_basalt and xgds_rp.  Provisions server with SSL / development certs and has scripts for docker provisioning.

