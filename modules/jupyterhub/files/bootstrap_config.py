"""
Bootstrapper configuration for JupyterHub

Looks for all files under a 'config.d' directory in
the same path as this file, and loads all the .py
files inside them. This allows us to have small modular
config files instead of one monolithic one.

The files should be of form NN-something.py, where NN is a
two digit priority number. The files will be loaded in
ascending order of NN. Files not ending in .py will be
ignored.
"""
import os
from glob import glob

dirname = os.path.dirname(os.path.abspath(__file__))
confdir = os.path.join(dirname, 'config.d')

for f in sorted(glob(os.path.join(confdir, '*.py'))):
    load_subconfig(f)
