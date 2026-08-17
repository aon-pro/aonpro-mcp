#!/usr/bin/env bash
# Minimal AON MCP search. Set AON_API_KEY first:
#   free keys:        https://developer.aon.pro
#   shared demo key:  https://docs.aon.pro/mcp/quickstart
set -euo pipefail

: "${AON_API_KEY:?Set AON_API_KEY (see https://docs.aon.pro/mcp/quickstart)}"

QUERY="${1:-credit card with cashback}"

curl -s -X POST https://api.aon.pro/v1/mcp \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${AON_API_KEY}" \
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
