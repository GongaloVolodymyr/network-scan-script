#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root (using sudo)." 
  exit 1
fi

output_file="Output.log"
> $output_file

echo "Network Information Collection Script" | tee -a $output_file
echo "------------------------------------" | tee -a $output_file

echo "[+] Running nmap to scan the local network..." | tee -a $output_file
nmap -sn 192.168.0.0/24 | tee -a $output_file

echo "[+] Running tcpdump to capture 10 packets..." | tee -a $output_file
tcpdump -c 10 -i $(route get default | grep interface | awk '{print $2}') -nn -w packets.pcap 2>/dev/null
echo "tcpdump finished capturing packets. File saved as packets.pcap" | tee -a $output_file

echo "[+] Displaying a summary of tcpdump capture:" | tee -a $output_file
tcpdump -c 10 -i $(route get default | grep interface | awk '{print $2}') -nn 2>/dev/null | tee -a $output_file

echo "[+] Scan completed. Results are saved in $output_file" | tee -a $output_file

