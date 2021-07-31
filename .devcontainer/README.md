# Dev Container for Go - Wasm

## VS Code Users

### Workspace and Live Preview

This repo contains multi-root workspace configuration file for VS Code.

If you open the workspace as multi-root workspace then you can use the preview
webserver extension such as "Preview on Web Server".

(The "Live Preview" extension does not support ".wasm" extension file in it's MIME.
Use "Preview on Web Server"(`yuichinukiyama.vscode-preview-server`) instead.)

To open as multi-workspace, click the "dev.code-workspace" file in the explorer. Then
select "Multi-root Workspace" button that appears on the right bottom.

To view the live preview on the browser, click the "index.html" file in the explorer
under the "WebRoot" workspace, and press `shift`+`control`+`L` and the browser will open.

Any change under the "WebRoot" workspace will be reflected to the browser automatically.

### Dev on Docker

This container supports Remote-Containers' extension.

If you have Docker installed, then you don't need to install the required Go versions
and packages for development.

Just install the "Remote - Containers" extension and type and select "Reopen in Container..."
from F1 key.
