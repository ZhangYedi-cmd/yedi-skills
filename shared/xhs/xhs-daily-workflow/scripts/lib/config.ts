import path from "node:path";
import { homedir } from "node:os";
import { readFile, writeFile, mkdir, access } from "node:fs/promises";
import type { AppConfig } from "../pipeline/types";

export const CONFIG_DIR = path.join(homedir(), ".baoyu-skills", "xhs-daily-workflow");
export const CONFIG_PATH = path.join(CONFIG_DIR, "config.json");

export const DEFAULT_CONFIG: AppConfig = {
  version: 1,
  telegram: {
    botToken: "",
    chatId: "",
    mode: "polling",
  },
  anthropic: {
    apiKey: "",
    model: "claude-sonnet-4-6",
  },
  obsidian: {
    vaultPath: "",
  },
  xhs: {
    niche: "AI工具/效率/生产力",
    defaultStyle: "notion",
    imageCount: 5,
    watermark: {
      enabled: false,
    },
  },
  schedule: {
    hour: 9,
    minute: 0,
  },
  serverPort: 7788,
  runsDir: path.join(CONFIG_DIR, "runs"),
};

export async function configExists(): Promise<boolean> {
  try {
    await access(CONFIG_PATH);
    return true;
  } catch {
    return false;
  }
}

export async function loadConfig(): Promise<AppConfig> {
  try {
    const raw = await readFile(CONFIG_PATH, "utf8");
    const parsed = JSON.parse(raw);
    // Expand ~ in runsDir and vaultPath
    if (parsed.runsDir) {
      parsed.runsDir = expandHome(parsed.runsDir);
    }
    if (parsed.obsidian?.vaultPath) {
      parsed.obsidian.vaultPath = expandHome(parsed.obsidian.vaultPath);
    }
    return { ...DEFAULT_CONFIG, ...parsed };
  } catch (e) {
    throw new Error(`Failed to load config from ${CONFIG_PATH}: ${e instanceof Error ? e.message : e}`);
  }
}

export async function saveConfig(config: AppConfig): Promise<void> {
  await mkdir(CONFIG_DIR, { recursive: true });
  await writeFile(CONFIG_PATH, JSON.stringify(config, null, 2), "utf8");
}

export function expandHome(p: string): string {
  if (p.startsWith("~/")) {
    return path.join(homedir(), p.slice(2));
  }
  return p;
}

/** Detect common Obsidian vault locations on macOS */
export async function detectObsidianVaults(): Promise<string[]> {
  const candidates = [
    // iCloud (most common)
    path.join(homedir(), "Library", "Mobile Documents", "iCloud~md~obsidian", "Documents"),
    // Local
    path.join(homedir(), "Documents", "Obsidian"),
    path.join(homedir(), "Obsidian"),
  ];

  const found: string[] = [];
  for (const candidate of candidates) {
    try {
      await access(candidate);
      found.push(candidate);
    } catch {
      // not found
    }
  }
  return found;
}

/** Find all vault subdirectories under a base path */
export async function listVaults(basePath: string): Promise<string[]> {
  const { readdir } = await import("node:fs/promises");
  try {
    const entries = await readdir(basePath, { withFileTypes: true });
    return entries
      .filter((e) => e.isDirectory() && !e.name.startsWith("."))
      .map((e) => path.join(basePath, e.name));
  } catch {
    return [];
  }
}
