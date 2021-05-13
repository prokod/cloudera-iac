# cloudera-iac

This repo hold all the lifecycle steps for deploying Cloudera Hadoop cluster in VMs  
There are two main modes:

1. mode where provisioning of VMs is also part of the lifecycle steps
1. mode where VMS are already created and so this step is skipped

The governing stack: Gradle, Conda, Docker, Ansible

## ansible-conda-pack

This Gradle module is generating a Conda pack archive for Ansible which is generated inside Docker container, While the container run, Conda pack artifact is being generated and exported to local system, later to be used by Docker image for Ansible Controller.

## ansible-ctrl

This Gradle module creates Docker image for Ansible Controller

## provision

This Gradle module uses Docker Compose to spin up VMs to be later used for Cloudera Hadoop cluster
