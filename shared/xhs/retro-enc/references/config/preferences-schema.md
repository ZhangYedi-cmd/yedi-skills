# Preferences (EXTEND.md)

```yaml
retro-encyclopedia:
  language: zh           # zh / en
  default_orientation: portrait
  default_pages: 5       # 2-8
  watermark:
    enabled: false
    content: "@yourname"
    position: bottom-right
  credit:
    enabled: true
    format: "作者:@yourname"
    position: bottom-right
  preferred_model: auto  # gemini / gpt / nano-banana / auto
  style_tweaks:
    paper_aging: medium   # light / medium / heavy
    humor_level: high     # low / medium / high
    info_density: high    # medium / high / extreme
```

## 首次设置
用 AskUserQuestion 收集：语言 / 方向 / 水印 / 署名 / 模型
