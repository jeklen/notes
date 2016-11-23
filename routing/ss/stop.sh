#!/bin/bash
sudo iptables -t nat -D OUTPUT 6
sudo iptables -t nat -D OUTPUT 5
sudo iptables -t nat -D OUTPUT 4
sudo iptables -t nat -D OUTPUT 3
sudo iptables -t nat -D OUTPUT 2
sudo iptables -t nat -D OUTPUT 1
