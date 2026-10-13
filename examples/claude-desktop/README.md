# Claude Desktop

Claude Desktop cannot attach custom HTTP headers to a remote server, so the
config bridges through [`mcp-remote`](https://www.npmjs.com/package/mcp-remote)
(requires Node.js). The `X-AON-Placement-Id` value rides an env var so it
survives argument splitting on every platform.

Merge [`claude_desktop_config.json`](./claude_desktop_config.json) into:

| OS | Config path |
|----|-------------|
| macOS | `~/Library/Application Support/Claude/claude_desktop_config.json` |
| Windows | `%APPDATA%\Claude\claude_desktop_config.json` |

Create an application and a placement at <https://developer.aon.pro>, then copy
the placement ID (`plc_…`). Replace `YOUR_AON_PLACEMENT_ID` with it, then restart Claude Desktop.
