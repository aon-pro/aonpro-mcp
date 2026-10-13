#!/usr/bin/env bash
# Minimal AON MCP search. Set AON_PLACEMENT_ID to your placement ID (plc_…)
# from https://developer.aon.pro
set -euo pipefail

: "${AON_PLACEMENT_ID:?Set AON_PLACEMENT_ID (see https://docs.aon.pro/mcp/quickstart)}"

QUERY="${1:-credit card with cashback}"

curl -s -X POST https://api.aon.pro/v1/mcp \
  -H "Content-Type: application/json" \
  -H "X-AON-Placement-Id: ${AON_PLACEMENT_ID}" \
  -d "$(cat <<JSON
{
  "jsonrpc": "2.0",
  "method": "tools/call",
  "params": {
    "name": "aon_search_offers",
    "arguments": {
      "intent": {
        "content": [
          { "type": "input_text", "text": "${QUERY}" }
        ]
      }
    }
  },
  "id": 1
}
JSON
)"
