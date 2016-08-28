#!/bin/bash
cd ~/chef-repo
sudo docker kill websrvTEST dbsrvTEST testsrvTEST;

sudo docker rm  websrvTEST dbsrvTEST testsrvTEST;
knife node delete websrvTEST -y;
knife client delete websrvTEST -y;
