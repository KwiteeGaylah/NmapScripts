#!/usr/bin/env python3

import subprocess

def error(message):
  print(f"Error: {message}")
  exit(1)

targets = input("Enter the target IP addresses or hostnames only (no domain names) (separated by a space): ").split()

# Validate the target input using a regular expression
import re
for target in targets:
  if not re.match(r"^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$", target):
    error("Invalid IP address")

scan_type = input("Enter the type of scan to perform (e.g. -sS, -sU, -sC, etc.): ")

# Prompt the user for additional switches/options
options = input("Enter any additional options or arguments (e.g. -p 80, -T4, -oA output_file, etc.): ")

# Prompt the user for the path to the script file
script_path = input("Enter the path to the nmap script file (leave blank to skip): ")

# If the user entered a script path, pass it as an argument to the nmap command
if script_path:
  options += f" --script {script_path}"

print("Performing scans...")

with open("scan_results.txt", "a") as f:
  for target in targets:
    output = subprocess.run(["nmap", scan_type, options, target], capture_output=True)
    if output.returncode != 0:
      error("Scan failed")
    f.write(output.stdout.decode())

print("Scans completed. Results are saved in scan_results.txt")
