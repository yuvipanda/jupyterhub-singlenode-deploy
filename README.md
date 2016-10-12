# JupyterHub Single Node Deployment #

Provide a very easy way to setup (and maintain) a JupyterHub that exists on only one node. 

## Why? ##

A single node running JupyterHub is a very valuable tool that supports a lot of use cases:

1. Run a workshop for two days on a AWS machine with some shared data.
2. Have a place for your 20 students class to play with Notebooks
3. Do data analysis for your small 5 person startup
4. Ration access from researches to a massive compute node with 3TB of RAM
5. And plenty more!

Running JupyterHub on one node is far simpler than running it as a distributed system across a large, elastic number of nodes. This repository aims to make it super simple - *under 20 mins* - to setup a fully functional JupyterHub system configured to your liking.

## What? ##

This deployment supports the following features in a very composable, pick what you want way:

1. A supported version of JupyterHub
2. The nginx based proxy (rather than the nodejs based one)
3. Systemd Spawner for spawning notebooks with equitable resource sharing (CPU / Memory / IO) between users
4. Choice of authenticators:
   1. GitHub
   2. Google / Google Apps
   3. PAM
   4. Google Sheets
5. Automatic SSL with Let's Encrypt

Note that most of these features aren't implemented yet. We will be making tagged releases of this repository over time, and migration paths will always be available.

## What this is not? ##

We will try to keep this as small and self contained and possible, without letting too much feature creep in. Having a list of things this will *not* be is often useful, so this is a non-exhaustive list.

1. Will not support multiple node jupyterhub services. Those have inherently different challenges, and attempting to solve both in the same way ends up with a solution that doesn't help either.
2. Will not be super specific to one install or environment. This means we can't rely on running on one particular cloud provider or one university's setup.
3. Will not support all possible spawners. Will need to restrict them to a subset that has minimal overlap, and can be supported by the community at large.

## How? ##

Right now, you can check it out by doing the following:

1. Create a new VM running Ubuntu 16.04
2. Clone this repository to the VM
   ```bash
   git clone --recursive https://github.com/yuvipanda/jupyterhub-singlenode-deploy.git
   ```

   The `--recursive` is necessary for initializing the puppet modules we use as git submodules
3. Copy `hieradata/config.yaml.sample` to `hieradata/config.yaml`, and modify it to fit your needs
4. Run `sudo ./apply.bash` inside the `jupyterhub-singlenode-deploy` dir!

This will setup a basic jupyterhub.
