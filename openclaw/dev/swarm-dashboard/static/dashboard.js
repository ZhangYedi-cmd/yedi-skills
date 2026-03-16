/* ================================================================
   Swarm Dashboard — frontend logic
   DAG rendering (dagre), SSE, detail panel, log viewer
   ================================================================ */

(function () {
  "use strict";

  // ---- State -----------------------------------------------------------

  let currentState = null;
  let selectedTaskId = null;
  let stateSSE = null;
  let logSSE = null;
  let logPaused = false;
  let reconnectDelay = 1000;
  let uptimeInterval = null;

  // SVG pan/zoom state
  let svgTransform = { x: 0, y: 0, scale: 1 };
  let isPanning = false;
  let panStart = { x: 0, y: 0 };

  // ---- DOM refs --------------------------------------------------------

  const $ = (sel) => document.querySelector(sel);
  const $$ = (sel) => document.querySelectorAll(sel);

  const dagSvg = $("#dag-svg");
  const detailPlaceholder = $("#detail-placeholder");
  const taskDetail = $("#task-detail");
  const logViewer = $("#log-viewer");
  const logContent = $("#log-content");
  const connStatus = $("#conn-status");
  const lastUpdate = $("#last-update");

  // ---- Initialization --------------------------------------------------

  async function init() {
    setupTabs();
    setupLogControls();
    setupCopyable();
    setupSvgPanZoom();

    // Initial data fetch
    try {
      const res = await fetch("/api/state");
      if (res.ok) {
        currentState = await res.json();
        onStateUpdate(currentState);
      }
    } catch (e) {
      console.warn("Initial state fetch failed:", e);
    }

    connectStateSSE();
  }

  // ---- SSE: state ------------------------------------------------------

  function connectStateSSE() {
    if (stateSSE) {
      stateSSE.close();
    }

    stateSSE = new EventSource("/api/events/state");

    stateSSE.onopen = () => {
      setConnStatus("connected");
      reconnectDelay = 1000;
    };

    stateSSE.onmessage = (evt) => {
      try {
        const state = JSON.parse(evt.data);
        currentState = state;
        onStateUpdate(state);
      } catch (e) {
        console.warn("SSE parse error:", e);
      }
    };

    stateSSE.onerror = () => {
      setConnStatus("reconnecting");
      stateSSE.close();
      setTimeout(() => {
        reconnectDelay = Math.min(reconnectDelay * 2, 30000);
        connectStateSSE();
      }, reconnectDelay);
    };
  }

  // ---- SSE: logs -------------------------------------------------------

  function connectLogSSE(slug) {
    disconnectLogSSE();
    logContent.textContent = "";

    logSSE = new EventSource(`/api/events/logs/${slug}`);

    logSSE.onmessage = (evt) => {
      if (!logPaused) {
        logContent.textContent += evt.data + "\n";
        logContent.scrollTop = logContent.scrollHeight;
      }
    };

    logSSE.onerror = () => {
      // Silent reconnect — the EventSource API handles this
    };
  }

  function disconnectLogSSE() {
    if (logSSE) {
      logSSE.close();
      logSSE = null;
    }
  }

  // ---- State update handler --------------------------------------------

  function onStateUpdate(state) {
    updateHeader(state);
    renderDAG(state);
    updateLastUpdateTime();

    // Refresh detail panel if a task is selected
    if (selectedTaskId) {
      const task = findTask(state, selectedTaskId);
      if (task) {
        showTaskDetail(task);
      }
    }
  }

  // ---- Header ----------------------------------------------------------

  function updateHeader(state) {
    const repoSlug = state.repo_slug || state.repo_root?.split("/").pop() || "swarm";
    $("#repo-name").textContent = repoSlug;
    document.title = `${repoSlug} — Swarm Dashboard`;

    // Status counts
    const counts = { pending: 0, running: 0, retrying: 0, done: 0, failed: 0 };
    (state.tasks || []).forEach((t) => {
      if (counts[t.status] !== undefined) counts[t.status]++;
    });
    for (const [status, count] of Object.entries(counts)) {
      $(`#stat-${status}`).textContent = count;
    }

    // Uptime
    startUptime(state.created_at);
  }

  function startUptime(createdAt) {
    if (uptimeInterval) clearInterval(uptimeInterval);
    if (!createdAt) return;

    const start = new Date(createdAt).getTime();
    function tick() {
      const elapsed = Math.max(0, Math.floor((Date.now() - start) / 1000));
      const h = String(Math.floor(elapsed / 3600)).padStart(2, "0");
      const m = String(Math.floor((elapsed % 3600) / 60)).padStart(2, "0");
      const s = String(elapsed % 60).padStart(2, "0");
      $("#uptime").textContent = `${h}:${m}:${s}`;
    }
    tick();
    uptimeInterval = setInterval(tick, 1000);
  }

  // ---- DAG rendering ---------------------------------------------------

  function renderDAG(state) {
    const tasks = state.tasks || [];
    if (!tasks.length) return;

    // Check if dagre is available
    if (typeof dagre === "undefined") {
      dagSvg.innerHTML = `<text x="20" y="40" fill="#8b8fa3" font-size="14">dagre library not loaded</text>`;
      return;
    }

    // Build dagre graph
    const g = new dagre.graphlib.Graph();
    g.setGraph({
      rankdir: "TB",
      nodesep: 40,
      ranksep: 60,
      marginx: 30,
      marginy: 30,
    });
    g.setDefaultEdgeLabel(() => ({}));

    const nodeWidth = 160;
    const nodeHeight = 52;

    tasks.forEach((task) => {
      g.setNode(task.id, {
        label: task.id,
        width: nodeWidth,
        height: nodeHeight,
        status: task.status,
        description: task.description || "",
      });
    });

    tasks.forEach((task) => {
      (task.depends_on || []).forEach((dep) => {
        g.setEdge(dep, task.id);
      });
    });

    dagre.layout(g);

    // Build SVG
    const graph = g.graph();
    let svg = "";

    // Defs for arrowhead
    svg += `<defs>
      <marker id="arrowhead" viewBox="0 0 10 10" refX="10" refY="5"
              markerWidth="8" markerHeight="8" orient="auto-start-reverse">
        <path d="M 0 0 L 10 5 L 0 10 z" class="dag-arrowhead"/>
      </marker>
    </defs>`;

    // Group for pan/zoom
    svg += `<g id="dag-content" transform="translate(${svgTransform.x},${svgTransform.y}) scale(${svgTransform.scale})">`;

    // Edges
    g.edges().forEach((e) => {
      const edge = g.edge(e);
      const points = edge.points || [];
      if (points.length >= 2) {
        let d = `M ${points[0].x} ${points[0].y}`;
        for (let i = 1; i < points.length; i++) {
          d += ` L ${points[i].x} ${points[i].y}`;
        }
        svg += `<path class="dag-edge" d="${d}" marker-end="url(#arrowhead)"/>`;
      }
    });

    // Nodes
    g.nodes().forEach((nodeId) => {
      const node = g.node(nodeId);
      const x = node.x - nodeWidth / 2;
      const y = node.y - nodeHeight / 2;
      const status = node.status || "pending";
      const isSelected = nodeId === selectedTaskId;
      const selectedClass = isSelected ? " selected" : "";

      svg += `<g class="dag-node ${status}${selectedClass}" data-task-id="${escapeHtml(nodeId)}" onclick="window.__selectTask('${escapeHtml(nodeId)}')">`;
      svg += `<rect x="${x}" y="${y}" width="${nodeWidth}" height="${nodeHeight}"/>`;
      svg += `<text x="${node.x}" y="${node.y - 4}" text-anchor="middle" dominant-baseline="middle">${escapeHtml(nodeId)}</text>`;
      svg += `<text x="${node.x}" y="${node.y + 14}" text-anchor="middle" dominant-baseline="middle" class="node-status-text">${status}</text>`;
      svg += `</g>`;
    });

    svg += `</g>`;

    dagSvg.innerHTML = svg;

    // Set viewBox to fit content
    const padding = 20;
    dagSvg.setAttribute(
      "viewBox",
      `${-padding} ${-padding} ${graph.width + padding * 2} ${graph.height + padding * 2}`
    );
  }

  // ---- SVG pan/zoom ----------------------------------------------------

  function setupSvgPanZoom() {
    dagSvg.addEventListener("mousedown", (e) => {
      if (e.target.closest(".dag-node")) return;
      isPanning = true;
      panStart = { x: e.clientX - svgTransform.x, y: e.clientY - svgTransform.y };
    });

    window.addEventListener("mousemove", (e) => {
      if (!isPanning) return;
      svgTransform.x = e.clientX - panStart.x;
      svgTransform.y = e.clientY - panStart.y;
      applyTransform();
    });

    window.addEventListener("mouseup", () => {
      isPanning = false;
    });

    dagSvg.addEventListener("wheel", (e) => {
      e.preventDefault();
      const factor = e.deltaY > 0 ? 0.9 : 1.1;
      const newScale = Math.max(0.3, Math.min(3, svgTransform.scale * factor));
      svgTransform.scale = newScale;
      applyTransform();
    }, { passive: false });
  }

  function applyTransform() {
    const content = document.getElementById("dag-content");
    if (content) {
      content.setAttribute(
        "transform",
        `translate(${svgTransform.x},${svgTransform.y}) scale(${svgTransform.scale})`
      );
    }
  }

  // ---- Task selection --------------------------------------------------

  window.__selectTask = function (taskId) {
    selectedTaskId = taskId;
    if (!currentState) return;

    const task = findTask(currentState, taskId);
    if (task) {
      showTaskDetail(task);
      highlightNode(taskId);
    }
  };

  function showTaskDetail(task) {
    detailPlaceholder.classList.add("hidden");
    taskDetail.classList.remove("hidden");

    $("#detail-title").textContent = task.id;
    const badge = $("#detail-status");
    badge.textContent = task.status;
    badge.className = `status-badge ${task.status}`;

    $("#detail-id").textContent = task.id;
    $("#detail-desc").textContent = task.description || "--";
    $("#detail-engine").textContent = `${task.engine || "--"} / ${task.model || "--"}`;
    $("#detail-branch").textContent = task.branch || "--";
    $("#detail-started").textContent = formatTime(task.started_at);
    $("#detail-completed").textContent = formatTime(task.completed_at);
    $("#detail-attempts").textContent = task.attempt_count ?? "--";
    $("#detail-restarts").textContent = `${task.restart_count ?? 0} / ${task.max_restarts ?? 0}`;
    $("#detail-exit-code").textContent = task.last_exit_code ?? "--";
    $("#detail-note").textContent = task.note || "--";
    $("#detail-deps").textContent =
      task.depends_on && task.depends_on.length
        ? task.depends_on.join(", ")
        : "(none)";

    // Load prompt
    loadPrompt(task.slug || task.id);

    // If logs tab is active, connect log SSE
    const activeTab = document.querySelector(".tab-btn.active");
    if (activeTab && activeTab.dataset.tab === "logs") {
      connectLogSSE(task.slug || task.id);
    }
  }

  async function loadPrompt(slug) {
    const pre = $("#prompt-content");
    pre.textContent = "Loading...";
    try {
      const res = await fetch(`/api/prompt/${slug}`);
      if (res.ok) {
        const data = await res.json();
        pre.textContent = data.content || "(empty)";
      } else {
        pre.textContent = "(prompt not available)";
      }
    } catch (e) {
      pre.textContent = "(failed to load)";
    }
  }

  function highlightNode(taskId) {
    $$(".dag-node").forEach((node) => {
      node.classList.toggle("selected", node.dataset.taskId === taskId);
    });
  }

  // ---- Tabs ------------------------------------------------------------

  function setupTabs() {
    $$(".tab-btn").forEach((btn) => {
      btn.addEventListener("click", () => {
        $$(".tab-btn").forEach((b) => b.classList.remove("active"));
        btn.classList.add("active");

        const tab = btn.dataset.tab;
        if (tab === "logs") {
          logViewer.classList.remove("hidden");
          if (selectedTaskId && currentState) {
            const task = findTask(currentState, selectedTaskId);
            if (task) connectLogSSE(task.slug || task.id);
          }
        } else {
          logViewer.classList.add("hidden");
          disconnectLogSSE();
        }
      });
    });
  }

  // ---- Log controls ----------------------------------------------------

  function setupLogControls() {
    $("#log-pause-btn").addEventListener("click", function () {
      logPaused = !logPaused;
      this.textContent = logPaused ? "Resume" : "Pause";
      this.classList.toggle("active", logPaused);
    });

    $("#log-clear-btn").addEventListener("click", () => {
      logContent.textContent = "";
    });
  }

  // ---- Copy on click ---------------------------------------------------

  function setupCopyable() {
    document.addEventListener("click", (e) => {
      const el = e.target.closest(".copyable");
      if (!el) return;
      const text = el.textContent;
      if (!text || text === "--") return;
      navigator.clipboard.writeText(text).then(() => {
        const orig = el.textContent;
        el.textContent = "Copied!";
        setTimeout(() => (el.textContent = orig), 1000);
      });
    });
  }

  // ---- Helpers ---------------------------------------------------------

  function findTask(state, id) {
    return (state.tasks || []).find((t) => t.id === id || t.slug === id);
  }

  function formatTime(iso) {
    if (!iso) return "--";
    try {
      const d = new Date(iso);
      return d.toLocaleTimeString() + " " + d.toLocaleDateString();
    } catch {
      return iso;
    }
  }

  function escapeHtml(str) {
    return str
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#039;");
  }

  function setConnStatus(status) {
    connStatus.className = `conn-indicator ${status}`;
    const labels = { connected: "Connected", disconnected: "Disconnected", reconnecting: "Reconnecting..." };
    connStatus.textContent = labels[status] || status;
  }

  function updateLastUpdateTime() {
    const now = new Date();
    lastUpdate.textContent = `Last update: ${now.toLocaleTimeString()}`;
  }

  // ---- Boot ------------------------------------------------------------

  document.addEventListener("DOMContentLoaded", init);
})();
