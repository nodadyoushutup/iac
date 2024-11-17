#!/bin/bash

talhelper genconfig

rm -rf $HOME/.talos/config
cp clusterconfig/talosconfig $HOME/.talos/config

talhelper gencommand apply --extra-flags=--insecure | bash
