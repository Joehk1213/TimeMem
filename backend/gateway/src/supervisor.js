import { spawn } from "node:child_process";

const children = [];
let stopping = false;

function launch(name, command, args, env = {}, cwd = undefined) {
  const child = spawn(command, args, {
    cwd,
    env: { ...process.env, PYTHONUNBUFFERED: "1", ...env },
    stdio: "inherit"
  });
  children.push(child);
  child.on("exit", (code, signal) => {
    if (!stopping) {
      console.error(JSON.stringify({ event: "child_exited", name, code, signal }));
      stop(code || 1);
    }
  });
  child.on("error", (error) => {
    console.error(JSON.stringify({ event: "child_spawn_error", name, message: error.message }));
    stop(1);
  });
  return child;
}

function stop(exitCode = 0) {
  if (stopping) return;
  stopping = true;
  for (const child of children) {
    if (!child.killed) child.kill("SIGTERM");
  }
  setTimeout(() => process.exit(exitCode), 1000).unref();
}

launch("ai", "/opt/venv/bin/python", ["-m", "uvicorn", "ai.main:app", "--host", "127.0.0.1", "--port", process.env.AI_PORT || "5001"], {}, "/app/python");
launch("rag", "/opt/venv/bin/python", ["-m", "uvicorn", "rag.main:app", "--host", "127.0.0.1", "--port", process.env.RAG_PORT || "5002"], {}, "/app/python");
launch("gateway", "node", ["/app/gateway/src/server.js"]);

process.on("SIGTERM", () => stop(0));
process.on("SIGINT", () => stop(0));
