#!/bin/bash


SITE_NAME=$1 

if [ -z "$SITE_NAME" ]; then
	echo "Error: You must provide a website name"
	exit 1
fi

# Install Nginx

sudo apt update
sudo apt install nginx -y

#Create the site folder
sudo mkdir -p /var/www/$SITE_NAME

# Create index.html
echo "<h1>Site: $SITE_NAME</h1>" | sudo tee /var/www/$SITE_NAME/index.html

# Set Ownership
sudo chown -R $USER:www-data /var/www/$SITE_NAME

#Configure Nginx Server Block
echo "Creating Nginx configuration..."
cat <<EOF | sudo tee /etc/nginx/sites-available/$SITE_NAME
server {
	listen 80;
	listen [::]:80;

	root /var/www/$SITE_NAME;
	index index.html index.htm index.nginx-debian.html;

	server_name $SITE_NAME.local;

	location / {
		try_files \$uri \$uri/ =404;
	} 	
}	
EOF

# Enable the site (Symlink)
echo "Enabling site---"
sudo ln -s /etc/nginx/sites-available/$SITE_NAME /etc/nginx/sites-enabled/

# Restart Nginx to apply changes
echo "Restarting Nginx..."

#Completion Message
echo "Hell Yeah! $SITE_NAME is deployed."




