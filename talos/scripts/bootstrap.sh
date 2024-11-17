#!/bin/bash



talhelper gencommand bootstrap | bash

talosctl -n 192.168.1.200 kubeconfig $HOME/.kube/config