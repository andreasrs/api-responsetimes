#!/bin/bash
echo "15000 61000" > /proc/sys/net/ipv4/ip_local_port_range
echo "60" > /proc/sys/net/ipv4/tcp_fin_timeout
