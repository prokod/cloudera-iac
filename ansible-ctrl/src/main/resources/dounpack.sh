#!/usr/bin/env bash

do_unpack()
{
    cd /opt/conda/
    source ansible/bin/activate
    conda-unpack
}

echo "Unpack Conda packed env ..."
do_unpack
