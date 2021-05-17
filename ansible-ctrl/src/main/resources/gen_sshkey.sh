#!/usr/bin/env bash

gen_ssh_keys() {
    mkdir .ssh
    cd .ssh
    ssh-keygen -t rsa -q -f "id_rsa" -N ""
    cp id_rsa.pub authorized_keys
    # Copy is_rsa is artifact to shared volume
    cd ..
    chmod -R 700 .ssh
}

echo "Generate ssh keys in $PWD ..."

gen_ssh_keys
