---
name: watermark-guide
description: Watermark configuration guide for wanwu-tujian
---

# 水印指南

## 位置示意图

```
┌─────────────────────────────┐
│                  [top-right]│
│                             │
│                             │
│         IMAGE CONTENT       │
│                             │
│                             │
│[bottom-left][bottom-center][bottom-right]│
└─────────────────────────────┘
```

## 位置建议

| 位置 | 适合 | 避免 |
|------|------|------|
| `bottom-right` | 默认选择，最常用 | 右下有关键信息时 |
| `bottom-left` | 右侧偏重的版面 | 左下有关键信息时 |
| `bottom-center` | 居中设计 | 底部文字密集时 |
| `top-right` | 底部内容多时 | 有角标印章时（会冲突） |

> **注意**：万物图鉴风格的角标印章在左上+右上角，`top-right` 水印可能与角标冲突，建议使用底部位置。

## 内容格式

| 格式 | 示例 | 风格 |
|------|------|------|
| 账号名 | `@知渡` | 小红书最常用 |
| 品牌名 | `知渡` | 简洁品牌 |
| 中文格式 | `小红书:知渡` | 平台标注 |

## 最佳实践

1. **一致性**: 系列所有图片使用相同水印
2. **可读性**: 确保水印在浅色/深色区域均可辨认
3. **大小**: 保持微妙，不分散内容注意力
4. **位置**: 避开知识块、角标印章等核心视觉区域

## Prompt 集成

当水印启用时，添加到图片生成 prompt 中：

```
Include a subtle watermark "[content]" positioned at [position].
The watermark should be legible but not distracting from the main content.
```

## 常见问题

| 问题 | 解决方案 |
|------|----------|
| 水印不可见 | 调整位置或检查对比度 |
| 水印太突出 | 更换位置或减小尺寸 |
| 水印与内容重叠 | 更换位置 |
| 系列内不一致 | 使用 Session ID 确保一致 |
