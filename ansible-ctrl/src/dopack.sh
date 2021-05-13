#!/usr/bin/env bash
set -euo pipefail

version="$1"

conda env create -f ./environment.yml

# conda pack outputed to volume location (mount point)
conda pack -n @condaEnvName@ -o ./out/@condaEnvName@-${version}.tar.gz
