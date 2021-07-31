# F.A.Q.

## Errors in browser console

### `syscall/js.finalizeRef not implemented`

This error appears in the browser console if the compiler was TidyGo.

- See the [issue #1140](https://github.com/tinygo-org/tinygo/issues/1140) | tinygo | tinygo-org @ GitHub

### `Uncaught RuntimeError: unreachable`

You may forgot to associate the Javascript function to Go functions.

## Errors during go test

### `exec format error`

By default it compiles for js:wasm architecture. Set the Go env variables to the current architecture begore test as below.

```shellsession
$ # Result without env var
$ run-coverage ./utils
fork/exec /tmp/go-build549737882/b001/utils.test: exec format error
FAIL    KEINOS/SampleWasm/utils 0.003s
FAIL
2021/08/03 18:34:55 exit status 1

$ # Result with env var
$ GOOS=linux GOARCH=arm64 run-coverage ./utils
...
Coverage: 100.0% of statements
```

In the same manner, if the code contains `wasm` oriented package such as "`syscall/js`" then you need to set the env var as `GOOS=js GOARCH=wasm go test`.

## Errors during build

### `imports syscall/js: build constraints exclude all Go files in /usr/local/go/src/syscall/js`

```shellsession
$ build-app linux
fatal: No names found, cannot describe anything.
- Building static linked binary to ... /workspaces/Practice_Wasm-Go/bin/Practice_Wasm-Go-linux-arm64/Practice_Wasm-Go
  Arch: linux arm64
  Pwd : /workspaces/Practice_Wasm-Go/main
package KEINOS/SampleWasm/main
        imports syscall/js: build constraints exclude all Go files in /usr/local/go/src/syscall/js
Failed to build binary.
...(** zap **)
```

The above error was caused to build the app for `linux/arm64` which should be `js/wasm` since this repo is a wasm app.

```diff
- build-app linux
+ build-app js wasm
```

To update the `wasm` binary in htdoc(`docs`) use the `build-wams.sh` instead.
