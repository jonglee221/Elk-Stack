## Automated ELK Stack Deployment

The files in this repository were used to configure the network depicted below.

![diagram](Diagrams/Elk_Map.png)

These files have been tested and used to generate a live ELK deployment on Azure. They can be used to either recreate the entire deployment pictured above. Alternatively, select portions of the YML file may be used to install only certain pieces of it, such as Filebeat.

 - [Elk playbook](./Ansible/elkplaybook.yml)
 - [Filebeat playbook](./Ansible/filebeat-playbook.yml)
 - [Metricbeat playbook](./Ansible/metricbeat-playbook.yml)

This document contains the following details:
- Description of the Topology
- Access Policies
- ELK Configuration
  - Beats in Use
  - Machines Being Monitored
- How to Use the Ansible Build


### Description of the Topology

The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D*mn Vulnerable Web Application.

Load balancing ensures that the application will be highly available, in addition to restricting access to the network. Load balancers ensure environment avaibility through the distribution of incoming data to web servers. Jump boxes allow for easier administration of multiple systems. They also help protect the system by adding an additional layer between the outside and internal assets.

Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the event logs and system metrics.
- Filebeat watches for log directories or specific log files.
- Metricbeat records metrics from the system and services running on the server.

The configuration details of each machine may be found below.

| Name       | Function   | IP address | Operating System (OS) |
|------------|------------|------------|-----------------------|
| Jump Box   | Gateway    | 10.1.0.4   | Linux                 |
| Web-1      | Server     | 10.1.0.5   | Linux                 |
| Web-2      | Server     | 10.1.0.6   | Linux                 |
| ELK Server | Log Server | 10.0.0.4   | Linux                 |

### Access Policies

The machines on the internal network are not exposed to the public Internet. 

Only the jump box provisioner machine can accept connections from the Internet. Access to this machine is only allowed from the following IP addresses:
- 65.36.90.219

Machines within the network can only be accessed by Jump Box.
ELK Machine can access from personal IP through port 5601 only.

A summary of the access policies in place can be found in the table below.

| Name          | Publicly Accessible | Allowed IP Addresses       |
|---------------|---------------------|----------------------------|
| Jump Box      | YES                 | Personal IP (65.36.90.219) |
| Load Balancer | YES                 | OPEN                       |
| Web-1         | NO                  | 10.1.0.5                   |
| Web-2         | NO                  | 10.1.0.6                   |
| ELK Server    | YES                 | Personal IP (65.36.90.219) |

### Elk Configuration

Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which is advantageous because services running can be limited, system updates/installations can be streamlines, and processes become more replicable.

The playbook implements the following tasks:
- Installation of docker.io, pip3, and the docker module: 
![Docker Output](Images/Docker.io.png)
- Use of Sysctl: 
![Sysctl](Images/Systemctl.png)
- Docker download and launch for Elk Server:
![Elk Server](Images/Launch-Docker.png)

The following screenshot displays the result of running `docker ps` after successfully configuring the ELK instance.

![docker ps output](Images/Docker-PS.png)

### Target Machines & Beats
This ELK server is configured to monitor the following machines:
- Web-1: 10.1.0.5
- Web-2: 10.1.0.6

We have installed the following Beats on these machines:
- Filebeat
- MetricBeat

These Beats allow us to collect the following information from each machine:
- Filebeat monitors log files or directories, tailes the files and forwards them to Elasticserach or Logstash for indexing. In this way, Filebeat is a log data shipper for local files. Logs produced from the MySQL database that supports the application would be an example.
- Metricbeat gathers statistics and metrics on the system. It can monitor things like system health through CPU usage data. It also gauge memory usage, disk usuage, inbound traffic, etc.

### Using the Playbook
In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned: 

SSH into the control node and follow the steps below:
- Copy the configuration file to Web VMs.
- Update the /etc/ansible/hosts file to include IP of webservers and Elk Server VM.
- Run the playbook, and navigate to http://40.86.102.129:5601/app/kibana to check that the installation worked as expected.
- Which file is the playbook? Where do you copy it? Filebeat-Configuration
- Which file do you update to make Ansible run the playbook on a specific machine? How do I specify which machine to install the ELK server on versus which to install Filebeat on? Update filebeat-config.yml. To specify which machine to install, you must update the host files with IP address of web and elk servers and specifying which group to run on in ansible.
- Which URL do you navigate to in order to check that the ELK server is running? http://40.86.102.129:5601/app/kibana

filebeats playbook:
```bash
---
- name: Installing and Launch Filebeat
  hosts: webservers
  become: yes
  tasks:
    # Use command module
  - name: Download filebeat .deb file
    command: curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat->

    # Use command module
  - name: Install filebeat .deb
    command: dpkg -i filebeat-7.4.0-amd64.deb

    # Use copy module
  - name: Drop in filebeat.yml
    copy:
      src: /etc/ansible/files/filebeat-config.yml
      dest: /etc/filebeat/filebeat.yml

    # Use command module
  - name: Enable and Configure System Module
    command: filebeat modules enable system

    # Use command module
  - name: Setup filebeat
    command: filebeat setup

    # Use command module
  - name: Start filebeat service
    command: service filebeat start

    # Use systemd module
  - name: Enable service filebeat on boot
    systemd:
      name: filebeat
      enabled: yes
```


Metricbeat playbook:
```bash
---
- name: Installing and Launch Metricbeat
  hosts: webservers
  become: true
  tasks:
    # Use command module
  - name: Download filebeat .deb file
    command: curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricb>

    # Use command module
  - name: Install metricbeat .deb
    command: dpkg -i metricbeat-7.6.1-amd64.deb

    # Use copy module
  - name: Drop in metricbeat.yml
    copy:
      src: /etc/ansible/metricbeat-config.yml
      dest: /etc/metricbeat/metricbeat.yml

    # Use command module
  - name: Enable and Configure System Module
    command: metricbeat modules enable system

    # Use command module
  - name: Setup metricbeat
    command: metricbeat setup

    # Use command module
  - name: Start metricbeat service
    command: service metricbeat start
```
