#!/bin/bash

LOAD=$(awk '{print $1}' /proc/loadavg)

if [ $(echo "$LOAD > 100" | bc) = 1 ]; then
    /etc/init.d/php-fpm restart
fi