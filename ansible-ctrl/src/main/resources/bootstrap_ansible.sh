#!/usr/bin/env bash

bootstrap_ansible_on_control_host() {
    echo 'Defaults:ansible !requiretty'           > /etc/sudoers.d/ansible
    echo 'ansible    ALL=(ALL)    NOPASSWD: ALL' >> /etc/sudoers.d/ansible

    chmod 440 /etc/sudoers.d/ansible
    chown root:root /etc/sudoers.d/ansible
}

echo "Bootstrap Ansible on managed host ..."

bootstrap_ansible_on_control_host
