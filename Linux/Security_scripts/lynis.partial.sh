#!/bin/bash

lynis audit system --test-from-groups malware,authentication,networking,storage,filesystems>>/tmp/lynis.partial_scan.log

