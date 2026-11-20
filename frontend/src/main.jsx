import React from "react";
import { createRoot } from "react-dom/client";
import "./styles.css";

function App() {
  const [status, setStatus] = React.useState("checking");
  const [prompt, setPrompt] = React.useState("");
  const [answer, setAnswer] = React.useState(null);

  React.useEffect(() => {
    fetch("/ready")
      .then((response) => setStatus(response.ok ? "ready" : "starting"))
      .catch(() => setStatus("offline"));
    if ("serviceWorker" in navigator) {
      navigator.serviceWorker.register("/sw.js").catch(() => {});
    }
  }, []);

  async function ask(event) {
    event.preventDefault();
    setAnswer({ message: "正在理解…" });
    try {
      const response = await fetch("/api/ai/analyze", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        credentials: "same-origin",
        body: JSON.stringify({ text: prompt })
      });
      const result = await response.json();
      if (!response.ok) throw new Error(result.error?.message || "請先登入");
      setAnswer(result);
    } catch (error) {
      setAnswer({ message: error.message });
    }
  }

  return (
    <main className="shell">
      <div className="glow glow-one" />
      <div className="glow glow-two" />
      <header>
        <a className="brand" href="/">TimeMem</a>
        <span className={`status ${status}`}>{status}</span>
      </header>
      <section className="hero">
        <p className="eyebrow">FAMILY MEMORY · LOCAL FIRST</p>
        <h1>Remember what matters.</h1>
        <p className="lede">時間、記憶、相片，留在屋企，亦隨時搵得返。</p>
        <form onSubmit={ask}>
          <label htmlFor="prompt">今日想紀錄或搵咩？</label>
          <div className="input-row">
            <input
              id="prompt"
              value={prompt}
              onChange={(event) => setPrompt(event.target.value)}
              placeholder="例如：下一堂滑板班幾時？"
              required
            />
            <button type="submit">理解</button>
          </div>
        </form>
        {answer && (
          <article className="answer" aria-live="polite">
            <strong>{answer.message || "已完成分析"}</strong>
            {answer.intent && <span>{answer.intent} · {Math.round(answer.confidence * 100)}% 信心</span>}
          </article>
        )}
      </section>
      <footer>
        <a href="/timemem-pwa-original.html">查看原有 PWA 示範</a>
        <span>資料只經本機 API 與 PostgreSQL</span>
      </footer>
    </main>
  );
}

createRoot(document.getElementById("root")).render(<App />);
