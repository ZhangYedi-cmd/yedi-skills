import { chatCompletion } from "../lib/claude-client";
import type { AppConfig } from "./types";

const SYSTEM_PROMPT = `你是一位专业的小红书内容策划师，擅长为特定领域的博主生成高质量的选题方向。

你需要生成3个小红书图文选题，要求：
1. 每个选题包含内容类型标注（干货/故事/测评/教程/避坑等）
2. 选题要具体、有吸引力，能引起目标受众共鸣
3. 三个选题类型要有差异性（例如：一个干货、一个故事、一个测评）
4. 选题要结合当前时间和热点
5. 每个选题20-40字，适合作为小红书标题

输出格式（严格按照此格式，不要添加额外说明）：
1. [选题内容]（类型）
2. [选题内容]（类型）
3. [选题内容]（类型）`;

/**
 * Generate 3 topic suggestions for today using Claude API.
 * Returns an array of 3 topic strings.
 */
export async function generateTopics(config: AppConfig): Promise<string[]> {
  const today = new Date().toLocaleDateString("zh-CN", {
    year: "numeric",
    month: "long",
    day: "numeric",
    weekday: "long",
  });

  const userMessage = `今天是${today}。
请为以下领域的小红书博主生成3个今日选题：

领域/方向：${config.xhs.niche}

要求差异化：选题类型要多样（干货、故事、测评等），不要都是同一类型。`;

  const response = await chatCompletion(
    config.anthropic,
    SYSTEM_PROMPT,
    userMessage,
    512
  );

  const topics = parseTopics(response);
  if (topics.length !== 3) {
    throw new Error(`Expected 3 topics, got ${topics.length}. Response: ${response}`);
  }
  return topics;
}

function parseTopics(text: string): string[] {
  const lines = text.trim().split("\n");
  const topics: string[] = [];

  for (const line of lines) {
    const match = line.match(/^\d+\.\s+(.+)$/);
    if (match && match[1]) {
      topics.push(match[1].trim());
    }
  }

  return topics;
}
