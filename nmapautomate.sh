#!/bin/bash
echo "Bash vestion ${BASH_VERSION}...."

# Function to display an error message and exit the script
error() {
  echo "Error: $1" >&2
  exit 1
}

echo -n "Enter the target IP addresses or hostnames (separated by a space) : "
read -a targets

# Validate the target input using a regular expression
for target in "${targets[@]}"; do
  if ! [[ $target =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    error "Invalid IP address"
  fi
done

echo -n "Enter the type of scan to perform (e.g. -sS, -sU, -sC, etc.) : "
read -r scan_type

# Validate the scan type input using a regular expression
if ! [[ $scan_type =~ ^-s[ACFSUVWYZ]$ ]]; then
  echo "Invalid scan type"
fi

echo -n "Enter any additional options or arguments (e.g. -p 80, -oA output_file, etc.) : "
read -r options

echo "Performing scans..."

# Perform a scan on each target and save the output to a text file
for target in "${targets[@]}"; do
  if ! nmap $scan_type $options $target | tee -a scan_results.txt; then
    error "Scan failed"
  fi

echo "Scan results saved in [scan_results.txt] file"
done
