# Changelog

## 0.1.0

Initial release.

- Python stdlib HTTP server (`ThreadingHTTPServer`), zero pip dependencies
- REST API: `/api/state`, `/api/manifest`, `/api/config`, `/api/logs/{slug}`, `/api/prompt/{slug}`
- SSE endpoints: `/api/events/state` (mtime polling, 2s), `/api/events/logs/{slug}` (tail polling, 1s)
- DAG rendering via dagre with status-colored nodes and pulse animation for running tasks
- Task detail panel: metadata, branch copy, prompt viewer
- Log viewer: SSE real-time append, auto-scroll, pause/clear, ANSI stripping
- Header: repo name, uptime timer, status count pills
- Footer: connection status indicator, last update timestamp
- Auto-reconnect with exponential backoff (1s → 30s max)
- Config display with sensitive value masking
- SVG pan/zoom for DAG navigation
