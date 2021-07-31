# See here for image contents: https://github.com/KEINOS/VSCode-Dev-Container-Go/pkgs/container/vscode-dev-container-go
ARG VARIANT="latest"

# =============================================================================
#  Main Stage
# =============================================================================
FROM ghcr.io/keinos/vscode-dev-container-go:${VARIANT}

# -----------------------------------------------------------------------------
#  Root Privilege
# -----------------------------------------------------------------------------
USER root

# Rewrite
RUN \
    sed -i.bak "s/go-carpet/GOOS=linux GOARCH=arm64 go-carpet/" /usr/local/bin/aliases.sh && \
    sed -i.bak "s/\/usr/GOOS=linux GOARCH=arm64 \/usr/" /usr/local/bin/aliases.sh

# Uncomment below to install any additional apk packages
RUN apk add --no-cache \
    # node is required to test syscall/js go package
    # see: https://golang.org/src/syscall/js/js_test.go
    nodejs

# -----------------------------------------------------------------------------
#  User vscode
# -----------------------------------------------------------------------------
USER vscode

WORKDIR /tmp

# Uncomment below to install any Go packages to `go get`
#RUN GOBIN="" go get <some package>

WORKDIR /workspaces
ENV \
    GOOS=js \
    GOARCH=wasm
