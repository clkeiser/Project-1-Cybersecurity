#!/bin/bash

# Free memory output to a free_mem.txt file
sudo free -h > ~/backups/freemem/free_mem.txt

# Disk usage output to a disk_usage.txt file
sudo du -h > ~/backups/diskuse/disk_use.txt

# List open files to a open_list.txt file
sudo lsof > ~/backups/openlist/open_list.txt

# Free disk space to a free_disk.txt file
sudo df -h > ~/backups/freedisk/free_disk.txt
