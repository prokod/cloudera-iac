#!/usr/bin/env bash

bootstrap_ansible_on_managed_host() {
    getent group  ansible || groupadd -r -f -g 4001 ansible
    getent passwd ansible || useradd  -r -u 4001 -g ansible -s /bin/bash -c 'Automated installation' -d /home/ansible ansible -p '!!' -m

    echo 'Defaults:ansible !requiretty'           > /etc/sudoers.d/ansible
    echo 'ansible    ALL=(ALL)    NOPASSWD: ALL' >> /etc/sudoers.d/ansible

    chmod 440 /etc/sudoers.d/ansible
    chown root:root /etc/sudoers.d/ansible

    mkdir -p  ~ansible/.ssh
    chmod 700 ~ansible/.ssh

    #echo 'from="127.0.0.1",no-agent-forwarding,no-port-forwarding ssh-rsa jenkins-egress-docker-worker' > /home/ansible/.ssh/authorized_keys
    cp /tmp/id_rsa.pub /home/ansible/.ssh/authorized_keys

    chmod 640 ~ansible/.ssh/authorized_keys
    chown -R ansible:ansible ~ansible
}

echo "Bootstrap Ansible on managed host ..."

bootstrap_ansible_on_managed_host
