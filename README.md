# AON MCP Server
[![AllMCPs Verified](https://allmcps.com/api/badge/aon-agent-offer-network)](https://allmcps.com/mcp/aon-agent-offer-network?verify=21ab7e26-9cf6-42eb-b7a5-9a4fe5c5438e)
[![MCP status](https://mcpi.app/servers/aon-agent-offer-network/badge.svg)](https://mcpi.app/servers/aon-agent-offer-network)
[![Wellknown: live](https://wellknown.network/agents/aon-agent-offer-network/badge.svg)](https://wellknown.network/agents/aon-agent-offer-network)
[![mcpmetrics](https://mcpmetrics.io/badge/pro.aon/mcp/uptime.svg)](https://mcpmetrics.io/servers/pro-aon-mcp)

<p align="center">
  <img src="assets/aon-mcp-icon.png" width="128" height="128" alt="AON">
</p>

Give any MCP-capable agent the ability to recommend **real, buyable products
and services** — live pricing and a trackable link on every offer, drawn from
the [Agent Offer Network](https://www.aon.pro).

- **Endpoint**: `POST https://api.aon.pro/v1/mcp`
- **Transport**: Streamable HTTP (stateless JSON-RPC 2.0 — no SSE, no session handshake)
- **Placement (recommended)**: send your placement ID in the `X-AON-Placement-Id` header — create one in the [Developer Portal](https://developer.aon.pro). Without it, search still works in anonymous mode, but earnings cannot be attributed to your application
- **Quick Start**: run the curl or client examples with your placement ID
- **Docs**: [docs.aon.pro/mcp](https://docs.aon.pro/mcp)

## Tools

The Hosted AON endpoint currently lists five tools. Protocol v1.0 names the
four base tools below; `aon_get_category_schema` is an optional Hosted
category-guidance extension, not a portable Protocol v1.0 guarantee. Discover
it through `tools/list` before calling it.

- `aon_search_offers` — Search offers by natural-language intent; every result
  carries live pricing, a tracking link, and pre-validated follow-up suggestions.
- `aon_resolve_category` — Turn free text into AON Taxonomy v1 category ids.
- `aon_get_category_schema` — Optional Hosted extension: decision factors for a
  resolved category id, to ask the right clarifying question before searching.
- `aon_submit_feedback` — Record an explicit "dismissed" / "not interested" on an
  offer (early scaffold: acknowledged, not persisted yet).
- `aon_manage_watch` — Restore or cancel the default watch on an offer or
  category on explicit request (early scaffold: acknowledged, not persisted yet).

| Tool | What it does |
|------|--------------|
| `aon_search_offers` | Search offers by natural-language intent. Arguments are an [AgentOffer Query](https://github.com/agentoffernetwork/protocol) request object — the same shape as the REST API. Returns offers with pricing, a tracking link each, and an `engagement` block of pre-validated follow-up suggestions the agent can act on. |
| `aon_resolve_category` | Turn free text ("hiking boots", "team chat software") into AON Taxonomy v1 category ids — the model never has to memorize or invent them. |
| `aon_get_category_schema` | Optional Hosted extension: return decision factors for an already resolved category id, to ask the right clarifying question before searching. Its standalone result does not add `decision_factors` to the Query request or response. |
| `aon_submit_feedback` | Record an explicit "dismissed" / "not interested" from the user on an offer — never inferred from silence. *Early scaffold: the call is acknowledged with success, but feedback is not persisted yet; the workflow behind it is rolling out.* |
| `aon_manage_watch` | Restore (`watch`) or cancel (`unwatch`) the default watch on an offer or category when the user explicitly asks. *Early scaffold: acknowledged with success, watch state not persisted yet.* |

Design notes agents benefit from:

- **Forgiving by design** — invalid values never fail a search; they are
  treated as "not sent" and corrected in `extra.hints[]`. Only a malformed, unknown or inactive placement,
  invalid JSON, a missing `intent.content`, or an oversized body hard-fail. A missing placement is not
  an error: the call runs in anonymous mode.
- **Relevance-gated** — an empty result list is a real answer, never filler.
- **Guidance loop** — follow-up suggestions carry an RFC 7386 `request_patch`
  that merges straight into the next call, plus an `origin` to echo back for
  adoption attribution.

## Quick start

```bash
curl -s -X POST https://api.aon.pro/v1/mcp \
  -H "Content-Type: application/json" \
  -H "X-AON-Placement-Id: $AON_PLACEMENT_ID" \
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

No placement yet? Create an application and a placement in the
[Developer Portal](https://developer.aon.pro), and store the placement ID
(`plc_…`) in `$AON_PLACEMENT_ID`. It identifies your placement and is safe to
use in client configuration.

To just try the endpoint, drop the `X-AON-Placement-Id` header: the call runs in
**anonymous mode** through AON's shared default placement, the response carries
`extra.identity.mode="anonymous"`, and it **earns nothing** — clicks and
conversions from anonymous calls cannot be attributed to your application,
including retroactively. Configure your placement ID before real traffic.

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

`/v1/mcp` allows **60 `tools/call` requests per minute per application**; handshake
calls (`initialize`, `tools/list`, `notifications/*`) are never counted. An
over-limit `tools/call` returns HTTP 429 with a `Retry-After` header and JSON-RPC error `-32000` so the
model can read the retry advice. Details:
[Rate Limits & FAQ](https://docs.aon.pro/mcp/faq).

## Monetization & attribution

Every offer carries a tracked destination link (`action.payload.url`).
Surface it verbatim — clicks and conversions attribute to your placement's
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
