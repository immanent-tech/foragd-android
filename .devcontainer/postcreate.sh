#!/usr/bin/bash

set -x

cd /workspace

sudo chown -R ubuntu:ubuntu /workspace/node_modules \
    /workspace/.gradle \
    /workspace/build \
    /workspace/app

# Download and install node:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.8/install.sh | bash && \
    bash -c '\. "/home/ubuntu/.nvm/nvm.sh" && nvm install 24' && \
    node -v && npm -v

# Update JS packages with bun.
if [[ -e ./package.json ]]; then
    npm clean-install || exit -1
fi
echo 'set --export PATH "/workspace/node_modules/.bin" $PATH' >> ~/.config/fish/config.fish
echo 'export PATH=/workspace/node_modules/.bin:${PATH}' >> ~/.bashrc

# Install oh-my-posh.
mkdir -p ~/.local/bin && curl -s https://ohmyposh.dev/install.sh | bash -s
# Set up shells to use oh-my-posh.
mkdir -p ~/.config/fish \
    && echo "~/.local/bin/oh-my-posh init fish | source" >>~/.config/fish/config.fish \
    && echo 'eval "$(~/.local/bin/oh-my-posh init bash)""' >>~/.bashrc

exit 0
