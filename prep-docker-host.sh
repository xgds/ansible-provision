#! /bin/bash

#__BEGIN_LICENSE__
# Copyright (c) 2015, United States Government, as represented by the
# Administrator of the National Aeronautics and Space Administration.
# All rights reserved.
#
# The xGDS platform is licensed under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0.
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.
#__END_LICENSE__

# Add current user to staff group so they can write to Python package dir
# for Django migrations.  Install latest Ansible, since distributed version 
# has buggy pip module.  Then we should be ready to go...

# NOTE: This script is *not* called by Docker when building a container. It
# is for provisioning a "traditional" VM. Any changes to the config here
# that are needed for Docker setup must be mirrored in DockerfileBase!

sudo usermod -a -G staff $USER
sudo apt-add-repository -y ppa:ansible/ansible
sudo apt-add-repository -y ppa:webupd8team/java
sudo curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add -
sudo apt-add-repository https://deb.nodesource.com/node_8.x
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install ansible

# docker apt repo setup
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections

echo "Please REBOOT now (sudo /sbin/reboot).  Then run provision-xgds.sh"
