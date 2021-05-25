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
- Catherine' Personal IP address

Machines within the network can only be accessed by Jump-Box-Provisioner.
- The ELK-Server is only accessible by SSH from the Jump-Box-Provisioner and through web access from Catherine' Personal IP address

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
- Web-1: 10.0.0.8
- Web-2: 10.0.0.9

We have installed the following Beats on these machines:
- Filebeat
- Metricbeat

These Beats allow us to collect the following information from each machine:
- _TODO: In 1-2 sentences, explain what kind of data each beat collects, and provide 1 example of what you expect to see. E.g., `Winlogbeat` collects Windows logs, which we use to track user logon events, etc._

### Using the Playbook
In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned: 

SSH into the control node and follow the steps below:
- Copy the configuration file to your webservers and ELK server. 
- Update the /etc/ansible/hosts file to include the internal IP addresses.
- Run the playbook, and navigate to http://[your.ELK-VMExternal.IP]:5601/app/kibana to check that the installation worked as expected.

_TODO: Answer the following questions to fill in the blanks:_
- _Which file is the playbook? Where do you copy it?_
- _Which file do you update to make Ansible run the playbook on a specific machine? How do I specify which machine to install the ELK server on versus which to install Filebeat on?_
- _Which URL do you navigate to in order to check that the ELK server is running?

_As a **Bonus**, provide the specific commands the user will need to run to download the playbook, update the files, etc._
