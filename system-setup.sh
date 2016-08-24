#!/usr/bin/bash

sudo dnf install \
    git i3 vim-enhanced \
    gcc redhat-rpm-config \
    python-devel python-pip \
    strace gdb \
    htop iftop iptraf-ng

pip install -U --user pip
pip install -U --user python-openstackclient virtualenv
