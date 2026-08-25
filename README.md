# AON MCP Server

Give any MCP-capable agent the ability to recommend **real, buyable products
and services** — live pricing and a trackable link on every offer, drawn from
the [Agent Offer Network](https://www.aon.pro).

- **Endpoint**: `POST https://api.aon.pro/v1/mcp`
- **Transport**: Streamable HTTP (stateless JSON-RPC 2.0 — no SSE, no session handshake)
- **Auth**: `Authorization: Bearer <AON API key>` — free keys at the [Developer Portal](https://developer.aon.pro)
- **Try it now**: a shared public demo key is published in the [Quick Start](https://docs.aon.pro/mcp/quickstart) — one curl, no signup
- **Docs**: [docs.aon.pro/mcp](https://docs.aon.pro/mcp)

## Tools

| Tool | What it does |
|------|--------------|
| `aon_search_offers` | Search offers by natural-language intent. Arguments are an [AgentOffer Query](https://github.com/agentoffernetwork/protocol) request object — the same shape as the REST API. Returns offers with pricing, a tracking link each, and an `engagement` block of pre-validated follow-up suggestions the agent can act on. |
| `aon_resolve_category` | Turn free text ("hiking boots", "team chat software") into AON Taxonomy v1 category ids — the model never has to memorize or invent them. |
| `aon_get_category_schema` | Get the decision factors buyers weigh inside a category, to ask the right clarifying question before searching. |
| `aon_submit_feedback` | Record an explicit "dismissed" / "not interested" from the user on an offer — never inferred from silence. *Early scaffold: the call is acknowledged with success, but feedback is not persisted yet; the workflow behind it is rolling out.* |
| `aon_manage_watch` | Restore (`watch`) or cancel (`unwatch`) the default watch on an offer or category when the user explicitly asks. *Early scaffold: acknowledged with success, watch state not persisted yet.* |

Design notes agents benefit from:

- **Forgiving by design** — invalid values never fail a search; they are
  treated as "not sent" and corrected in `extra.hints[]`. Only bad auth,
  invalid JSON, a missing `intent.content`, or an oversized body hard-fail.
- **Relevance-gated** — an empty result list is a real answer, never filler.
- **Guidance loop** — follow-up suggestions carry an RFC 7386 `request_patch`
  that merges straight into the next call, plus an `origin` to echo back for
  adoption attribution.

## Quick start

```bash
curl -s -X POST https://api.aon.pro/v1/mcp \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $AON_API_KEY" \
  -d '{
    "jsonrpc": "2.0",
    "method": "tools/call",
    "params": {
      "name": "aon_search_offers",
      "arguments": {
        "intent": {
          "content": [
            { "type": "input_text", "text": "credit card with cashback" }
          ]
        }
      }
    },
    "id": 1
  }'
```

No key yet? Copy the shared demo key from the
[Quick Start](https://docs.aon.pro/mcp/quickstart) into `$AON_API_KEY`.

## Client setup

Ready-to-paste configs live in [`examples/`](./examples):

| Client | Config |
|--------|--------|
| Claude Code | [`examples/claude-code`](./examples/claude-code) |
| Claude Desktop | [`examples/claude-desktop`](./examples/claude-desktop) (via `mcp-remote`) |
| Cursor | [`examples/cursor`](./examples/cursor) |
| VS Code | [`examples/vscode`](./examples/vscode) |
| Plain curl | [`examples/curl`](./examples/curl) |

## Rate limits

`/v1/mcp` allows **60 `tools/call` requests per minute per key**; handshake
calls (`initialize`, `tools/list`, `notifications/*`) are never counted. An
over-limit `tools/call` returns HTTP 200 with JSON-RPC error `-32000` so the
model can read the retry advice. Details:
[Rate Limits & FAQ](https://docs.aon.pro/mcp/faq).

## Monetization & attribution

Every offer carries a tracked destination link (`action.payload.target`).
Surface it verbatim — clicks and conversions attribute to your API key's
application, which is the basis for developer revenue share. Reporting lives
in the [Developer Portal](https://developer.aon.pro).

## Registry manifest

[`server.json`](./server.json) is the MCP registry manifest for this server
(schema `2025-12-11`, namespace `pro.aon` — DNS-verified against the aon.pro domain).

## Related repositories

- [`protocol`](https://github.com/agentoffernetwork/protocol) — AgentOffer Protocol specs (normative)
- [`schema`](https://github.com/agentoffernetwork/schema) — JSON Schemas, TypeScript types, taxonomy
- [`examples`](https://github.com/agentoffernetwork/examples) — HTTP / SDK / agent integration examples
- [`rfcs`](https://github.com/agentoffernetwork/rfcs) — protocol evolution proposals

## License

[Apache-2.0](./LICENSE)
