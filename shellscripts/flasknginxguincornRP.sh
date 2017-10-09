#bash!/bin/bash

#install Flask, Gunicorn and NginX on Ubuntu 14 LTS
#insall and start flask

sudo su -c "useradd newuser -s /bin/bash -m -g $PRIMARYGRP -G $MYGROUP"

sudo chpasswd << 'END'
mynewuser:password
END

adduser newuser sudo

IP=$(curl -s 'http://checkip.amazonaws.com')
sleep 5s
echo "Discovered IP"
echo "$IP"


sudo apt-get -y update
sudo apt-get install -y python python-pip python-virtualenv nginx gunicorn


git clone https://github.com/servicenowcmf/FlaskGNMongoApp.git
sleep 5s
echo "git clone complete"


sudo mkdir /home/www && cd /home/www
sudo virtualenv env
source env/bin/activate
sudo pip install Flask==0.10.1
sudo pip install pymongo
sudo mkdir flask_project && cd flask_project

sudo mv /home/ubuntu/FlaskGNMongoApp/static /home/www/flask_project
sudo mv /home/ubuntu/FlaskGNMongoApp/templates  /home/www/flask_project
sudo mv /home/ubuntu/FlaskGNMongoApp/test.py /home/www/flask_project/app.py
sudo mv /home/ubuntu/FlaskGNMongoApp/wsgi.py /home/www/flask_project


sudo sed -i '4 aplace' app.py
sudo sed -i 's|place|client = pymongo.MongoClient("mongodb://54.234.88.8")|' app.py 
sudo sed -i '6d' app.py 

sudo /etc/init.d/nginx start
sudo rm /etc/nginx/sites-enabled/default
cd /etc/nginx/sites-available
sudo touch flask_project
sudo ln -s /etc/nginx/sites-available/flask_project /etc/nginx/sites-enabled/flask_project

sudo chmod 777 flask_project
sudo printf "%s\n" 'server {' >> flask_project
sudo printf "\t%s\n" 'location / {' >> flask_project
sudo printf "\t\t%s\n" 'proxy_pass http://localhost:8000;' >> flask_project
sudo printf "\t%s\n" '}' >> flask_project
sudo printf "\t%s\n" 'location / static {' >> flask_project
sudo printf "\t\t%s\n" 'alias  /home/www/flask_project/static/;' >> flask_project
sudo printf "\t\t%s\n" '}' >> flask_project
sudo printf "\t%s\n" '}' >> flask_project
sudo printf "}" >> flask_project
sudo chmod 644 flask_project


sudo /etc/init.d/nginx restart

cd /home/www/flask_project/
gunicorn app:app -b localhost:8000

sudo apt-get install -y supervisor

cd /etc/supervisor/conf.d/
sudo touch flask_project.conf
sudo chmod 777 flask_project.conf
sudo printf "%s\n" '[program:flask_project]' >> flask_project.conf
sudo printf "%s\n" 'command = gunicorn app:app -b localhost:8000' >> flask_project.conf
sudo printf "%s\n" 'directory = /home/www/flask_project' >> flask_project.conf
sudo printf "%s\n" 'user = newuser' >> flask_project.conf
sudo chmod 644 flask_project.conf

sudo pkill gunicorn

sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl start flask_project

