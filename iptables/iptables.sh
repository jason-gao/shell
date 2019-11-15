#!/bin/bash

iptables -I INPUT -p tcp --dport 1000 -j ACCEPT

