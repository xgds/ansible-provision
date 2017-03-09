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

# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/baseimage:0.9.19

# Setup variable for Bing Map key if we have one
ARG XGDS_BING_MAP_KEY=""

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Create xgds user with password set to xgds.  You can change to your
# favorite username, by editing the next 4 lines.
RUN adduser --disabled-password --gecos 'xGDS,,,' xgds
RUN usermod -a -G sudo xgds
RUN usermod -a -G staff xgds
RUN /bin/bash -c "echo "xgds:xgds" | chpasswd"

# Set up ssh.  We assume installer has an RSA public key in ~/.ssh/id_rsa.pub
# UPDATE 3/7/17: don't copy ssh key since everyone is different.  Use
# password for initial login - user can copy key later if desired.
RUN rm -f /etc/service/sshd/down
#COPY id_rsa.pub /tmp/your_key.pub
RUN mkdir -p /home/xgds/.ssh
#RUN cat /tmp/your_key.pub >> /home/xgds/.ssh/authorized_keys && rm -f /tmp/your_key.pub

# Install latest ansible in container for xGDS setup
RUN apt-add-repository -y ppa:ansible/ansible
RUN apt-get -y update
RUN apt-get -y install git
RUN apt-get -y install sudo
RUN apt-get -y install ansible

RUN touch /home/xgds/.dockersetup

# Allow sudo w/o password so Ansible setup will work
RUN sed -i "s|%sudo\tALL=(ALL:ALL) ALL|%sudo\tALL= NOPASSWD:ALL|g" /etc/sudoers

# Set up volumes for databases and source tree
#VOLUME /var/lib/mysql
#VOLUME /var/lib/couchdb
#VOLUME /home/xgds/xgds_basalt

# Add service definitions for container
RUN mkdir /etc/service/mysql
ADD run-mysql.sh /etc/service/mysql/run

RUN mkdir /etc/service/couchdb
ADD run-couchdb.sh /etc/service/couchdb/run

RUN mkdir /etc/service/apache
ADD run-apache.sh /etc/service/apache/run

ENV TERM xterm-color
ENV LANG en_US.utf8
USER xgds
# Now run Ansible to provision xGDS stuff
RUN cd /home/xgds && git clone https://github.com/xgds/ansible-provision && cd ansible-provision && ansible-playbook -vvv xgds-setup.yml -c local --inventory-file="localhost," --extra-vars "xgds_sitename='basalt' user_source_root='/home/xgds' mysql_host='localhost' mysql_user='root' bing_maps_api_key='${XGDS_BING_MAP_KEY}' db_password='xgds' django_superuser='xgds' django_superuser_password='xgds'"

USER root
# Be sure container_environment scripts are readable by all so locale is setup correctly
RUN chmod a+rX /etc/container_environment*
RUN sed -i "s|TERM=xterm|TERM=xterm-color|g" /etc/container_environment.sh

RUN chown -R xgds:xgds /home/xgds
RUN chown -R xgds:www-data /home/xgds/xgds_basalt/data
RUN chmod -R g+rwX /home/xgds/xgds_basalt/data

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
