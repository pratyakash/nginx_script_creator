#!/bin/bash

TYPE=$1
URL=$2
PORT_NAME=$3
INDEX_FILE_PATH=$4

URL_ARR=(${URL//,/ })

JOINED_URL=$(IFS=' ' ; echo "${URL_ARR[*]}")

if [ -z "${INDEX_FILE_PATH}" ] ; then
	INDEX_FILE_PATH="/var/www/html"
fi

if [ "${TYPE}" == "api" ]; then
    echo "
		server { 

			listen 80; 

			root $INDEX_FILE_PATH; 

			index index.html index.htm index.nginx-debian.html; 
			

			server_name $JOINED_URL; 


			location / { 

				proxy_pass http://localhost:$PORT_NAME; 

				proxy_set_header Host \$host; 

				proxy_set_header X-Real-IP \$remote_addr; 

				proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for; 

			} 
			

		} 
    " > "/etc/nginx/sites-available/${URL_ARR[0]}"
else
    echo "
		server { 
			listen 80; 

			root $INDEX_FILE_PATH; 

			index index.html index.htm index.nginx-debian.html; 

			server_name $JOINED_URL; 


			location / { 
				try_files \$uri \$uri/ =404; 

			} 
		} 
	" > "/etc/nginx/sites-available/${URL_ARR[0]}"
fi

command ln -sf "/etc/nginx/sites-available/${URL_ARR[0]}" "/etc/nginx/sites-enabled"

command sudo systemctl restart nginx

echo "
Status =>  Successfully Created

###############################################################
Author: Pratyakash Saini
Github: https://github.com/pratyakash/nginx_script_creator.git

Please Share and Star the Repo
################################################################
"