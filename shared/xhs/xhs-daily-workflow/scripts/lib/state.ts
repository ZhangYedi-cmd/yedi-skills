import path from "node:path";
import { readFile, writeFile, mkdir } from "node:fs/promises";
import { CONFIG_DIR } from "./config";
import type { AppState, Session } from "../pipeline/types";

const STATE_PATH = path.join(CONFIG_DIR, "state.json");

const DEFAULT_STATE: AppState = {
  sessions: {},
  lastOffset: 0,
};

let _state: AppState | null = null;

export async function loadState(): Promise<AppState> {
  if (_state) return _state;
  try {
    const raw = await readFile(STATE_PATH, "utf8");
    _state = { ...DEFAULT_STATE, ...JSON.parse(raw) };
  } catch {
    _state = { ...DEFAULT_STATE };
  }
  return _state!;
}

export async function saveState(state: AppState): Promise<void> {
  _state = state;
  await mkdir(CONFIG_DIR, { recursive: true });
  // Atomic write via temp file rename
  const tmp = STATE_PATH + ".tmp";
  await writeFile(tmp, JSON.stringify(state, null, 2), "utf8");
  const { rename } = await import("node:fs/promises");
  await rename(tmp, STATE_PATH);
}

export async function getSession(chatId: string): Promise<Session | null> {
  const state = await loadState();
  return state.sessions[chatId] ?? null;
}

export async function setSession(session: Session): Promise<void> {
  const state = await loadState();
  state.sessions[session.chatId] = session;
  await saveState(state);
}

export async function clearSession(chatId: string): Promise<void> {
  const state = await loadState();
  delete state.sessions[chatId];
  await saveState(state);
}

export async function getLastOffset(): Promise<number> {
  const state = await loadState();
  return state.lastOffset;
}

export async function setLastOffset(offset: number): Promise<void> {
  const state = await loadState();
  state.lastOffset = offset;
  await saveState(state);
}

export function newSession(chatId: string): Session {
  return {
    chatId,
    phase: "idle",
    topics: [],
    startedAt: new Date().toISOString(),
  };
}
