# Claude Code

One command (stores the server in your project's `.mcp.json`):

```bash
claude mcp add --transport http aon https://api.aon.pro/v1/mcp \
  --header "X-AON-Placement-Id: YOUR_AON_PLACEMENT_ID"
```

Or copy [`.mcp.json`](./.mcp.json) into your project root and replace
`YOUR_AON_PLACEMENT_ID`.

Create an application and a placement at <https://developer.aon.pro>, then copy
the placement ID (`plc_…`).

Then just ask: *"find me noise-cancelling headphones under $300"*.
