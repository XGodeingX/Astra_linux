#!/bin/bash

chmod +x ./install_gui.sh
sudo apt-get install whiptail
sudo ./install_gui.sh

sudo dpkg cprocsp-pki-cades-64_2.0.14892-1_amd64.deb
sudo dpkg cprocsp-pki-phpcades_2.0.14892-1_all.deb
sudo dpkg cprocsp-pki-plugin-64_2.0.14892-1_amd64.deb
