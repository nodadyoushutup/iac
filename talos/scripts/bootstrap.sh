#!/bin/bash

cp clusterconfig/talosconfig $HOME/.talos/config

# talosctl bootstrap -n 192.168.1.200
talosctl -n 192.168.1.200 kubeconfig $HOME/.kube/config
