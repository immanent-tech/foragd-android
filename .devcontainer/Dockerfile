# Copyright 2026 Joshua Rich <joshua.rich@gmail.com>.
# SPDX-License-Identifier: 	AGPL-3.0-or-later

# https://mcr.microsoft.com/artifact/mar/devcontainers/base
ARG CONTAINER_VERSION=24.04@sha256:68ee22004a9109b44973313b02ff7b1de250f1de0f5ecb628d73f579aaff33ac
FROM docker.io/ubuntu:${CONTAINER_VERSION} AS builder

# Install additional packages
RUN DEBIAN_FRONTEND=noninteractive apt -y update && \
    apt -y install sudo fish git micro graphviz ca-certificates curl python3-dotenv-cli python3 jq unzip

RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_AU -c -f UTF-8 -A /usr/share/locale/locale.alias en_AU.UTF-8
ENV LANG en_AU.utf8

# # Add non-root user
ARG USER_NAME=ubuntu
ARG USER_UID=1000
ARG USER_GID=1000

RUN echo $USER_NAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USER_NAME \
    && chmod 0440 /etc/sudoers.d/$USER_NAME

RUN echo $USER_UID:100000:65536 > /etc/subuid
RUN echo $USER_GID:100000:65536 > /etc/subgid

ENV XDG_RUNTIME_DIR=/run/user/$USER_UID
RUN mkdir -p $XDG_RUNTIME_DIR && chmod 0700 $XDG_RUNTIME_DIR && chown $USER_UID:$USER_GID $XDG_RUNTIME_DIR
RUN mkdir -p /datahome/fish /datahome/bash && chown -R $USER_NAME /datahome

USER $USER_NAME

ENV _CONTAINERS_USERNS_CONFIGURED=""

# Save shell history.
RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/datahome/bash/.bash_history" \
    && mkdir -p /home/${USER_NAME}/.config/fish \
    && touch /datahome/bash/.bash_history \
    && echo 'set -gx XDG_DATA_HOME /datahome' >> /home/${USER_NAME}/.config/fish/config.fish \
    && echo "$SNIPPET" >> "/home/$USER_NAME/.bashrc"

ENTRYPOINT ["/usr/bin/bash"]
