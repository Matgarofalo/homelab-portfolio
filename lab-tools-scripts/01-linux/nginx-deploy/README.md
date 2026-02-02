# Nginx Auto-Deployer

A Bash script to automate the deployment of static websites on an Nginx web server. This tool streamlines the process of provisioning directories, setting permissions, and generating server block configurations.

## Description
Manually setting up Nginx virtual hosts is repetitive and prone to errors. This script automates the entire lifecycle of a static site deployment:
1.  Provisions the directory structure in `/var/www/`.
2.  Generates a placeholder `index.html`.
3.  Assigns correct ownership and permissions (`www-data`).
4.  Generates and writes the Nginx server block configuration.
5.  Enables the site via symlink and restarts the Nginx service.

## Prerequisites
* Ubuntu/Debian-based Linux server.
* Sudo privileges on the host machine.

## Usage
1.  Make the script executable:
    ```bash
    chmod +x deploy-web.sh
    ```

2.  Run the script followed by your desired website name:
    ```bash
    ./deploy-web.sh my-website
    ```

3.  The script will:
    * Install/Update Nginx.
    * Deploy the site to `/var/www/my-website`.
    * Configure Nginx to listen for `my-website.local`.
    * Restart the service.

## Note
After deployment, ensure you update your local `/etc/hosts` file to map the server's IP address to the new domain name (e.g., `192.168.1.16 my-website.local`).
