# Project: Enterprise Helpdesk Deployment (osTicket)

**Date:** 01/17/26

## 1. Project Overview
**Objective:** Deploy a self-hosted ticketing system to simulate an enterprise IT support environment and document home lab projects.


## 2. Technical Stack (LAMP)
* **OS:** Ubuntu Server 24.04 LTS (Virtual Machine via Proxmox)
* **Web Server:** Apache2
* **Database:** MariaDB
* **Language:** PHP 8.3
* **Application:** osTicket v1.18.1

## 3. Network Configuration
* **Hostname:** SRV-TICKET
* **IP Address:** Static (192.168.1.15)
* **DNS:** Local resolution configured via host file / mDNS.

## 4. Installation Highlights
* **User Management:** Created a dedicated SQL user (`osticket_user`) for security segregation, rather than using root.
* **Permissions:** Adjusted ownership (`chown www-data`) and file permissions (`chmod 755`) to allow the web server to access application files securely.
* **Security:** Removed the `/setup` directory and locked `ost-config.php` (chmod 0644) immediately post-installation.

## 5. Configuration & Customization
To customize my osTicket for a home lab log, I implemented the following:
* **SLA Logic:** Created a "Sev 1 - Critical" policy (2-hour resolution) triggering on specific Help Topics like "System Outage."
* **Departments:** Segregated "SysAdmins" (Private) from general "Support."
* **Custom Forms:** Built a "Lab Project Journal" form to capture structured data (Tools Used, GitHub Links, along with general projects and changes) for future documentation.

## 6. Troubleshooting & Challenges
* **Issue:** PHP Upload Limits.
    * *Symptom:* "File Upload Error #1" when uploading the company logo.
    * *Solution:* Modified `/etc/php/8.3/apache2/php.ini` to increase `upload_max_filesize` and `post_max_size` from 2M to 20M.
* **Issue:** Database Access Denied.
    * *Symptom:* Installer crashed with `mysqli_sql_exception`.
    * *Root Cause:* Password mismatch between MariaDB user creation and Installer input.
    * *Solution:* Manually reset the SQL user password via CLI (`ALTER USER...`) to resolve the conflict.




