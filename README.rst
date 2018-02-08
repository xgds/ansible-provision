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

Generic provising for a new xGDS instance with Ansible under Ubuntu 16.04 LTS (other releases my work, but are untested).  You should be able to get xGDS running as follows:

- install an out-of-box server instance with remote ssh access and git packages installed via apt-get (or as part of initial installation).

- Check this repository out of github.

- cd *ansible-provision*

- run: *prep-provisioning.sh*

- **reboot**: *sudo /sbin/reboot*

- run: *provision-xgds.sh*

Building a docker image:

- docker-setup/Dockerfile gets the base ubuntu packages, pip and node packages gets xgds code and setup.
- docker-setup/DockerfileBase just gets the base ubutntu packages, pip and node packages
- docker-setup/DockerfileCheckoutPrep does the xgds code pull and setup

Run these commands in the docker-setup directory to provision the docker instance,
replace yoursitename with the name of the site you are building (ie subsea)
replace todaysdate with today's date, ie 20180604
replace yourdockerimagename with the name of the docker image you are building, for example xgds-subsea

'''
docker build -f DockerfileBase -t xgds-base:todaysdate --squash --compress --build-arg XGDS_SITENAME=yoursitename .
docker build -f DockerfileCheckoutPrep --compress --squash -t yourdockerimagename --build-arg XGDS_SITENAME=yoursitename --build-arg BASE_IMAGE_TAG=todaysdate.
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

