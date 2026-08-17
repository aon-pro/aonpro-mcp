# Claude Code

One command (stores the server in your project's `.mcp.json`):

```bash
claude mcp add --transport http aon https://api.aon.pro/v1/mcp \
  --header "Authorization: Bearer YOUR_AON_API_KEY"
```

Or copy [`.mcp.json`](./.mcp.json) into your project root and replace
`YOUR_AON_API_KEY`.

Get a free key at <https://developer.aon.pro>, or copy the shared demo key
from <https://docs.aon.pro/mcp/quickstart> for a first look.

Then just ask: *"find me noise-cancelling headphones under $300"*.
