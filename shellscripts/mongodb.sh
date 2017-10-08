#!/bin/bash

#install mongodb on Ubuntu 14 LTS

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
sudo echo "deb [ arch=amd64 ] http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
sudo apt-get update
sudo apt-get install -y mongodb-org
sudo apt-get -y install crudini

#opens up the mongodb to all ip's insecure without security turned on, but ok for test
sudo sed -i -e  "s/bindIp/# bindIp/g" /etc/mongod.conf

# secure the mongodb later if needed
# sudo sed -i "/security/a  \\     authorization: 'enabled'" /etc/mongod.conf

sudo service mongod start

# code to create a mongo user 
# sudo mongo --eval "db.createUser( { user:'clouddev' , pwd:'password'} ]})"

sudo apt-get -y install git-core
sudo service mongod restart

