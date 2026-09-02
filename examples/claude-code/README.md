# Claude Code

One command (stores the server in your project's `.mcp.json`):

```bash
claude mcp add --transport http aon https://api.aon.pro/v1/mcp \
  --header "Authorization: Bearer YOUR_AON_API_KEY"
```

Or copy [`.mcp.json`](./.mcp.json) into your project root and replace
`YOUR_AON_API_KEY`.

Create an application and mint an issued live key at
<https://developer.aon.pro>. Keep `YOUR_AON_API_KEY` as a placeholder in
source control and replace it only in your local configuration.

Then just ask: *"find me noise-cancelling headphones under $300"*.
