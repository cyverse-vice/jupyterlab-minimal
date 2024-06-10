# jupyterlab-minimal

This repository contains information to create a docker image for jupyterlab. The notebook has minimal python libraries in it. It has been created to utilize GPUs in Cyverse Discover Environment.

##Dockerfile

The docker image is based on the [jupyter/minimal-notebook](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#jupyter-minimal-notebook) image. It has python 3.11 installed and includes some command line tools like curl, git, and nano. 

`FROM quay.io/jupyter/minimal-notebook:lab-4.2.1`

### Build Locally

git clone 
