// Shared types for xhs-daily-workflow

export interface TelegramConfig {
  botToken: string;
  chatId: string;
  mode: "polling" | "webhook";
}

export interface AnthropicConfig {
  apiKey: string;
  model: string;
}

export interface ObsidianConfig {
  vaultPath: string;
}

export interface XhsConfig {
  niche: string;
  defaultStyle: string;
  imageCount: number;
  watermark: {
    enabled: boolean;
    content?: string;
    position?: string;
    opacity?: number;
  };
}

export interface ScheduleConfig {
  hour: number;
  minute: number;
}

export interface AppConfig {
  version: number;
  telegram: TelegramConfig;
  anthropic: AnthropicConfig;
  obsidian: ObsidianConfig;
  xhs: XhsConfig;
  schedule: ScheduleConfig;
  serverPort: number;
  runsDir: string;
}

// Session state machine
export type SessionPhase =
  | "idle"
  | "awaiting_selection"
  | "generating"
  | "complete"
  | "error";

export interface Session {
  chatId: string;
  phase: SessionPhase;
  messageId?: number;
  progressMessageId?: number;
  topics: string[];
  selectedTopic?: string;
  runId?: string;
  startedAt: string;
  completedAt?: string;
  error?: string;
}

export interface AppState {
  sessions: Record<string, Session>;
  lastOffset: number;
}

// Analysis result
export interface AnalysisResult {
  title: string;
  topic: string;
  contentType: string;
  sourceLanguage: string;
  recommendedImageCount: number;
  strategy: "a" | "b" | "c";
  style: string;
  layout: string;
  targetAudience: string;
  hookAnalysis: string;
  swipeFlow: string;
}

// Outline entry (one image in the series)
export interface OutlineEntry {
  imageNum: number;
  totalImages: number;
  position: "cover" | "content" | "ending";
  layout: string;
  hook?: string;
  coreMessage: string;
  slug: string;
  filename: string;
  textContent: string;
  visualConcept: string;
  swipeHook?: string;
}

// Full outline
export interface Outline {
  strategy: "a" | "b" | "c";
  name: string;
  style: string;
  layout: string;
  imageCount: number;
  topic: string;
  entries: OutlineEntry[];
}

// Run context (passed through pipeline stages)
export interface RunContext {
  runId: string;
  runDir: string;
  topic: string;
  config: AppConfig;
  analysis?: AnalysisResult;
  outline?: Outline;
  promptFiles?: string[];
  generatedImages?: string[];
  obsidianPath?: string;
}
