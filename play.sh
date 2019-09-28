#!/usr/bin/env bash
HERE=$(pwd)
ansible-playbook -i "$HERE"/inventory/hosts.ini --vault-password-file="$HERE"/.vaultpw -K main.yml
