#!/bin/bash

name='The Best Script Ever'

echo "Title: $name" >>~/research/sys_info.txt
echo "Today is `date`">> ~/research/sys_info.txt
echo " " >> ~/research/sys_info.txt
echo "Username: $USER" >> ~/research/sys_info.txt
echo "IP Address: " >> ~/research/sys_info.txt
hostname -I |awk -F" " '{print $2}' >> ~/research/sys_info.txt
echo " " >> ~/research/sys_info.txt
mkdir ~/research
echo "This shows the executable files:" >> ~/research/sys_info.txt
sudo find /home -type f -perm 777 >> ~/research/sys_info.txt
echo " " >> ~/research/sys_info.txt
echo "These are the top 10 processes on my machine:" >> ~/research/sys_info.txt
ps aux --sort -%mem | awk {'print $1, $2, $3, $4, $11'} |head >> ~/research/sys_info.txt
