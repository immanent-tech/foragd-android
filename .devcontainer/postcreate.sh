#!/usr/bin/bash

set -x

cd /workspace

# Download and install node:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.6/install.sh | bash && \
    bash -c '\. "/home/ubuntu/.config/nvm/nvm.sh" && nvm install 24' && \
    node -v && npm -v

# Download and install docker.
cd /tmp && \
    curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh ./get-docker.sh && rm /tmp/get-docker.sh

# Dowload and install starship.
cd /tmp && curl -sS https://starship.rs/install.sh | sh -s -- -y
mkdir -p ~/.config/fish \
    && echo "starship init fish | source" >>~/.config/fish/config.fish \
    && echo 'eval "$(starship init bash)"' >>~/.bashrc


# Update JS packages with bun.
npm clean-install || exit -1
echo 'set --export PATH "/workspace/node_modules/.bin" $PATH' >> ~/.config/fish/config.fish

# Install Go packages.
echo 'set --export PATH "$HOME/go/bin" /go/bin /usr/local/go/bin $PATH' >> ~/.config/fish/config.fish
export PATH="$HOME/go/bin:/go/bin:/usr/local/go/bin:$PATH" && \
    go mod tidy && \
    go install golang.org/x/tools/gopls@latest && \
    go install github.com/sigstore/cosign/v3/cmd/cosign@latest && \
    go install github.com/magefile/mage@latest && \
    curl -sSfL https://golangci-lint.run/install.sh | sh -s -- -b $(go env GOPATH)/bin v2.8.0 && \
    golangci-lint custom && \
    mv /tmp/golangci-lint-v2 $(go env GOPATH)/bin/

# Setup docker buildx.
docker buildx create --name default-rootless --driver=docker-container --driver-opt=image=moby/buildkit:buildx-stable-1-rootless --driver-opt default-load=true \
    && docker buildx use default-rootless \
    && docker buildx inspect --bootstrap default-rootless

exit 0
