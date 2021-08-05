#!/bin/sh
# POSIX shell compatible
# =============================================================================
#  WebAssembly (wasm) Builder
# =============================================================================
#  Run this script to build wasm binary under "./docs".
#
#  Requirements:
#    Go 1.12+ or Docker
#
#  Note:
#    If Go is NOT installed then it will use Docker with TinyGo image instead.
#    If TinyGo IS installed then it will use tinygo as a compiler.

# -----------------------------------------------------------------------------
#  Name Constants
# -----------------------------------------------------------------------------
NAME_DIR_OUT_WASM="docs"
NAME_DIR_SRC_MAIN="main"
NAME_FILE_FAVICON="favicon.ico"
NAME_FILE_HTML_INDEX="index.html"
NAME_FILE_JS_EXEC="wasm_exec.js"
NAME_FILE_OUT_WASM="test.wasm"
NAME_FILE_SCRIPT="$(basename "$0")"

# -----------------------------------------------------------------------------
#  Path Constants
# -----------------------------------------------------------------------------
PATH_DIR_SCRIPT="$(cd "$(dirname "$0")" && pwd)"
PATH_DIR_OUT_WASM="${PATH_DIR_SCRIPT}/${NAME_DIR_OUT_WASM}"
PATH_DIR_SRC_MAIN="${PATH_DIR_SCRIPT}/${NAME_DIR_SRC_MAIN}"

PATH_FILE_FAVICON="${PATH_DIR_OUT_WASM}/${NAME_FILE_FAVICON}"
PATH_FILE_INDEX="${PATH_DIR_OUT_WASM}/${NAME_FILE_HTML_INDEX}"
PATH_FILE_JS_EXEC="${PATH_DIR_OUT_WASM}/${NAME_FILE_JS_EXEC}"
PATH_FILE_OUT_WASM="${PATH_DIR_OUT_WASM}/${NAME_FILE_OUT_WASM}"

# -----------------------------------------------------------------------------
#  Readability Constants
# -----------------------------------------------------------------------------
TRUE=0
FALSE=1
SUCCESS=0
FAILURE=1

# -----------------------------------------------------------------------------
#  Functions
# -----------------------------------------------------------------------------
isDockerInstalled() {
    if type docker 2>/dev/null 1>/dev/null; then
        return $TRUE
    fi

    return $FALSE
}

isGitInstalled() {
    if type git 2>/dev/null 1>/dev/null; then
        return $TRUE
    fi

    return $FALSE
}

isGoInstalled() {
    if type go 2>/dev/null 1>/dev/null; then
        return $TRUE
    fi

    return $FALSE
}

isImageDockerPulled() {
    nameImagePulled="${1}"
    docker image inspect "${nameImagePulled}" 1>/dev/null 2>/dev/null && {
        return $TRUE
    }

    return $FALSE
}

isInsideDocker() {
    if [ -r "/.dockerenv" ]; then
        return $TRUE
    fi

    return $FALSE
}

isTinyGoInstalled() {
    if type tinygo 2>/dev/null 1>/dev/null; then
        return $TRUE
    fi

    return $FALSE
}

pullImageDocker() {
    nameImage="${1}"
    result=$(docker pull "${nameImage}" 2>&1) || {
        echo >&2 "Failed to pull docker image. (${nameImage})"
        echo >&2 "$result"

        return $FALSE
    }

    return $TRUE
}

# -----------------------------------------------------------------------------
#  Setup (Download and copy required files to run wasm)
# -----------------------------------------------------------------------------
# Use Docker to build if NO Go found in local
isGoInstalled || {
    isDockerInstalled || {
        echo >&2 'Failed to build.'
        echo >&2 'You need Golang or Docker installed.'

        exit $FAILURE
    }
    echo '- Docker detected.'

    isImageDockerPulled "tinygo/tinygo:latest" || {
        printf "%s" "- Pulling latest Docker image of TinyGo ... "
        result=$(pullImageDocker "tinygo/tinygo:latest" 2>&1) || {
            echo >&2 'Failed to pull Docker image of TinyGo.'
            echo >&2 "$result"

            exit $FAILURE
        }
        echo 'OK'
    }

    # Run this script recursively inside Docker
    printf "%s" "- Building wasm binary via TinyGo ... "
    result=$(docker run --rm --workdir /src -v "$(pwd)":/src tinygo/tinygo "/src/${NAME_FILE_SCRIPT}" 2>&1) || {
        echo >&2 'Faild to build tinygo docker image.'
        echo >&2 "$result"

        exit $FAILURE
    }
    echo 'OK'

    exit $SUCCESS
}

isInsideDocker && {
    echo '[INFO] Running inside docker'
}

# Download blank and transparent favicon.ico
if [ ! -r "${PATH_FILE_FAVICON}" ]; then
    printf "%s" "- Downloading blank favicon.ico ... "
    result=$(wget "https://git.io/blankfavicon16x16" -O "${PATH_FILE_FAVICON}" 2>&1) || {
        echo 'NG (failed to download)'
        echo "$result"

        exit $FAILURE
    }
    echo 'OK'
fi

# Copy JS file if Go (Not TinyGo)
! isTinyGoInstalled && {
    # These 2 files MUST be copyied from the bundle of Go that you are currently using.
    #   See: https://github.com/golang/go/issues/29827
    PATH_FILE_INDEX_DEFAULT="$(go env GOROOT)/misc/wasm/wasm_exec.html"
    PATH_FILE_JS_EXEC_DEFAULT="$(go env GOROOT)/misc/wasm/wasm_exec.js"

    # Copy default (sample) HTML if not found
    if [ ! -r "${PATH_FILE_INDEX}" ]; then
        printf "%s" "- Copying the default HTML file ... "
        result=$(cp "${PATH_FILE_INDEX_DEFAULT}" "${PATH_FILE_INDEX}" 2>&1) || {
            echo 'NG (failed to copy)'
            echo "$result"

            exit $FAILURE
        }
        echo 'OK'
    fi

    # Force overwrite the wasm JS file that matches to the compiler
    printf "%s" "- Copying the default JS file from Go ... "
    result=$(cp "${PATH_FILE_JS_EXEC_DEFAULT}" "${PATH_FILE_JS_EXEC}" 2>&1) || {
        echo 'NG (failed to copy)'
        echo "$result"

        exit $FAILURE
    }
    echo 'OK'
}

# Copy JS file if TinyGo
isTinyGoInstalled && {
    echo '[INFO] TinyGo detected. Using tinygo as a compiler.'

    # These 2 files MUST be copyied from the bundle of Go that you are currently using.
    #   See: https://github.com/golang/go/issues/29827
    PATH_FILE_INDEX_DEFAULT="/usr/local/tinygo/src/examples/wasm/main/index.html"
    PATH_FILE_JS_EXEC_DEFAULT="/usr/local/tinygo/targets/wasm_exec.js"

    # Copy default (sample) HTML if not found
    if [ ! -r "${PATH_FILE_INDEX}" ]; then
        printf "%s" "- Copying the default HTML file ... "
        result=$(cp "${PATH_FILE_INDEX_DEFAULT}" "${PATH_FILE_INDEX}" 2>&1) || {
            echo 'NG (failed to copy)'
            echo "$result"

            exit $FAILURE
        }
        echo 'OK'
    fi

    # Force overwrite the wasm JS file that matches to the compiler
    printf "%s" "- Copying the default JS file from TinyGo ... "
    result=$(cp "${PATH_FILE_JS_EXEC_DEFAULT}" "${PATH_FILE_JS_EXEC}" 2>&1) || {
        echo 'NG (failed to copy)'
        echo "$result"

        exit $FAILURE
    }
    echo 'OK'

    isGitInstalled || {
        apt-get update && apt-get install -y git && \
        git --version
    }
}

# -----------------------------------------------------------------------------
#  Main (Build wasm. Use tinygo if possible)
# -----------------------------------------------------------------------------
# App version from git tag and rev-parse
TAG_APP=$(git describe --tag 2>/dev/null)
REV_APP=$(git rev-parse --short HEAD)
VER_APP=""

# Build with TinyGo compiler
isTinyGoInstalled && {
    NAME_COMPILER="TinyGo v$(tinygo version | grep -o -E "([0-9]+\.){1}[0-9]+(\.[0-9]+)?" | head -n1)"
    if [ "${TAG_APP:+undefined}" ]; then
        VER_APP="${TAG_APP}-${REV_APP} (Compiler: ${NAME_COMPILER})"
    fi
    LdFlags="-X \"main.versionApp=${VER_APP}\""

    printf "%s" "- Building wasm with TinyGo ... "
    result=$(
        GOOS=js GOARCH=wasm \
            tinygo build \
            -o "${PATH_FILE_OUT_WASM}" \
            -target=wasm \
            -ldflags="${LdFlags}" \
            "${PATH_DIR_SRC_MAIN}/" 2>&1
    ) || {
        echo 'NG (failed to build wasm binary)'
        echo "$result"

        exit $FAILURE
    }
    echo 'OK'

    exit $SUCCESS
}

# Build with usual Go compiler
NAME_COMPILER="Go v$(go version | grep -o -E "([0-9]+\.){1}[0-9]+(\.[0-9]+)?" | head -n1)"
if [ "${TAG_APP:+undefined}" ]; then
    VER_APP="${TAG_APP}-${REV_APP} (Compiler: ${NAME_COMPILER})"
fi
LdFlags="-X \"main.versionApp=${VER_APP}\""

printf "%s" "- Building wasm with Go ... "
result=$(
    GOOS=js GOARCH=wasm \
        go build \
        -o "${PATH_FILE_OUT_WASM}" \
        -ldflags "-s -w ${LdFlags}" \
        "${PATH_DIR_SRC_MAIN}/" 2>&1
) || {
    echo 'NG (failed to build wasm binary)'
    echo "$result"

    exit $FAILURE
}
echo 'OK'

exit $SUCCESS
