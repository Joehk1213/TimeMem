import cookieParser from "cookie-parser";
import express from "express";
import helmet from "helmet";
import rateLimit from "express-rate-limit";
import { createProxyMiddleware } from "http-proxy-middleware";
import { bootstrapOwner, currentSession, login, logout, requireAuth } from "./auth.js";
import { createRecord, deleteRecord, getRecord, listRecords, updateRecord } from "./crud.js";
import { pingDatabase } from "./db.js";

const AI_PORT = process.env.AI_PORT || "5001";
const RAG_PORT = process.env.RAG_PORT || "5002";
const FRONTEND_URL = process.env.FRONTEND_URL || "http://frontend:80";
const asyncRoute = (handler) => (req, res, next) => Promise.resolve(handler(req, res, next)).catch(next);

async function childHealth(port) {
  try {
    const response = await fetch(`http://127.0.0.1:${port}/health`, { signal: AbortSignal.timeout(3000) });
    return response.ok;
  } catch {
    return false;
  }
}

export function createApp({ websocketNotifier = () => {} } = {}) {
  const app = express();
  app.disable("x-powered-by");
  app.set("trust proxy", 1);
  app.use(helmet({ contentSecurityPolicy: false }));
  app.use(express.json({ limit: "1mb" }));
  app.use(cookieParser());
  app.use("/api", rateLimit({ windowMs: 60_000, limit: 120, standardHeaders: "draft-7", legacyHeaders: false }));

  app.get("/health", (_req, res) => res.json({ status: "ok", service: "gateway", port: Number(process.env.PORT || 444) }));
  app.get("/ready", async (_req, res) => {
    const [database, ai, rag] = await Promise.all([pingDatabase().catch(() => false), childHealth(AI_PORT), childHealth(RAG_PORT)]);
    const status = database && ai && rag;
    res.status(status ? 200 : 503).json({ status: status ? "ready" : "not_ready", database, ai, rag });
  });

  app.post("/api/v1/auth/login", asyncRoute(login));
  app.post("/api/v1/auth/logout", asyncRoute(logout));
  app.get("/api/v1/auth/session", requireAuth, currentSession);
  app.use("/api", requireAuth);
  app.use((req, _res, next) => {
    req.recordChange = websocketNotifier;
    next();
  });

  app.get("/api/v1/:type(events|todos)", listRecords);
  app.post("/api/v1/:type(events|todos)", createRecord);
  app.get("/api/v1/:type(events|todos)/:id", getRecord);
  app.patch("/api/v1/:type(events|todos)/:id", updateRecord);
  app.delete("/api/v1/:type(events|todos)/:id", deleteRecord);
  app.use("/api/ai", createProxyMiddleware({
    target: `http://127.0.0.1:${AI_PORT}`,
    changeOrigin: true,
    pathRewrite: { "^/api/ai": "" },
    proxyTimeout: 15_000
  }));
  app.use("/api/rag", createProxyMiddleware({
    target: `http://127.0.0.1:${RAG_PORT}`,
    changeOrigin: true,
    pathRewrite: { "^/api/rag": "" },
    proxyTimeout: 15_000
  }));

  app.use("/", createProxyMiddleware({
    target: FRONTEND_URL,
    changeOrigin: true,
    ws: true,
    proxyTimeout: 15_000
  }));

  app.use((error, _req, res, _next) => {
    console.error(JSON.stringify({ event: "request_error", message: error.message }));
    const status = Number.isInteger(error.status) ? error.status : 500;
    res.status(status).json({ error: { code: status >= 500 ? "INTERNAL_ERROR" : "REQUEST_ERROR", message: status >= 500 ? "Internal server error." : error.message } });
  });
  return app;
}

export async function start() {
  await bootstrapOwner();
}
