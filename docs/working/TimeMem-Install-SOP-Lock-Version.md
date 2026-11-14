# TimeMem 安裝 SOP — Lock 版，唔使 BIOS，唔使 WOL

**版本：V10.1，2026-11-09，取代 WOL 版**
**一句講晒：鎖定就可以，唔係熄機。唔使入 BIOS，唔使搞 WOL。**
**目標：一個唔識 IT 嘅家人，10 分鐘，裝完即刻睇到 TEMPMEM BASIC 首頁，隨機相片 + 故事卡片。**

---

## 點解 Lock 版得，WOL 版唔好

|  | WOL 版，舊諗法 | Lock 版，新諗法 |
|---|---|---|
| 咩狀態 | 合蓋 = 睡眠，要 WOL 先醒 | WIN+L 鎖機，或者合蓋 = 唔做任何嘢，部機一直開住，淨係鎖畫面 |
| 要唔要 BIOS | 要，Wake on LAN = Enable | 唔使，完全唔使入 BIOS |
| 要唔要 WOL | 要，Magic Packet | 唔使，部機根本冇瞓 |
| 第一次 Search 要幾耐 | 20-30 秒，要等 Wake + Docker 起返 + Ollama Load | 3-5 秒，同平時一樣，因為部機一直開住 |
| 穩唔穩定 | 唔穩，WiFi Wake 成日失敗，瞓 2 個鐘自動轉 Hibernate | 穩，部機一直開住，Docker、Tailscale、Ollama 全部一直開住 |
| 慳唔慳電 | 慳，Sleep 係 1W | 用多啲，Lock 係 15-25W，但屋企 Server 呢個電費係可以接受 |
| 可複製 | 唔可複製，BIOS 已經嚇走人 | 可複製，唔使入 BIOS，唔使識 WOL |

**結論：Lock 版做得到，仲要係啱嘅方向。WOL 係為咗慳電而搞到煩瑣，係本末倒置。Lock 版慳唔到嗰 20W 電，但慳返成個 WOL 嘅煩惱，仲要第一次 Search 唔使等 30 秒。**

**重點：鎖定唔等於熄機，鎖定唔等於睡眠。**
- WIN+L 鎖機：畫面鎖咗，要 PIN 先入到，但後台 Docker、Ollama、Tailscale 全部繼續行，API 全部繼續答。
- 合蓋 = 唔做任何嘢：合埋蓋，個 Mon 熄咗，但 CPU、Docker、Ollama 全部繼續行，唔會瞓。
- 所以，鎖機之後，屋企人喺電話打「下一堂滑板班幾時？」部 Server 唔使醒，佢根本冇瞓，即刻答到 3-5 秒。

---

## SOP 流程，5 步

```
[1] 裝 Docker
  ↓
[2] 一鍵安裝：Docker Compose 起晒 + 拉晒 Local Model + 還原 TEMP BACKUP
  ↓
[3] 安裝完，問「要打開 TimeMem 嗎？」
  ↓
[4] 即刻 Load 到 TEMPMEM BASIC 首頁，隨機相片 + 故事卡片
  ↓
[5] Server 設定：插火牛 + 插 LAN 線 + WIN+L 鎖機（Notebook 就合上蓋）
  ↓
正常狀況：部機一直開住，鎖住畫面，唔使 WOL，唔使 BIOS
```

---

## Step 1：先安裝 Docker

- Windows 11：去 Docker 官網，下載 Docker Desktop，安裝，重新開機。
- 安裝完，開 Docker Desktop，見到佢話 Running 就可以。
- 呢步唔可以一鍵，因為 Docker Desktop 要裝 WSL2，要重新開機一次。但只係做一次，之後唔使再做。
- Script 會自動檢查有冇 Docker，冇就會開瀏覽器去 Docker 下載頁，唔使你自己搵。

## Step 2：一鍵全安裝，所有要用嘅 Local Model

**一個指令，搞掂晒：**

```bash
docker compose up -d
```

**背後做咩，唔使你識，但要知：**

1.  **App 容器：** Frontend + Gateway + AI Brain，一個服務。
2.  **DB 容器：** Local Postgres + pgvector。
3.  **Ollama 容器：** 自動 Pull 2 個 Model：
    - `bge-m3`，Embedding，1024 維，多語言，廣東話 / 中文 / 英文都識，~1.2GB
    - `qwen3:8b`，LLM，問答用，~5GB
    - 唔使你人手 `ollama pull`，Script 會自動做。
4.  **TEMP BACKUP 還原：** 如果係第一次安裝，DB 係空嘅，Script 會自動還原 TEMP BACKUP FILE。

**TEMP BACKUP FILE 係咩：**
- 預先整定一個 `temp-backup.zip`，入面有：
  - `db.sql`：20 個示範 Item，例如羽毛球 20 堂、滑板班 10 堂、打針紀錄、證件到期
  - `assets/`：10 張示範相片，已經指返 Item
  - `config/nlp-synonyms.json`：預設同義詞，例如「板 = 滑板班」、「疫苗 = 打針」
  - `config/reminder-defaults.json`：預設提醒，提前 1 日 + 當日早上
- 安裝時，Script 會自動做 TEMP RESTORE：將 `temp-backup.zip` 還原去 DB + Assets + Config。
- **唔會覆蓋你已有嘅資料：** 如果 DB 已經有資料，Script 會問「已經有資料，係咪仲要還原 TEMP？」預設唔還原，唔好整唔見你啲真資料。
- **點解要 TEMP BACKUP？** 因為第一次開 TimeMem，如果 DB 係空嘅，首頁係空嘅，相片牆係空嘅，用家會覺得「呢個係咩嚟？冇嘢睇。」有 TEMP BACKUP，第一次開就見到隨機相片 + 故事卡片，即刻明「哦，原來係咁用」。

## Step 3：安裝完，詢問要打開 TimeMem 嗎？

- Script 跑完，會彈出一個視窗：「安裝完成，要打開 TimeMem 嗎？[是 / 否]」
- 撳「是」，自動開瀏覽器，去 `http://localhost:3000`。
- 唔好要人哋自己打 `localhost:3000`，要自動開。
- 唔好要人哋自己諗「裝完去邊度開」，要問佢。

## Step 4：即刻 Load 到 TEMPMEM BASIC 首頁

**第一次開，要見到：**

- **相片牆背景：** 隨機相片，隨機移動、隨機放大縮少，唔係靜態列表。Mouse 放上去停低，彈出故事卡片。
- **故事卡片：** 例如「2026-11-12 滑板班，屯門，4pm，嗰日影咗 5 張相，仲記唔記得...？」廣東話文案。
- **搜尋框：** 已經有示範問題，例如「下一堂滑板班幾時？」撳一下即刻有答案，唔使打。
- **輸入框：** 已經有示範，例如「拉 PDF 入嚟，試下 20 堂一次入」。

**點解要即刻 Load 到？**
- 因為用家第一次用，唔係嚟學嘢，係嚟睇下「呢個啱唔啱我用」。
- 如果第一次開係空嘅，用家會覺得「要自己入晒先有用，好麻煩」，即刻唔想用。
- 有 TEMP BACKUP，即刻有嘢睇，即刻明，即刻想用。

## Step 5：Server 設定，插火牛 + 插 LAN 線 + WIN+L 鎖機

**正常狀況：**

- **插火牛：** 唔好用電池，長期插住火牛。
- **插 LAN 線：** 唔好只用 WiFi，Ethernet 最穩，Tailscale 重連最快。
- **WIN+L 鎖機：** 撳 `WIN + L`，畫面鎖咗，要 PIN 先入到，但部機繼續行。
- **如果係 Notebook：** 合上蓋，唔好驚，合蓋 = 唔做任何嘢，唔係睡眠，唔係熄機。合埋蓋，個 Mon 熄咗，但部機繼續行。

**Script 會自動做晒：**

跑 `Set-Server-Lock-Simple.ps1`，右鍵「以系統管理員身份執行」，Script 會自動做晒：

1. 合蓋動作 = 唔做任何嘢，唔係睡眠，唔係休眠，唔係關機
2. 插電時，永不睡眠，永不休眠
3. 關 Hibernate，唔好自動轉 Hibernate
4. 螢幕 5 分鐘後關閉，但 CPU 繼續行，Docker 繼續行
5. 唔好俾電腦關閉網絡卡慳電，Ethernet 一直開住
6. Docker Restart Always，Tailscale 開機自動啟動
7. 檢查 Docker + Ollama 有冇起返

**唔使入 BIOS，唔使搞 WOL。**

**注意：**
- Notebook 合蓋之後，唔好放入袋，唔好放入櫃，要放喺枱面，通風。因為部機繼續行，風扇繼續轉，放入袋會焗親，過熱會死機。
- 唔好放喺床上面，唔好放喺被上面，要放喺硬枱面，底要通風。
- 如果屋企有小朋友，鎖機之後，佢哋撳唔到入去，但 TimeMem 喺電話仲用到，因為 Server 仲行緊。

---

## 測試，Lock 版，1 次就夠

**唔使再測 WOL，改測 Lock。**

1. 插火牛 + 插 LAN 線，跑完 Script，WIN+L 鎖機，Notebook 就合上蓋。
2. 等 8 個鐘，例如夜晚鎖機，朝早起身。
3. 喺電話打「下一堂滑板班幾時？」睇下幾耐有答案。

**記低 2 行就得：**
```
鎖機 8 個鐘之後，第一次 Search 要幾耐：__ 秒，目標 3-5 秒
第二次 Search 要幾耐：__ 秒，目標 3-5 秒
結果：PASS / FAIL
```

**點解 Lock 版測試咁簡單？**
- 因為部機根本冇瞓，唔使醒，第一次同第二次都係 3-5 秒，唔會差好遠。
- 如果第一次要 30 秒，即係唔係 Lock 版，係仲喺 Sleep 版，要返去檢查 Script 有冇跑錯。

---

## 可行性，答你：做得到，可行，仲要係啱

- **做得到：** Windows 11 有 `powercfg` 可以設合蓋 = 唔做任何嘢，有 `WIN+L` 可以鎖機，有 Docker Compose 可以一鍵起晒，有 Ollama 可以自動 Pull Model，有 TEMP BACKUP 可以自動還原，全部都係現成技術，唔使發明新嘢。
- **可行：** 唔使入 BIOS，唔使搞 WOL，唔使識 Magic Packet，唔使識 powercfg。一個 Script + 2 個插頭 + WIN+L，10 分鐘搞掂，呢個先叫可複製。
- **仲要係啱：** 因為 TimeMem 係個人化工具，唔係商業產品，唔使為咗慳 20W 電而搞到家人唔用。鎖機用多啲電，但換嚟穩定、簡單、可複製，抵。
- **風險：** 唯一風險係過熱，Notebook 合蓋之後繼續行，如果放入袋會焗親。所以 SOP 要寫明：放喺枱面，通風，唔好放入袋。

**結論：用 Lock 版，唔用 WOL 版。WOL 版留返俾 JOE 自己研究，SHARE 版用 Lock 版。**

---

## 附件

- `Install-OneClick.ps1` — 一鍵安裝：檢查 Docker → Compose 起晒 → Pull Model → 還原 TEMP BACKUP → 問「要打開 TimeMem 嗎？」
- `Set-Server-Lock-Simple.ps1` — 一鍵 SET Server：合蓋 = 唔做任何嘢 + 永不睡眠 + 關 Hibernate + 螢幕 5 分鐘關 + 網絡卡一直開
- `temp-backup.zip` — 預先整定嘅示範資料，20 個 Item + 10 張相 + 同義詞 + 提醒預設
