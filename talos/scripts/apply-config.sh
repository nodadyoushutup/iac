#!/bin/bash

talosctl apply-config --insecure --nodes 192.168.1.200 --file clusterconfig/talos-proxmox-talos-cp-0.yaml
talosctl apply-config --insecure --nodes 192.168.1.201 --file clusterconfig/talos-proxmox-talos-cp-1.yaml
talosctl apply-config --insecure --nodes 192.168.1.202 --file clusterconfig/talos-proxmox-talos-cp-2.yaml

talosctl apply-config --insecure --nodes 192.168.1.203 --file clusterconfig/talos-proxmox-talos-wk-0.yaml
talosctl apply-config --insecure --nodes 192.168.1.204 --file clusterconfig/talos-proxmox-talos-wk-1.yaml
talosctl apply-config --insecure --nodes 192.168.1.205 --file clusterconfig/talos-proxmox-talos-wk-2.yaml
talosctl apply-config --insecure --nodes 192.168.1.206 --file clusterconfig/talos-proxmox-talos-wk-3.yaml
