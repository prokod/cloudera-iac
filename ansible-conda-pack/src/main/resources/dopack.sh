#!/usr/bin/env bash
set -euo pipefail

version="${1:-$IMG_VERSION}"

conda env create -f ./environment.yml

# conda pack outputed to volume location (mount point)
conda pack -n @condaEnvName@ -o ./out/@condaEnvName@-${version}.tar.gz

chmod a+rw ./out/@condaEnvName@-${version}.tar.gz

conda env remove --name "@condaEnvName@"
