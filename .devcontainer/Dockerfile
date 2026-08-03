# Copyright 2026 Joshua Rich <joshua.rich@gmail.com>.
# SPDX-License-Identifier: 	AGPL-3.0-or-later

# https://mcr.microsoft.com/artifact/mar/devcontainers/base
ARG CONTAINER_VERSION=24.04@sha256:52df9b1ee71626e0088f7d400d5c6b5f7bb916f8f0c82b474289a4ece6cf3faf
# https://hub.docker.com/_/golang
ARG GO_VERSION=1.26.5@sha256:dbb10bd1b3400ba0858e2f7c354fd4556b782c187feeff52789d4ee156a84db8

FROM --platform=$BUILDPLATFORM docker.io/golang:${GO_VERSION} AS golang
FROM docker.io/ubuntu:${CONTAINER_VERSION} AS builder

# Install additional packages
RUN DEBIAN_FRONTEND=noninteractive apt -y update && \
    apt -y install sudo fish git micro graphviz ca-certificates curl python3-dotenv-cli python3

RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_AU -c -f UTF-8 -A /usr/share/locale/locale.alias en_AU.UTF-8
ENV LANG en_AU.utf8

# Copy go from official image
COPY --from=golang /usr/local/go/ /usr/local/go/

# # Add non-root user
ARG USERNAME=ubuntu
ARG USER_UID=1000
ARG USER_GID=1000

RUN echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

RUN echo $USER_UID:100000:65536 > /etc/subuid
RUN echo $USER_GID:100000:65536 > /etc/subgid

USER $USERNAME

ENV _CONTAINERS_USERNS_CONFIGURED=""

# The base container sets XDG_CACHE_HOME XDG_CONFIG_HOME specifically for the root user, we can't unset them in a way that vscode will pick up, so we set them to values for the new user.
# Installing go extensions via vscode use these paths so if we just leave it set to /root/.cache we'll get permission errors.
ENV XDG_CONFIG_HOME=/home/$USERNAME/.config
ENV XDG_CACHE_HOME=/home/$USERNAME/.cache
# Set up XDG_RUNTIME_DIR
RUN export XDG_RUNTIME_DIR=/tmp/$USER_UID-runtime-dir \
    && mkdir $XDG_RUNTIME_DIR \
    && chmod 0700 $XDG_RUNTIME_DIR
ENV XDG_RUNTIME_DIR=/tmp/$USER_UID-runtime-dir

ENTRYPOINT ["/usr/bin/bash"]
