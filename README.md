# cloudera-iac

This repo hold all the lifecycle steps for deploying Cloudera Hadoop cluster in VMs  
There are two main modes:

1. mode where provisioning of VMs is also part of the lifecycle steps
1. mode where VMS are already created and so this step is skipped

The governing stack: Gradle, Conda, Docker, Ansible

## modules

### ansible-conda-pack

This Gradle module is generating a Conda pack archive for Ansible which is generated inside Docker container, While the container run, Conda pack artifact is being generated and exported to local system, later to be used by Docker image for Ansible Controller.

### ansible-ctrl

This Gradle module creates Docker image for Ansible Controller

### provision

This Gradle module uses Docker Compose to spin up VMs to be later used for Cloudera Hadoop cluster

## usage

- building docker images (`:ansible-conda-pack`, `:ansible-ctrl`)
  
  ```sh
  ./gradlew clean prepare
  ```

- building only `:ansible-conda-pack` docker image and exporting intermidiate artifact

  ```sh
  ./gradlew ansible-conda-pack:clean ansible-conda-pack:docker ansible-conda-pack:dockerRun ansible-conda-pack:dockerRemoveContainer
  ```

- building only `:ansible-ctrl` docker image after `:ansible-conda-pack` artifact created already

  ```sh
  ./gradlew ansible-ctrl:clean ansible-ctrl:docker ansible-ctrl:dockerRun ansible-ctrl:dockerRemoveContainer
  ```

- provisioning of VMs using docker-compose uo

  ```sh
  ./gradlew provision:generateDockerCompose provision:dockerComposeUp
  ```

- unprovision VMs using docker-compose down

  ```sh
  ./gradlew provision:dockerComposeDown
  ```

- Running playbook

  ```sh
  ansible-playbook -i ansible_hosts git/cloudera-playbook/site.yml --extra-vars "krb5_kdc_type=none" --skip-tags krb5 --ask-vault-pass
  ```

  > NOTES:
  >
  > - cloudera_archive_authn is encrypted and set in group_vars
  > - this is applicable for a non secure cluster!

## Extra

### systemd inside Docker container

- Under WSL  
  In WSL there is no systemd and so /sys/fs/cgroup/systemd is not present.  
  This location is a dependency for running Docker container with systemd as this directory is shared with host using volume mounting.  
  In this case systemd dir needs to be created:

  ```sh
  sudo mkdir /sys/fs/cgroup/systemd/
  ```

### Useful Ad-Hoc Ansible commands

- useful link: [ansible-ad-hoc-commands](https://www.middlewareinventory.com/blog/ansible-ad-hoc-commands/)

- fact gathering

  ```sh
  # All facts
  ansible -i ansible_hosts all -m setup -v --user <user> --key-file <id_rsa_user> > details.out
  # Filtered view
  ansible -i ansible_hosts all -m setup -a 'filter=ansible_*_mb' -v --user <user> --key-file <id_rsa_user> > details.out
  ```

- sudoers rights

  ```sh
  ansible -i ansible_hosts all -m shell -a "sudo -l" -v --user <user> --key-file <id_rsa_user> > sudo.out
  ```

- test become root functionality

  ```sh
  # When sudoers is set no need for sudo password
  ansible -i ansible_hosts_1 all -m shell -a "cat /etc/passwd" -b -v --user <user> --key-file <id_rsa_user> > become.out
  # Otherwise
  ansible -i ansible_hosts_1 all -m shell -a "cat /etc/passwd" -b -K -v --user <user> --key-file <id_rsa_user> > become.out
  ```
