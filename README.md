# jupyterlab-minimal

This repository contains information to create a docker image for jupyterlab. The notebook has minimal python libraries in it. It has been created to utilize GPUs in Cyverse Discover Environment.

### Dockerfile

The docker image is based on the [jupyter/minimal-notebook](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#jupyter-minimal-notebook) image. It has python 3.11 installed and includes some command line tools like curl, git, and nano. 

`FROM quay.io/jupyter/minimal-notebook:lab-4.2.1`

### Build and Run Locally

`git clone git@github.com:cyverse-vice/jupyterlab-minimal.git`

`cd jupyterlab-minimal`

`docker build -t harbor.cyverse.org/vice/jupyter/minimal:gpu-2405 .`

`docker run -it --rm --gpus=all -p 8888:8888 harbor.cyverse.org/vice/jupyter/minimal:gpu-2405`

### Push to Cyverse Harbor

`docker push harbor.cyverse.org/vice/jupyter/minimal:gpu-2405`

### Create Cyverse DE Tool

Go to the Cyverse DE and go to 'Tools'

<img src="/images/cyverse_tool.png" width=600>

<br/>

<img src="/images/cyverse_tool2.png" width=200>

<br/>

Fill out the tool information as such

<img src="/images/cyverse_tool3.png" width=400>

<img src="/images/cyverse_tool4.png" width=400>

<img src="/images/cyverse_tool5.png" width=400>

<br/>

Go to the 'Tools' under the Admin. You need admin privaledges for this to be visible. 


