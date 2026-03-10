#!/bin/bash
dpkg --list | grep linux
sudo apt-mark hold linux-6.1-generic linux-astra-modules-6.1.90-1-generic linux-headers-6.1-genericlinux-headers-6.1.90-1linux-headers-6.1.90-1-generic  linux-image-6.1-generic linux-image-6.1.90-1-generic
apt-mark showhold