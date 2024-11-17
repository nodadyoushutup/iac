#!/bin/bash

cp clusterconfig/talosconfig $HOME/.talos/config

talhelper gencommand apply --extra-flags=--insecure | bash
