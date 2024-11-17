#!/bin/bash

rm -rf $HOME/.kube/config
talosctl -n 192.168.1.200 kubeconfig $HOME/.kube/config
