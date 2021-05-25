## Automated ELK Stack Deployment

The files in this repository were used to configure the network depicted below.

![alt text](https://github.com/clkeiser/Project-1-Cybersecurity/blob/main/Diagrams/RedTeam%20Network%20with%20ELK%20Stack.png)

These files have been tested and used to generate a live ELK deployment on Azure. They can be used to either recreate the 
entire deployment pictured above. Alternatively, select portions of the playbook file may be used to install only certain pieces of it, such as Filebeat.

  [Install Elk](https://github.com/clkeiser/Project-1-Cybersecurity/blob/main/Ansible/install-elk.yml)
 
  [Filebeat Playbook](https://github.com/clkeiser/Project-1-Cybersecurity/blob/main/Ansible/filebeat-playbook.yml)
  
  [Metricbeat Playbook](https://github.com/clkeiser/Project-1-Cybersecurity/blob/main/Ansible/metricbeat-playbook.yml)

This document contains the following details:
- Description of the Topologu
- Access Policies
- ELK Configuration
  - Beats in Use
  - Machines Being Monitored
- How to Use the Ansible Build


### Description of the Topology

The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D*mn Vulnerable Web Application.

Load balancing ensures that the application will be highly available, in addition to restricting access to the network.
Load balancing distributes the incoming traffic to ensure that there is continued availability to the web-servers. 

What is the advantage of a Jump Box? The main advantage of a Jump-Box is to allow easy administration of many systems and to 
provide and extra layer of security.

Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the event logs and system metrics.
- Filebeat monitors specific log directories or log files, collects information and then logs the data. 
- Metricbeat collects metrics and statistics and sends them to things such as Logstash. The ouput data can then be viewed in 
  things such as Kibana. 

The configuration details of each machine may be found below.

| Name                 | Function                   | IP Address | Operating System         |
|----------------------|----------------------------|------------|--------------------------|
| Jump-Box-Provisionor | Gateway                    | 10.0.0.4   | Linux (ubuntu 18.04 LTS) |
| Web-1                | Web Server - DVWA - Docker | 10.0.0.8   | Linux (ubuntu 18.04 LTS) |
| Web-2                | Web Server - DVWA - Docker | 10.0.0.9   | Linux (ubuntu 18.04 LTS) |
| ELK-Server           | ELK Stack                  | 10.1.0.4   | Linux (ubuntu 18.04 LTS) |

### Access Policies

The machines on the internal network are not exposed to the public Internet. 

Only the Jump-Box-Provisioner machine can accept connections from the Internet. Access to this machine is only allowed from the 
following IP addresses:
`Catherine' Personal IP address`

Machines within the network can only be accessed by Jump-Box-Provisioner.
The ELK-Server is only accessible by SSH from the Jump-Box-Provisioner and through web access from Catherine' Personal IP address

A summary of the access policies in place can be found in the table below.

| Name                 | Publicly Accessible | Allowed IP Addresses |
|----------------------|---------------------|----------------------|
| Jump-Box-Provisioner | Yes                 | Personal IP          |
| Web-1                | No                  | 10.0.0.4, 10.0.0.9   |
| Web-2                | No                  | 10.0.0.4, 10.0.0.8   |
| ELK-Server           | Yes                 | 10.0.0.4, Kibana     |
| RedTeam-LB           | Yes                 | Personal IP          |

### Elk Configuration

Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which is advantageous 
because it saves time and reduces the potentional for errors.  


The playbook implements the following tasks:
- Installs docker.io, pip3 and the docker module.
```  
  - name: Install docker.io
    apt:
      update_cache: yes
      name: docker.io
      state: present

  - name: Install pip3
    apt:
      force_apt_get: yes
      name: python3-pip
      state: present

  - name: Install Docker python module
    pip:
      name: docker
      state: present
```
- Increases the virtual memory.
```
  - name: Increase Virtual Memory
    command: sysctl -w vm.max_map_count=262144

  - name: Use More Memory
    sysctl:
      name: vm.max_map_count
      value: "262144"
      state: present
      reload: yes
```
- Downloads and launches the docker ELK container.
```
  - name: download and launch a docker elk container
    docker_container:
      name: elk
      image: sebp/elk:761
      state: started
      restart_policy: always
      published_ports:
        - 5601:5601
        - 9200:9200
        - 5044:5044
```
- Enable docker to start on boot.
```
  - name: Enable docker to start on boot
    systemd:
      name: docker
      enabled: yes
```
The following screenshot displays the result of running `docker ps` after successfully configuring the ELK instance.
![alt text](https://github.com/clkeiser/Project-1-Cybersecurity/blob/main/Diagrams/Images/ELK%20running.png)

### Target Machines & Beats
This ELK server is configured to monitor the following machines:

`Web-1: 10.0.0.8`

`Web-2: 10.0.0.9`

We have installed the following Beats on these machines:
- Filebeat
- Metricbeat

These Beats allow us to collect the following information from each machine:
- Filebeat collects auth logs (/var/log/auth.log), which can be used to monitor access attempts 
- Metricbeat collects metrics related to CPU, memory and running proccessing, which can be used to optimize the computer speed and efficiency and detect any unwanted breaches.


### Using the Playbook
In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned: 

SSH into the control node and follow the steps below:
- Copy the configuration file to your webservers and ELK server.
- Update the `/etc/ansible/hosts` file to include the internal IP addresses.
```
# This is the default ansible 'hosts' file.
#
# It should live in /etc/ansible/hosts
#
#   - Comments begin with the '#' character
#   - Blank lines are ignored
#   - Groups of hosts are delimited by [header] elements
#   - You can enter hostnames or ip addresses
#   - A hostname/IP can be a member of multiple groups
# You need only a [webservers] and [elkservers] group.
# List the IP Addresses of your webservers
# You should have at least 2 IP addresses
[webservers]
10.0.0.4 ansible_python_interpreter=/usr/bin/python3
10.0.0.8 ansible_python_interpreter=/usr/bin/python3
10.0.0.9 ansible_python_interpreter=/usr/bin/python3
# List the IP address of your ELK server
# There should only be one IP address
[elk]
10.1.0.4 ansible_python_interpreter=/usr/bin/python3
```
- Run the playbook, and navigate to `http://[your.ELK-VMExternal.IP]:5601/app/kibana` to check that the installation worked as expected.
- Which file is the playbook? Where do you copy it?
  
   The playbook is [filebeat-config](https://github.com/clkeiser/Project-1-Cybersecurity/blob/main/Ansible/filebeat-config.yml)
   
   `You copy the file from /etc/ansible/files/filebeat-config.yml to /etc/ansible/files/filebeat-config.yml`

- Which file do you update to make Ansible run the playbook on a specific machine? 
  
  `Update the hosts file in /etc/ansible/hosts`

- How do I specify which machine to install the ELK server on versus which to install Filebeat on?
 
  At the beginning of the playbook you specify which hosts:
```
  ---
- name: Installing and Launch Filebeat
  hosts: webservers
  become: yes
  tasks:
  ```
- Which URL do you navigate to in order to check that the ELK server is running?

`http://[your.ELK-VMExternal.IP]:5601/app/kibana`

### Steps to set up ELK server
1. Open command prompt 
2. ssh username@Jump-BoxPrivateIP
3. sudo docker container list -a (to see what is running)
4. Locate ansible container name
5. sudo docker start (name of container)
6. `sudo docker attach (name of container)` or `sudo docker exec -it (name of container) bash` (this one will stay open even when exit so it is good if you are going back and forth between containers)
7. cd /etc/ansible
8. Update hosts file with ELK IP and change the `remote user` to your chosen one in `/etc/ansible/hosts` 
```
[elk]
10.1.0.4 ansible_python_interpreter=/usr/bin/python3
```

9. `ansible-playbook install-elk.yml` [install-ELK](https://github.com/clkeiser/Project-1-Cybersecurity/blob/main/Ansible/install-elk.yml)
10. ssh username@ELK-serverPrivateIP

### Steps to Installing filebeat
1. open command prompt
2. ssh username@Jump-BoxPrivateIP
3. ssh username@ELK-serverPrivateIP
4. `curl https://gist.githubusercontent.com/slape/5cc350109583af6cbe577bbcc0710c93/raw/eca603b72586fbe148c11f9c87bf96a63cb25760/Filebeat >> /etc/ansible/filebeat-config.yml`
5. cp etc/ansible/filebeat-config.yml /etc/filebeat/filebeat-config.yml
6. cd `/etc/filebeat/filebeat-config.yml`
7. nano or vi into [filebeat-config.yml](https://github.com/clkeiser/Project-1-Cybersecurity/blob/main/Ansible/filebeat-config.yml)
8. edit (for faster searching in nano use CTRL_W) :
```
output.elasticsearch:
hosts: ["ELKPrivateIP:9200"]
username: "elastic"
password: "changeme"
...
setup.kibana:
host: "ELKPrivateIP"
```
9. Save file
10. Create [filebeat-playbook.yml](https://github.com/clkeiser/Project-1-Cybersecurity/blob/main/Ansible/filebeat-playbook.yml)
```
---
- name: Installing and Launch Filebeat
  hosts: webservers
  become: yes
  tasks:

  - name: Download filebeat .deb file
    command: curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.4.0-amd64.deb

  - name: Install filebeat .deb
    command: dpkg -i filebeat-7.4.0-amd64.deb

  - name: Drop in filebeat.yml
    copy:
      src: /etc/ansible/filebeat-config.yml
      dest: /etc/filebeat/filebeat.yml

  - name: Enable and Configure System Module
    command: filebeat modules enable system

  - name: Setup filebeat
    command: filebeat setup

  - name: Start filebeat service
    command: service filebeat start

  - name: enable service filebeat on boot
    systemd:
      name: filebeat
      enabled: yes
```
11. ansible-playbook filebeat-playbook.yml

### Steps to Installing metricbeat
1. open command prompt
2. ssh username@Jump-BoxPrivateIP
3. ssh username@ELK-serverPrivateIP
4. `curl https://gist.githubusercontent.com/slape/58541585cc1886d2e26cd8be557ce04c/raw/0ce2c7e744c54513616966affb5e9d96f5e12f73/metricbeat >> /etc/ansible/metric-config.yml`
5. cp etc/ansible/metricbeat-config.yml /etc/metricbeat/metricbeat-config.yml
6. cd `/etc/metricbeat/metricbeat-config.yml`
7. nano or vi into [metricbeat-config.yml](https://github.com/clkeiser/Project-1-Cybersecurity/blob/main/Ansible/metricbeat-config.yml)
8. edit (for faster searching in nano use CTRL_W) :
```
output.elasticsearch:
hosts: ["ELKPrivateIP:9200"]
username: "elastic"
password: "changeme"
...
setup.kibana:
host: "ELKPrivateIP"
```
9. Save file
10. Create [metricbeat-playbook.yml](https://github.com/clkeiser/Project-1-Cybersecurity/blob/main/Ansible/metricbeat-playbook.yml)
```
---
- name: Installing and Launch Metricbeat
  hosts: webservers
  become: yes
  tasks:

  - name: Download metricbeat .deb file
    command: curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-7.4.0-amd64.deb

  - name: Install metricbeat .deb
    command: dpkg -i metricbeat-7.4.0-amd64.deb

  - name: Drop in metricbeat.yml
    copy:
      src: /etc/ansible/files/metricbeat-config.yml
      dest: /etc/metricbeat/metricbeat.yml

  - name: Enable and Configure System Module
    command: metricbeat modules enable docker

  - name: Setup metricbeat
    command: metricbeat setup

  - name: Start metricbeat service
    command: service metricbeat start

  - name: enable service metricbeat on boot
    systemd:
      name: metricbeat
      enabled: yes
```
11. ansible-playbook metricbeat-playbook.yml

