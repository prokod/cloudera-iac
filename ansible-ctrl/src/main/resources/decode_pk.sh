#!/usr/bin/env bash

decode() {
     ansible localhost --connection local -m copy -a "src=./private_key.vault dest=./private_key.txt mode=0600 owner=$(id -u -n)" --ask-vault-pass
}

echo "Decoding ssh private key to be used later as parameter --key-file (ansible) value ..."

decode
