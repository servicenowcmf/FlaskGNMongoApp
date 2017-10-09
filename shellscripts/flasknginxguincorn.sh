#bash!/bin/bash

#install Flask, Gunicorn and NginX on Ubuntu 14 LTS
#insall and start flask

IP=$(curl -s 'http://checkip.amazonaws.com')
sleep 5s
echo "Discovered IP"
echo "$IP"


sudo apt-get -y update
sudo apt-get -y install python
sudo apt-get -y install python-pip
sudo apt-get -y install python2.7-dev
sudo apt-get -y install nginx
sudo apt-get -y install git-core
sudo apt-get -y install crudini
sudo apt-get -y install supervisor
sudo apt-get -y install python-virtualenv
sudo pip install --upgrade pip


git clone https://github.com/servicenowcmf/FlaskGNMongoApp.git
sleep 5s
echo "git clone complete"


cd FlaskGNMongoApp
virtualenv test
cd test
source test/bin/activate
sudo pip install flask
sudo pip install bson
sudo pip install gunicorn
sudo pip install pymongo
cd ..
sudo mv static test
sudo mv templates test
sudo mv test.py test
sudo mv wsgi.py test
deactivate 

cd test
sudo sed -i '4 aplace' test.py
sudo sed -i 's|place|client = pymongo.MongoClient("mongodb://54.234.88.8")|' test.py 
sudo sed -i '6d' test.py 


cd /etc/nginx/sites-available
sudo touch test.conf
sudo chmod 777 test.conf
sudo printf "%s\n" 'server {' >> test.conf
sudo printf "\t%s\n" 'listen 80;' >> test.conf
sudo echo -e '\t'"server_name  $IP;"  >> test.conf   #Relace <IP ADDRESS>
sudo printf "\t%s\n" 'root /home/ubuntu/FlaskGNMongoApp/test;' >> test.conf
sudo printf "\t%s\n" 'access_log /home/ubuntu/FlaskGNMongoApp/test/access.log;' >> test.conf
sudo printf "\t%s\n" 'error_log /home/ubuntu/FlaskGNMongoApp/test/error.log;' >> test.conf
sudo printf "\n" >> test.conf
sudo printf "\t%s\n" 'location / {' >> test.conf
sudo printf "\t\t%s\n" 'proxy_set_header X-Forward-For $proxy_add_x_forwarded_for;' >> test.conf
sudo printf "\t\t%s\n" 'proxy_set_header Host $http_host;' >> test.conf
sudo printf "\t\t%s\n" 'proxy_redirect off;' >> test.conf
sudo printf "\t\t%s\n" 'if (!-f $request_filename) {' >> test.conf
sudo printf "\t\t\t%s\n" 'proxy_pass http://127.0.0.1:8000;' >> test.conf
sudo printf "\t\t\t%s\n" 'break;' >> test.conf
sudo printf "\t\t%s\n" '}' >> test.conf
sudo printf "\t%s\n" '}' >> test.conf
sudo printf "}" >> test.conf
sudo chmod 644 test.conf


sudo ln -s /etc/nginx/sites-available/test.conf /etc/nginx/sites-enabled

sudo nginx -t

sudo service nginx reload












