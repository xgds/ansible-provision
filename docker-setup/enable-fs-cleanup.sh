#!/bin/bash

cd ~/Library/Containers/com.docker.docker/Data/database/
git checkout master
git reset --hard
mkdir -p com.docker.driver.amd64-linux/disk
echo 262144 > com.docker.driver.amd64-linux/disk/compact-after
echo 262144 > com.docker.driver.amd64-linux/disk/keep-erased
echo -n true > com.docker.driver.amd64-linux/disk/trim
#echo -n 'tcp:9090' > com.docker.driver.amd64-linux/disk/stats
git add com.docker.driver.amd64-linux/disk/compact-after 
git add com.docker.driver.amd64-linux/disk/keep-erased 
git add com.docker.driver.amd64-linux/disk/trim 
#git add com.docker.driver.amd64-linux/disk/stats
git commit -s -m 'Enable on-line compaction'
