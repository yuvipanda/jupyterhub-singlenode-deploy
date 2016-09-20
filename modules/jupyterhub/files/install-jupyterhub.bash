#!/bin/bash
# Simple script that does the following:
#  - Install a particular version of JupyterHub
#  - Install a particular version of nchp

PYTHON="${VENV_PATH}/bin/python3"
PIP="${VENV_PATH}/bin/pip3"

$PIP install jupyterhub
$PIP install git+https://github.com/yuvipanda/jupyterhub-nginx-chp.git@accesslog
