# SKILLS_INDEX

集中技能索引（自动生成）。修改 skill 后请重新运行：`python3 scripts/skill-maintenance.py all`。

| Scope | Namespace | Skill | Version | Status | Path |
|---|---|---|---|---|---|
| openclaw | claude | `universal-claude-bridge` | 0.1.0 | active | `openclaw/claude/universal-claude-bridge` |
| openclaw | dev | `ai-tmux-swarm` | 0.1.0 | active | `openclaw/dev/ai-tmux-swarm` |
| shared | content | `baoyu-format-markdown` | 0.1.0 | active | `shared/content/baoyu-format-markdown` |
| shared | content | `baoyu-markdown-to-html` | 0.1.0 | active | `shared/content/baoyu-markdown-to-html` |
| shared | content | `koubo-script-writer` | 0.1.0 | active | `shared/content/koubo-script-writer` |
| shared | content | `tech-article-writer` | 0.1.0 | active | `shared/content/tech-article-writer` |
| shared | knowledge | `knowledge-forge` | 0.2.0 | active | `shared/knowledge/knowledge-forge` |
| shared | media | `baoyu-article-illustrator` | 0.1.0 | active | `shared/media/baoyu-article-illustrator` |
| shared | media | `baoyu-comic` | 0.1.0 | active | `shared/media/baoyu-comic` |
| shared | media | `baoyu-compress-image` | 0.1.0 | active | `shared/media/baoyu-compress-image` |
| shared | media | `baoyu-cover-image` | 0.1.0 | active | `shared/media/baoyu-cover-image` |
| shared | media | `baoyu-danger-gemini-web` | 0.1.0 | active | `shared/media/baoyu-danger-gemini-web` |
| shared | media | `baoyu-image-gen` | 0.1.0 | active | `shared/media/baoyu-image-gen` |
| shared | media | `baoyu-infographic` | 0.1.0 | active | `shared/media/baoyu-infographic` |
| shared | media | `baoyu-slide-deck` | 0.1.0 | active | `shared/media/baoyu-slide-deck` |
| shared | notion | `notion-knowledge-capture` | 0.1.0 | active | `shared/notion/notion-knowledge-capture` |
| shared | notion | `notion-meeting-intelligence` | 0.1.0 | active | `shared/notion/notion-meeting-intelligence` |
| shared | notion | `notion-research-documentation` | 0.1.0 | active | `shared/notion/notion-research-documentation` |
| shared | notion | `notion-spec-to-implementation` | 0.1.0 | active | `shared/notion/notion-spec-to-implementation` |
| shared | obsidian | `json-canvas` | 0.1.0 | active | `shared/obsidian/json-canvas` |
| shared | obsidian | `obsidian-bases` | 0.1.0 | active | `shared/obsidian/obsidian-bases` |
| shared | obsidian | `obsidian-cli` | 0.1.0 | active | `shared/obsidian/obsidian-cli` |
| shared | obsidian | `obsidian-markdown` | 0.1.0 | active | `shared/obsidian/obsidian-markdown` |
| shared | publish | `baoyu-post-to-wechat` | 0.1.0 | active | `shared/publish/baoyu-post-to-wechat` |
| shared | publish | `baoyu-post-to-x` | 0.1.0 | active | `shared/publish/baoyu-post-to-x` |
| shared | web | `agent-reach` | 0.1.0 | active | `shared/web/agent-reach` |
| shared | web | `baoyu-danger-x-to-markdown` | 0.1.0 | active | `shared/web/baoyu-danger-x-to-markdown` |
| shared | web | `baoyu-url-to-markdown` | 0.1.0 | active | `shared/web/baoyu-url-to-markdown` |
| shared | web | `defuddle` | 0.1.0 | active | `shared/web/defuddle` |
| shared | xhs | `baoyu-xhs-images` | 0.1.0 | active | `shared/xhs/baoyu-xhs-images` |
| shared | xhs | `retro-enc` | 0.2.0 | active | `shared/xhs/retro-enc` |
| shared | xhs | `wanwu-content` | 1.0.0 | active | `shared/xhs/wanwu-content` |
| shared | xhs | `wanwu-cover` | 2.0.0 | active | `shared/xhs/wanwu-cover` |
| shared | xhs | `wanwu-series` | 1.0.0 | active | `shared/xhs/wanwu-series` |
| shared | xhs | `xhs-topic-miner` | 0.3.0 | active | `shared/xhs/xhs-topic-miner` |

## Trigger Summary

- `openclaw/claude/universal-claude-bridge`: Bidirectional bridge between OpenClaw and Claude Code. Handles Claude Code hooks (ask_user_question, permission_prompt, idle_prompt, tool_result, task_complete) via HTTP POST, forwards them to Telegram users, and routes user replies back to Claude Code sessions. Use when: (1) User wants to interact with Claude Code sessions via Telegram, (2) Receiving HTTP webhooks from Claude Code, (3) Managing persistent Claude Code sessions through OpenClaw.
- `openclaw/dev/ai-tmux-swarm`: 使用 tmux + git worktree + 系统 cron 编排多个 AI 编码子任务并行开发。提供可复制到仓库内的 swarm scaffold，支持 manifest 驱动任务定义、依赖感知调度、异常重试、OpenClaw system event 通知，以及可选 Telegram 回退通知。适用于需要在本地仓库里长期并行跑多个 Codex / Claude Code 子任务的场景，例如模块并行实现、分阶段集成、验收合并。
- `shared/content/baoyu-format-markdown`: Formats plain text or markdown files with frontmatter, titles, summaries, headings, bold, lists, and code blocks. Use when user asks to "format markdown", "beautify article", "add formatting", or improve article layout. Outputs to {filename}-formatted.md.
- `shared/content/baoyu-markdown-to-html`: Converts Markdown to styled HTML with WeChat-compatible themes. Supports code highlighting, math, PlantUML, footnotes, alerts, and infographics. Use when user asks for "markdown to html", "convert md to html", "md转html", or needs styled HTML output from markdown.
- `shared/content/tech-article-writer`: 技术分享文章写作引擎。输入主题素材（大纲/代码/笔记/口述要点/系列上下文），自动拆分章节、规划 mermaid 图表与代码示例位置、按既定风格写出完整教程式技术文章（Markdown）。风格基于《AI Coding 实战》系列 5.1-5.3 章节提炼：承上启下引言、为什么先于怎么做、prompt+验证闭环、验收清单收尾。触发词：写技术文章、技术教程、技术分享、写一篇教程、tech article、按系列风格写文章。
- `shared/knowledge/knowledge-forge`: >
- `shared/media/baoyu-article-illustrator`: Analyzes article structure, identifies positions requiring visual aids, generates illustrations with Type × Style two-dimension approach. Use when user asks to "illustrate article", "add images", "generate images for article", or "为文章配图".
- `shared/media/baoyu-comic`: Knowledge comic creator supporting multiple art styles and tones. Creates original educational comics with detailed panel layouts and sequential image generation. Use when user asks to create "知识漫画", "教育漫画", "biography comic", "tutorial comic", or "Logicomix-style comic".
- `shared/media/baoyu-compress-image`: Compresses images to WebP (default) or PNG with automatic tool selection. Use when user asks to "compress image", "optimize image", "convert to webp", or reduce image file size.
- `shared/media/baoyu-cover-image`: Generates article cover images with 5 dimensions (type, palette, rendering, text, mood) combining 9 color palettes and 6 rendering styles. Supports cinematic (2.35:1), widescreen (16:9), and square (1:1) aspects. Use when user asks to "generate cover image", "create article cover", or "make cover".
- `shared/media/baoyu-danger-gemini-web`: Generates images and text via reverse-engineered Gemini Web API. Supports text generation, image generation from prompts, reference images for vision input, and multi-turn conversations. Use when other skills need image generation backend, or when user requests "generate image with Gemini", "Gemini text generation", or needs vision-capable AI generation.
- `shared/media/baoyu-image-gen`: AI image generation with OpenAI, Google and DashScope APIs. Supports text-to-image, reference images, aspect ratios. Sequential by default; parallel generation available on request. Use when user asks to generate, create, or draw images.
- `shared/media/baoyu-infographic`: Generates professional infographics with 20 layout types and 17 visual styles. Analyzes content, recommends layout×style combinations, and generates publication-ready infographics. Use when user asks to create "infographic", "信息图", "visual summary", or "可视化".
- `shared/media/baoyu-slide-deck`: Generates professional slide deck images from content. Creates outlines with style instructions, then generates individual slide images. Use when user asks to "create slides", "make a presentation", "generate deck", "slide deck", or "PPT".
- `shared/notion/notion-knowledge-capture`: Capture conversations and decisions into structured Notion pages; use when turning chats/notes into wiki entries, how-tos, decisions, or FAQs with proper linking.
- `shared/notion/notion-meeting-intelligence`: Prepare meeting materials with Notion context and Codex research; use when gathering context, drafting agendas/pre-reads, and tailoring materials to attendees.
- `shared/notion/notion-research-documentation`: Research across Notion and synthesize into structured documentation; use when gathering info from multiple Notion sources to produce briefs, comparisons, or reports with citations.
- `shared/notion/notion-spec-to-implementation`: Turn Notion specs into implementation plans, tasks, and progress tracking; use when implementing PRDs/feature specs and creating Notion plans + tasks from them.
- `shared/obsidian/json-canvas`: Create and edit JSON Canvas files (.canvas) with nodes, edges, groups, and connections. Use when working with .canvas files, creating visual canvases, mind maps, flowcharts, or when the user mentions Canvas files in Obsidian.
- `shared/obsidian/obsidian-bases`: Create and edit Obsidian Bases (.base files) with views, filters, formulas, and summaries. Use when working with .base files, creating database-like views of notes, or when the user mentions Bases, table views, card views, filters, or formulas in Obsidian.
- `shared/obsidian/obsidian-cli`: Interact with Obsidian vaults using the Obsidian CLI to read, create, search, and manage notes, tasks, properties, and more. Also supports plugin and theme development with commands to reload plugins, run JavaScript, capture errors, take screenshots, and inspect the DOM. Use when the user asks to interact with their Obsidian vault, manage notes, search vault content, perform vault operations from the command line, or develop and debug Obsidian plugins and themes.
- `shared/obsidian/obsidian-markdown`: Create and edit Obsidian Flavored Markdown with wikilinks, embeds, callouts, properties, and other Obsidian-specific syntax. Use when working with .md files in Obsidian, or when the user mentions wikilinks, callouts, frontmatter, tags, embeds, or Obsidian notes.
- `shared/publish/baoyu-post-to-wechat`: Posts content to WeChat Official Account (微信公众号) via API or Chrome CDP. Supports article posting (文章) with HTML, markdown, or plain text input, and image-text posting (贴图, formerly 图文) with multiple images. Use when user mentions "发布公众号", "post to wechat", "微信公众号", or "贴图/图文/文章".
- `shared/publish/baoyu-post-to-x`: Posts content and articles to X (Twitter). Supports regular posts with images/videos and X Articles (long-form Markdown). Uses real Chrome with CDP to bypass anti-automation. Use when user asks to "post to X", "tweet", "publish to Twitter", or "share on X".
- `shared/web/agent-reach`: >
- `shared/web/baoyu-danger-x-to-markdown`: Converts X (Twitter) tweets and articles to markdown with YAML front matter. Uses reverse-engineered API requiring user consent. Use when user mentions "X to markdown", "tweet to markdown", "save tweet", or provides x.com/twitter.com URLs for conversion.
- `shared/web/baoyu-url-to-markdown`: Fetch any URL and convert to markdown using Chrome CDP. Supports two modes - auto-capture on page load, or wait for user signal (for pages requiring login). Use when user wants to save a webpage as markdown.
- `shared/web/defuddle`: Extract clean markdown content from web pages using Defuddle CLI, removing clutter and navigation to save tokens. Use instead of WebFetch when the user provides a URL to read or analyze, for online documentation, articles, blog posts, or any standard web page.
- `shared/xhs/baoyu-xhs-images`: Generates Xiaohongshu (Little Red Book) infographic series with 10 visual styles and 8 layouts. Breaks content into 1-10 cartoon-style images optimized for XHS engagement. Use when user mentions "小红书图片", "XHS images", "RedNote infographics", "小红书种草", or wants social media infographics for Chinese platforms.
- `shared/xhs/retro-enc`: >
- `shared/xhs/wanwu-content`: >
- `shared/xhs/wanwu-cover`: >
- `shared/xhs/wanwu-series`: >
- `shared/xhs/xhs-topic-miner`: >
