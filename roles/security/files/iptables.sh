#!/bin/bash

###[ Config ]###

LOGLIMIT=20
IPTABLES=/usr/sbin/iptables
IP6TABLES=/usr/sbin/ip6tables


###[ CLEANUP RULE ]###

echo "Deleting old rules"
$IPTABLES -F
$IPTABLES -t nat -F
$IP6TABLES -F


###[ CREATING NEW CHAINS ]###

echo "Creating chains"

# Chain to log and reject a port by ICMP port unreachable
$IPTABLES -N LOGREJECT
$IPTABLES -A LOGREJECT -m limit --limit $LOGLIMIT/minute -j LOG --log-prefix "FIREWALL REJECT " --log-level notice --log-ip-options --log-tcp-options
$IPTABLES -A LOGREJECT -j REJECT --reject-with icmp-port-unreachable


###[ MAIN PART ]###

echo "Setting default policy DROP"
$IPTABLES -P INPUT DROP
$IPTABLES -P FORWARD DROP
$IPTABLES -P OUTPUT ACCEPT
$IP6TABLES -P INPUT DROP
$IP6TABLES -P FORWARD DROP
$IP6TABLES -P OUTPUT ACCEPT

echo "Be stateful"
$IPTABLES -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
$IPTABLES -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
$IPTABLES -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

echo "Trust loopback"
$IPTABLES -A INPUT -i lo -j ACCEPT
$IP6TABLES -A INPUT -i lo -j ACCEPT

$IPTABLES -A INPUT -i tap0 -j ACCEPT

echo "Allow ICMP"
$IPTABLES -A INPUT -p icmp -j ACCEPT

echo "Allow SSH"
$IPTABLES -A INPUT -p tcp --dport 22 -j ACCEPT

echo "Reject and log all other packets"
$IPTABLES -A INPUT -p tcp --syn -j LOGREJECT
$IPTABLES -A FORWARD -p tcp --syn -j LOGREJECT
