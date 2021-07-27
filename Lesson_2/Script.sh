#!/bin/bash
cd /home/user/test/
for i in {1..3}; do
        base64 /dev/urandom | head -c 10485760 >> test_$(date +%Y%m%d_%k%M%S)_$i.txt
done
rsync -avz ./ 84.252.138.1:/tmp
ssh root@84.252.138.1 "find /tmp/ -mtime +8" -delete
