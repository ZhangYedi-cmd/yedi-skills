import Anthropic from "@anthropic-ai/sdk";
import type { AnthropicConfig } from "../pipeline/types";

let _client: Anthropic | null = null;

export function getClient(config: AnthropicConfig): Anthropic {
  if (!_client) {
    _client = new Anthropic({ apiKey: config.apiKey });
  }
  return _client;
}

export async function chatCompletion(
  config: AnthropicConfig,
  systemPrompt: string,
  userMessage: string,
  maxTokens = 2048
): Promise<string> {
  const client = getClient(config);
  const response = await client.messages.create({
    model: config.model,
    max_tokens: maxTokens,
    system: systemPrompt,
    messages: [{ role: "user", content: userMessage }],
  });

  const block = response.content[0];
  if (!block || block.type !== "text") {
    throw new Error("No text content in Claude API response");
  }
  return block.text;
}
