#!/bin/bash

# return list of all PCI DPDK devices
output="$(podman run -it --privileged --rm docker.io/spyroot/pktgen_toolbox_generic:latest dpdk-devbind.py -s)"
readarray -t pci_devices <<< "$(echo "$output" | awk '/^[0-9a-f]{4}:[0-9a-f]{2}:[0-9a-f]{2}\.[0-9a-f]/ {print $1}')"

for pci in "${pci_devices[@]}"; do
	echo "$pci"
done
