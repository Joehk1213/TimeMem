import http from "node:http";
import { WebSocketServer, WebSocket } from "ws";
import { createApp, start } from "./app.js";
import { memberFromToken } from "./auth.js";

const port = Number(process.env.PORT || 444);
const clients = new Set();
const notify = (message) => {
  const payload = JSON.stringify({ type: "record_change", ...message });
  for (const client of clients) {
    if (client.readyState === WebSocket.OPEN) client.send(payload);
  }
};

await start();
const server = http.createServer(createApp({ websocketNotifier: notify }));
const wss = new WebSocketServer({ noServer: true });

server.on("upgrade", async (request, socket, head) => {
  if (request.url?.split("?")[0] !== "/ws") return socket.destroy();
  try {
    const cookie = request.headers.cookie
      ?.split(";")
      .map((part) => part.trim())
      .find((part) => part.startsWith("timemem_session="));
    const token = cookie ? decodeURIComponent(cookie.slice("timemem_session=".length)) : null;
    const member = await memberFromToken(token);
    if (!member) {
      socket.write("HTTP/1.1 401 Unauthorized\r\n\r\n");
      return socket.destroy();
    }
    wss.handleUpgrade(request, socket, head, (webSocket) => {
      webSocket.member = member;
      wss.emit("connection", webSocket, request);
    });
  } catch {
    socket.destroy();
  }
});

wss.on("connection", (socket) => {
  clients.add(socket);
  socket.send(JSON.stringify({ type: "connected", role: socket.member.role }));
  socket.on("close", () => clients.delete(socket));
  socket.on("error", () => clients.delete(socket));
});

server.listen(port, "0.0.0.0", () => {
  console.log(JSON.stringify({ event: "gateway_listening", port }));
});
