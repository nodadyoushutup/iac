#!/bin/bash

cp clusterconfig/talosconfig $HOME/.talos/config

talhelper gencommand bootstrap | bash