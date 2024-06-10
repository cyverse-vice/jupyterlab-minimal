# Read this regarding runtime: https://stackoverflow.com/questions/59691207/docker-build-with-nvidia-runtime
# IMPORTANT: torch will NOT recognize cuda if installed in base: requires its own env.
FROM quay.io/jupyter/minimal-notebook:lab-4.2.1

USER root

ARG DEBIAN_FRONTEND=noninteractive


# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/etc/apt/trusted.gpg.d/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/trusted.gpg.d/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" > /etc/apt/sources.list.d/github-cli.list && \
    apt update && \
    apt install gh

# Install and configure jupyter lab.
COPY jupyter_notebook_config.json /opt/conda/etc/jupyter/jupyter_notebook_config.json

# Add sudo to jovyan user
RUN apt update && \
    apt install -y sudo && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

ARG LOCAL_USER=jovyan
ARG PRIV_CMDS='/bin/ch*,/bin/cat,/bin/gunzip,/bin/tar,/bin/mkdir,/bin/ps,/bin/mv,/bin/cp,/usr/bin/apt*,/usr/bin/pip*,/bin/yum,/bin/snap,/bin/curl,/bin/tee,/opt'

RUN usermod -aG sudo jovyan && \
    echo "$LOCAL_USER ALL=NOPASSWD: $PRIV_CMDS" >> /etc/sudoers
RUN addgroup jovyan
RUN usermod -aG jovyan jovyan

# Uncommet these to install cuda (commented as cuda is installed below)
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
RUN sudo mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
RUN wget https://developer.download.nvidia.com/compute/cuda/12.4.1/local_installers/cuda-repo-ubuntu2204-12-4-local_12.4.1-550.54.15-1_amd64.deb
RUN sudo dpkg -i cuda-repo-ubuntu2204-12-4-local_12.4.1-550.54.15-1_amd64.deb
RUN sudo cp /var/cuda-repo-ubuntu2204-12-4-local/cuda-*-keyring.gpg /usr/share/keyrings/
RUN sudo apt-get update && sudo apt-get -y install cuda-toolkit-12-4
RUN rm cuda-repo-ubuntu2204-12-4-local_12.4.1-550.54.15-1_amd64.deb

USER jovyan

WORKDIR /home/jovyan

EXPOSE 8888

# Install pytorch in its own environment
#COPY environment.yml /home/jovyan/environment.yml
#RUN conda install -c conda-forge mamba -y
#RUN mamba env create -f environment.yml -y && \
 #   mamba install -n pytorch-gpu ipykernel -y && \
 #   /opt/conda/envs/pytorch-gpu/bin/python -m ipykernel install --name "pytorch-gpu" --user && \
 #   echo "source activate pytorch-gpu" >> ~/.bashrc && \
 #   /bin/bash -c "source activate pytorch-gpu"

# Install Jupyter-AI https://jupyter-ai.readthedocs.io/en/latest/users/index.html#installation
RUN pip install jupyter-ai 

# Rebuild the Jupyter Lab with new tools
RUN jupyter lab build

# Activate the conda base in the image & create access to kernel
#RUN echo ". /opt/conda/etc/profile.d/conda.sh" >> /home/jovyan/.bashrc 
 #   echo "conda activate pytorch-gpu" >> /home/jovyan/.bashrc
#RUN ipython kernel install --name "gpu_clean_env" --user 

# Resolves error for libcudart.so
# RUN echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-11.3/targets/x86_64-linux/lib && source /etc/profile" >> /home/jovyan/.bashrc

COPY entry.sh /bin
RUN mkdir -p /home/jovyan/.irods

ENTRYPOINT ["bash", "/bin/entry.sh"]
