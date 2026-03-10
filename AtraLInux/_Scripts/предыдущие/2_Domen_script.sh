#!/bin/bash

echo -n "Какой профиль будет вноситься в домен?: "
read profil_name

sudo apt install fly-admin-ad-client
sudo apt install astra-ad-sssd-client
sudo apt install fly-admin-ad-sssd-client
sudo apt autoremove
sudo apt full-upgrade
sudo astra-ad-sssd-client -d adm.local -u $profil_name

