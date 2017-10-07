#!/bin/bash

#insall and start flask


sudo apt-get -y update
sudo apt-get -y install python
sudo apt-get -y install python-pip
sudo apt-get -y install python2.7-dev
sudo apt-get -y install nginx
sudo apt-get -y install git
sudo apt-get -y install crudini


pip install --upgrade pip
pip install virtualenv  
pip install flask
pip install bson
pip install gunicorn
pip install pymongo


sudo git clone https://github.com/CoolBoi567/To-Do-List---Flask-MongoDB-Example.git /
sudo mv To-Do-List---Flask-MongoDB-Example pythonmongoapp1
sudo cd /pythonmongoapp1

  # add mongo db connection url
virtualenv pythonmongoapp1env
source pythonmongoapp1env/bin/activate
deactivate

sudo cd /etc/init/
sudo touch pythonmongoapp1.conf
sudo printf "%s\n" 'description "Gunicorn application server running pythonmongoapp1"' >> pythonmongoapp1.conf
sudo printf "%s\n" 'start on runlevel [2345]' >> pythonmongoapp1.conf
sudo printf "%s\n" 'stop on runlevel [!2345]' >> pythonmongoapp1.conf
sudo printf "%s\n" 'respawn' >> pythonmongoapp1.conf
sudo printf "%s\n" 'setuid user' >> pythonmongoapp1.conf
sudo printf "%s\n" 'setgid www-data' >> pythonmongoapp1.conf
sudo printf "%s\n" 'env PATH=/home/user/pythonmongoapp1/pythonmongoapp1env/bin' >> pythonmongoapp1.conf
sudo printf "%s\n" 'cd /home/user/pythonmongoapp1' >> pythonmongoapp1.conf
sudo printf "%s\n" 'exec gunicorn --workers 3 --bind unix:pythonmongoapp1.sock -m 007 wsgi' >> pythonmongoapp1.conf

sudo start pythonmongoapp1

sudo cd /etc/nginx/sites-available
sudo touch pythonmongoapp1
sudo printf "%s\n" 'server {' >> pythonmongoapp1
sudo printf "\t%s\n" 'listen 80;' >> pythonmongoapp1
sudo printf "\t%s\n" 'server_name <IP ADDRESS>;' >> pythonmongoapp1   #Relace <IP ADDRESS>
sudo printf "\n" >> pythonmongoapp1
sudo printf "\t%s\n" 'location / {' >> pythonmongoapp1
sudo printf "\t\t%s\n" 'http://unix:pythonmongoapp1.sock;' >> pythonmongoapp1
sudo printf "%s\n" '}' >> pythonmongoapp1
sudo printf "}" >> pythonmongoapp1

sudo ln -s /etc/nginx/sites-available/pythonmongoapp1 /etc/nginx/sites-enabled

sudo nginx -t

sudo service nginx restart












