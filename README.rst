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

- install an out-of-box server instance with only remote ssh access and git installed.

- Check this repository out of github.

- cd *ansible-provision*

- run: *provision-xgds.sh*

Status as of 2/24/17: Has been tested only with xgds_basalt.  Provisions only a server w/o SSL and does not yet have scripts for docker provisioning.
