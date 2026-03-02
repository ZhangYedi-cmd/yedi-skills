import type { TelegramConfig } from "../pipeline/types";

const BASE = "https://api.telegram.org/bot";

export interface TgMessage {
  message_id: number;
  chat: { id: number; type: string };
  text?: string;
  date: number;
}

export interface TgCallbackQuery {
  id: string;
  from: { id: number };
  message?: TgMessage;
  data?: string;
}

export interface TgUpdate {
  update_id: number;
  message?: TgMessage;
  callback_query?: TgCallbackQuery;
}

export interface InlineButton {
  text: string;
  callback_data: string;
}

async function apiCall<T>(
  token: string,
  method: string,
  body: Record<string, unknown>
): Promise<T> {
  const res = await fetch(`${BASE}${token}/${method}`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body),
  });
  const json = (await res.json()) as { ok: boolean; result: T; description?: string };
  if (!json.ok) {
    throw new Error(`Telegram API error [${method}]: ${json.description ?? "unknown"}`);
  }
  return json.result;
}

export async function sendMessage(
  config: TelegramConfig,
  text: string,
  inlineButtons?: InlineButton[][]
): Promise<TgMessage> {
  const body: Record<string, unknown> = {
    chat_id: config.chatId,
    text,
    parse_mode: "HTML",
  };
  if (inlineButtons) {
    body.reply_markup = { inline_keyboard: inlineButtons };
  }
  return apiCall<TgMessage>(config.botToken, "sendMessage", body);
}

export async function editMessageText(
  config: TelegramConfig,
  messageId: number,
  text: string,
  inlineButtons?: InlineButton[][]
): Promise<void> {
  const body: Record<string, unknown> = {
    chat_id: config.chatId,
    message_id: messageId,
    text,
    parse_mode: "HTML",
  };
  if (inlineButtons) {
    body.reply_markup = { inline_keyboard: inlineButtons };
  } else {
    body.reply_markup = { inline_keyboard: [] };
  }
  try {
    await apiCall(config.botToken, "editMessageText", body);
  } catch (e) {
    // Ignore "message is not modified" errors
    const msg = e instanceof Error ? e.message : String(e);
    if (!msg.includes("not modified")) throw e;
  }
}

export async function answerCallbackQuery(
  token: string,
  callbackQueryId: string,
  text?: string
): Promise<void> {
  await apiCall(token, "answerCallbackQuery", {
    callback_query_id: callbackQueryId,
    text: text ?? "",
  });
}

export async function getUpdates(
  token: string,
  offset: number,
  timeout = 30
): Promise<TgUpdate[]> {
  try {
    const res = await fetch(`${BASE}${token}/getUpdates`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ offset, timeout, allowed_updates: ["message", "callback_query"] }),
      signal: AbortSignal.timeout((timeout + 5) * 1000),
    });
    const json = (await res.json()) as { ok: boolean; result: TgUpdate[] };
    if (!json.ok) return [];
    return json.result;
  } catch {
    return [];
  }
}

/** Send a test message to validate bot token and chat ID */
export async function testConnection(config: TelegramConfig): Promise<void> {
  await sendMessage(config, "✅ xhs-daily-workflow 配置成功！机器人已连接。");
}

/** Format topic selection message */
export function formatTopicsMessage(topics: string[], date: string): string {
  const lines = [
    `📝 <b>今日小红书选题建议</b>`,
    `<i>${date}</i>`,
    ``,
    ...topics.map((t, i) => `${["1️⃣", "2️⃣", "3️⃣"][i]} ${t}`),
    ``,
    `请选择要创作的主题，或发送 <code>/custom 你的主题</code>`,
  ];
  return lines.join("\n");
}

export function topicButtons(topics: string[]): InlineButton[][] {
  return [
    [
      { text: "1️⃣", callback_data: "topic:0" },
      { text: "2️⃣", callback_data: "topic:1" },
      { text: "3️⃣", callback_data: "topic:2" },
    ],
  ];
}
