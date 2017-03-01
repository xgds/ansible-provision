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

ansible-playbook checkout-prep-only.yml -c local --inventory-file="localhost," --extra-vars "xgds_sitename='basalt' user_source_root='/home/xgds' mysql_host='localhost' mysql_user='root' db_password='xgds' django_superuser='xgds' django_superuser_password='xgds'"
