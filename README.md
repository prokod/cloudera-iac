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

### sandbox scenraio

1. building docker images
   1. build from scratch control image (`:ansible-conda-pack`, `:ansible-ctrl`)
  
      ```sh
      ./gradlew clean prepare
      ```

   1. Alternatively
      1. building first `:ansible-conda-pack` docker image and exporting intermidiate artifact

         ```sh
         ./gradlew ansible-conda-pack:clean ansible-conda-pack:docker ansible-conda-pack:dockerRun
         # If you wouldlike to remove container in the end (not recommended currently as gradle cannot keep state correctly 
         # without container exsistance)
         ./gradlew ansible-conda-pack:clean ansible-conda-pack:docker ansible-conda-pack:dockerRun ansible-conda-pack:dockerRemoveContainer
         ```

      1. and then building `:ansible-ctrl` docker image after `:ansible-conda-pack` artifact created already

         ```sh
         ./gradlew ansible-ctrl:clean ansible-ctrl:docker ansible-ctrl:dockerRun
         # If you wouldlike to remove container in the end (not recommended currently as gradle cannot keep state correctly 
         # without container exsistance)
         ./gradlew ansible-ctrl:clean ansible-ctrl:docker ansible-ctrl:dockerRun ansible-ctrl:dockerRemoveContainer
         ```

   1. building `:ansible-managed` docker image after `:ansible-ctrl` artifact created already

      ```sh
      ./gradlew ansible-managed:clean ansible-managed:docker --info
      ```

1. provisioning of VMs using docker-compose uo

   ```sh
   ./gradlew provision:generateDockerCompose provision:dockerComposeUp
   ```

1. Running playbook

   1. Attach shell to ansible-ctrl container in compose project `build`

   1. Run playbook

      ```sh
      cd ~
      ansible-playbook -i ansible_hosts.yml git/cloudera-playbook/site.yml --extra-vars "krb5_kdc_type=none" --skip-tags krb5 --ask-vault-pass
      ```

      > NOTES:
      >
      > - cloudera_archive_authn is encrypted and set in group_vars
      > - this is applicable for a non secure cluster!

1. unprovision VMs using docker-compose down

   ```sh
   ./gradlew provision:dockerComposeDown
   ```

### private cloud/bare metal scenraio

1. building docker images
   1. build from scratch control image (`:ansible-conda-pack`, `:ansible-ctrl`)
  
      ```sh
      ./gradlew clean prepare
      ```

   1. Alternatively
      1. building first `:ansible-conda-pack` docker image and exporting intermidiate artifact

         ```sh
         ./gradlew ansible-conda-pack:clean ansible-conda-pack:docker ansible-conda-pack:dockerRun
         # If you wouldlike to remove container in the end (not recommended currently as gradle cannot keep state correctly 
         # without container exsistance)
         ./gradlew ansible-conda-pack:clean ansible-conda-pack:docker ansible-conda-pack:dockerRun ansible-conda-pack:dockerRemoveContainer
         ```

      1. and then building `:ansible-ctrl` docker image after `:ansible-conda-pack` artifact created already

         ```sh
         ./gradlew ansible-ctrl:clean ansible-ctrl:docker ansible-ctrl:dockerRun
         # If you wouldlike to remove container in the end (not recommended currently as gradle cannot keep state correctly 
         # without container exsistance)
         ./gradlew ansible-ctrl:clean ansible-ctrl:docker ansible-ctrl:dockerRun ansible-ctrl:dockerRemoveContainer
         ```

1. provisioning of ansible-ctrl VM using docker-compose uo

   ```sh
   ./gradlew provision:priv-cloud:generateDockerCompose provision:priv-cloud:dockerComposeUp
   ```

1. Running playbook

   1. Attach shell to ansible-ctrl container in compose project `build`

   1. Ensure `build` subnet can reach target hosts in priv-cloud

   1. decrypt pk file for ssh communication

      ```sh
      cd ~
      .local/bin/decrypt_pk.sh
      ```

   1. Run playbook

      ```sh
      cd ~
      ansible-playbook -i ansible_hosts.yml git/cloudera-playbook/site.yml --extra-vars "krb5_kdc_type=none" --skip-tags krb5 --ask-vault-pass --private-key private_key.txt
      ```

      > NOTES:
      >
      > - this is applicable for a non secure cluster!

### ansible-vault

- creating encrypted variable string value

  ```sh
  ansible-vault encrypt_string --vault-id dev@prompt 'foobar' --name 'variable_name'
  ```

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
