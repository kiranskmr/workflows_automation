#!/bin/bash

# While the Workflows Authoring Toolkit is in preview, the following script
# takes care of initialization. We expect a future version of the CLI
# will do this work automatically!
set -e

if ! [ -e databricks.yml ]; then
  echo "ERROR: databricks.yml not found in $PWD."
  exit 1
fi

rm -rf resources/__generated__

if databricks --version | awk -F'[.v]' '($2 > 0 || ($2 == 0 && $3 >= 217 && ($4 >= 1 || $3 > 217))) {exit 1}'; then
  echo "ERROR: Databricks CLI version 0.217.1 or higher is required, found: $(databricks --version)"
  echo "Please refer to https://docs.databricks.com/en/dev-tools/cli/install.html for instructions on how to upgrade."
  exit 1
fi

function venv_pip_install() {
  . .venv/bin/activate
  pip -q --disable-pip-version-check install -r requirements-dev.txt
}

if [[ -e ".venv" ]]; then
  venv_pip_install
elif [[ -z "${VIRTUAL_ENV}" ]]; then
   python=$(which python3.10) || \
   python=$(which python3.11) || \
   python=$(which python3) || \
   python=$(which python)

  if [[ -z "$python" ]]; then
    echo "Python interpreter not found.";
    exit 1
  fi

  $python -m venv .venv
  venv_pip_install
else
  echo "Detected venv at ${VIRTUAL_ENV}. Make sure to:"
  echo "  $ pip install -r requirements-dev.txt"
  echo
  echo "or create an new virtual environment:"
  echo "  $ python -m venv .venv"
  echo
fi

if ! python -c "import sys; exit(0 if (sys.version_info >= (3, 10)) else 1)"; then
  echo "ERROR: Python 3.10 or higher is required, found: $(python --version)"
  echo "Please manually initialize a virtual environment with a newer Python version, using"
  echo "  $ python -m venv .venv"
  exit 1
fi

python -m databricks.bundles.build "$@"