# SKILLS_INDEX

集中技能索引（自动生成）。修改 skill 后请重新运行：`python3 scripts/skill-maintenance.py all`。

| Scope | Namespace | Skill | Version | Status | Path |
|---|---|---|---|---|---|
| openclaw | claude | `dispatch-claude-code` | 0.1.0 | active | `openclaw/claude/dispatch-claude-code` |
| openclaw | claude | `openclaw-claude-code` | 0.1.0 | active | `openclaw/claude/openclaw-claude-code` |
| openclaw | claude | `universal-claude-bridge` | 0.1.0 | active | `openclaw/claude/universal-claude-bridge` |
| openclaw | xhs | `xhs-auto-post` | 0.1.0 | active | `openclaw/xhs/xhs-auto-post` |
| shared | agent | `agent-reach` | 0.1.0 | active | `shared/agent/agent-reach` |
| shared | xhs | `baoyu-article-illustrator` | 0.1.0 | active | `shared/xhs/baoyu-article-illustrator` |
| shared | xhs | `baoyu-comic` | 0.1.0 | active | `shared/xhs/baoyu-comic` |
| shared | xhs | `baoyu-compress-image` | 0.1.0 | active | `shared/xhs/baoyu-compress-image` |
| shared | xhs | `baoyu-cover-image` | 0.1.0 | active | `shared/xhs/baoyu-cover-image` |
| shared | xhs | `baoyu-danger-gemini-web` | 0.1.0 | active | `shared/xhs/baoyu-danger-gemini-web` |
| shared | xhs | `baoyu-danger-x-to-markdown` | 0.1.0 | active | `shared/xhs/baoyu-danger-x-to-markdown` |
| shared | xhs | `baoyu-format-markdown` | 0.1.0 | active | `shared/xhs/baoyu-format-markdown` |
| shared | xhs | `baoyu-image-gen` | 0.1.0 | active | `shared/xhs/baoyu-image-gen` |
| shared | xhs | `baoyu-infographic` | 0.1.0 | active | `shared/xhs/baoyu-infographic` |
| shared | xhs | `baoyu-markdown-to-html` | 0.1.0 | active | `shared/xhs/baoyu-markdown-to-html` |
| shared | xhs | `baoyu-post-to-wechat` | 0.1.0 | active | `shared/xhs/baoyu-post-to-wechat` |
| shared | xhs | `baoyu-post-to-x` | 0.1.0 | active | `shared/xhs/baoyu-post-to-x` |
| shared | xhs | `baoyu-slide-deck` | 0.1.0 | active | `shared/xhs/baoyu-slide-deck` |
| shared | xhs | `baoyu-url-to-markdown` | 0.1.0 | active | `shared/xhs/baoyu-url-to-markdown` |
| shared | xhs | `baoyu-xhs-images` | 0.1.0 | active | `shared/xhs/baoyu-xhs-images` |
| shared | xhs | `retro-enc` | 0.1.0 | active | `shared/xhs/retro-enc` |

## Trigger Summary

- `openclaw/claude/dispatch-claude-code`: 当用户在聊天中请求启动 Claude Code 执行任务时使用此技能。例如："帮我做个爬虫"、"写个脚本"、"用Claude Code写个东西"等。使用 /Users/yedi/claude-code-hooks/scripts/dispatch-claude-code.sh 派发任务。
- `openclaw/claude/openclaw-claude-code`: Control Claude Code via MCP protocol. Execute commands, read/write files, search code, and use all Claude Code tools programmatically with agent team support.
- `openclaw/claude/universal-claude-bridge`: Bidirectional bridge between OpenClaw and Claude Code. Handles Claude Code hooks (ask_user_question, permission_prompt, idle_prompt, tool_result, task_complete) via HTTP POST, forwards them to Telegram users, and routes user replies back to Claude Code sessions. Use when: (1) User wants to interact with Claude Code sessions via Telegram, (2) Receiving HTTP webhooks from Claude Code, (3) Managing persistent Claude Code sessions through OpenClaw.
- `openclaw/xhs/xhs-auto-post`: 小红书图文自动生成项目。OpenClaw 按预定义工作流编排 Claude Code，完成 Brief 生成、图片生成、质量审核、压缩、归档的完整流程。当用户说"做小红书"、"生成小红书内容"、"XHS 图文"、"帮我出一期小红书"时使用。
- `shared/agent/agent-reach`: >
- `shared/xhs/baoyu-article-illustrator`: Analyzes article structure, identifies positions requiring visual aids, generates illustrations with Type × Style two-dimension approach. Use when user asks to "illustrate article", "add images", "generate images for article", or "为文章配图".
- `shared/xhs/baoyu-comic`: Knowledge comic creator supporting multiple art styles and tones. Creates original educational comics with detailed panel layouts and sequential image generation. Use when user asks to create "知识漫画", "教育漫画", "biography comic", "tutorial comic", or "Logicomix-style comic".
- `shared/xhs/baoyu-compress-image`: Compresses images to WebP (default) or PNG with automatic tool selection. Use when user asks to "compress image", "optimize image", "convert to webp", or reduce image file size.
- `shared/xhs/baoyu-cover-image`: Generates article cover images with 5 dimensions (type, palette, rendering, text, mood) combining 9 color palettes and 6 rendering styles. Supports cinematic (2.35:1), widescreen (16:9), and square (1:1) aspects. Use when user asks to "generate cover image", "create article cover", or "make cover".
- `shared/xhs/baoyu-danger-gemini-web`: Generates images and text via reverse-engineered Gemini Web API. Supports text generation, image generation from prompts, reference images for vision input, and multi-turn conversations. Use when other skills need image generation backend, or when user requests "generate image with Gemini", "Gemini text generation", or needs vision-capable AI generation.
- `shared/xhs/baoyu-danger-x-to-markdown`: Converts X (Twitter) tweets and articles to markdown with YAML front matter. Uses reverse-engineered API requiring user consent. Use when user mentions "X to markdown", "tweet to markdown", "save tweet", or provides x.com/twitter.com URLs for conversion.
- `shared/xhs/baoyu-format-markdown`: Formats plain text or markdown files with frontmatter, titles, summaries, headings, bold, lists, and code blocks. Use when user asks to "format markdown", "beautify article", "add formatting", or improve article layout. Outputs to {filename}-formatted.md.
- `shared/xhs/baoyu-image-gen`: AI image generation with OpenAI, Google and DashScope APIs. Supports text-to-image, reference images, aspect ratios. Sequential by default; parallel generation available on request. Use when user asks to generate, create, or draw images.
- `shared/xhs/baoyu-infographic`: Generates professional infographics with 20 layout types and 17 visual styles. Analyzes content, recommends layout×style combinations, and generates publication-ready infographics. Use when user asks to create "infographic", "信息图", "visual summary", or "可视化".
- `shared/xhs/baoyu-markdown-to-html`: Converts Markdown to styled HTML with WeChat-compatible themes. Supports code highlighting, math, PlantUML, footnotes, alerts, and infographics. Use when user asks for "markdown to html", "convert md to html", "md转html", or needs styled HTML output from markdown.
- `shared/xhs/baoyu-post-to-wechat`: Posts content to WeChat Official Account (微信公众号) via API or Chrome CDP. Supports article posting (文章) with HTML, markdown, or plain text input, and image-text posting (贴图, formerly 图文) with multiple images. Use when user mentions "发布公众号", "post to wechat", "微信公众号", or "贴图/图文/文章".
- `shared/xhs/baoyu-post-to-x`: Posts content and articles to X (Twitter). Supports regular posts with images/videos and X Articles (long-form Markdown). Uses real Chrome with CDP to bypass anti-automation. Use when user asks to "post to X", "tweet", "publish to Twitter", or "share on X".
- `shared/xhs/baoyu-slide-deck`: Generates professional slide deck images from content. Creates outlines with style instructions, then generates individual slide images. Use when user asks to "create slides", "make a presentation", "generate deck", "slide deck", or "PPT".
- `shared/xhs/baoyu-url-to-markdown`: Fetch any URL and convert to markdown using Chrome CDP. Supports two modes - auto-capture on page load, or wait for user signal (for pages requiring login). Use when user wants to save a webpage as markdown.
- `shared/xhs/baoyu-xhs-images`: Generates Xiaohongshu (Little Red Book) infographic series with 10 visual styles and 8 layouts. Breaks content into 1-10 cartoon-style images optimized for XHS engagement. Use when user mentions "小红书图片", "XHS images", "RedNote infographics", "小红书种草", or wants social media infographics for Chinese platforms.
- `shared/xhs/retro-enc`: >
