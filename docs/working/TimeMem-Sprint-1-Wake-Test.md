# TimeMem Sprint -1 — JOE-SERVER 合蓋 STANDBY + 喚醒測試

**機器：JOE-SERVER，FUJITSU LIFEBOOK U9311X，Windows 11，i7-1165G7，16GB，477GB NVMe**
**目標：合上蓋入 STANDBY，內聯 / 外聯呼叫入 DATA / SEARCH DATA 先會醒。測第一次 WAKE UP + CONNECTION 要幾耐，ONLINE 之後係咪返返正常時間。紀錄低 SERVER OFFLINE 到 ONLINE 嘅整體過程。**
**狀態：M0 Sprint -1 必須做，過唔到唔開 M1。**

---

## 1. 概念要搞清，唔好撈亂

| 狀態 | 咩意思 | JOE-SERVER 係咩狀態 |
|---|---|---|
| ONLINE | 開住蓋，Windows 開住，Docker 開住，Ollama 開住 | 可以即刻答，3-5 秒 |
| STANDBY / Sleep | 合上蓋，Windows 入 Sleep，RAM 仲有電，CPU 停，WiFi / LAN 保持低功耗監聽 | 唔答，要 WAKE 先答。第一次要等 WAKE + Docker 恢復 + Ollama 恢復 |
| Hibernate | RAM 寫去硬碟，完全斷電，下次開機要成個還原 | 唔好用，WAKE 要 30-60 秒，仲要成日出事 |
| OFF / Shutdown | 熄機 | 唔好用，唔係 STANDBY |

**V10 要求：** JOE-SERVER 用 STANDBY，唔用 Hibernate，唔用 Shutdown。合蓋 = STANDBY。

---

## 2. SET 機步驟，JOE-SERVER 一定要做晒先好測

### 2.1 睇下部機支援咩 Sleep

開 PowerShell Admin，打：
```
powercfg /a
powercfg /devicequery wake_from_any
powercfg /lastwake
```
- 如果見到 `Standby (S0 Low Power Idle)`，即係 Modern Standby，可以做到 Network 保持監聽。
- 如果只係見到 `Standby (S3)`，即係傳統 Sleep，Wake 會慢啲，但都得。
- 記低結果，寫入測試 Log。

### 2.2 BIOS，FUJITSU LIFEBOOK
開機撳 F2 入 BIOS：
- Power / Wake on LAN：Enable
- USB Wake：Enable
- Wake on WLAN：Enable（如果用 WiFi）
- Lid Close Action：唔好喺 BIOS 設，留返 Windows 設

### 2.3 Windows 11 設定
- 設定 > 系統 > 電源 > 合蓋動作：插電 + 用電池，全部設「睡眠」，唔好設「休眠」或者「關機」。
- 設定 > 系統 > 電源 > 睡眠：插電時，永不進入休眠。唔好俾佢 Sleep 2 小時之後自動轉 Hibernate。
- 設定 > 系統 > 電源 > 進階：關閉「允許混合式睡眠」。
- 裝置管理員 > 網路介面卡 > Intel Wi-Fi / Intel Ethernet > 電源管理：
  - 勾「允許這個裝置喚醒電腦」
  - 勾「只允許 Magic Packet 喚醒電腦」（如果有）
  - 唔好勾「允許電腦關閉這個裝置以節省電源」
- 裝置管理員 > 滑鼠 / 鍵盤 > 電源管理：唔好勾喚醒，避免誤觸。

### 2.4 插電 + 插線，唔好用電池 + WiFi 嚟測
- JOE-SERVER 一定要插火牛，唔好用電池做 STANDBY 測試。電池 Sleep 耐咗會自動 Hibernate。
- 最好插 Ethernet 線，唔好只用 WiFi。WiFi Wake 唔穩定，Ethernet Wake 最穩。
- 如果只能用 WiFi，要開 Wake on WLAN，同埋要固定 IP，唔好浮動。

### 2.5 Docker + Tailscale 設定
- Docker Desktop：設定 Restart Always，唔好設 Manual。Sleep 之後 Docker 要自動恢復。
- Tailscale：開機自動啟動，唔好要人手開。Tailscale 喺 STANDBY 會斷，但 WAKE 之後會自動重連，要測重連要幾耐。
- TimeMem App：設定 Healthcheck，WAKE 之後要自動檢查 DB + Ollama 有冇起返。

---

## 3. 喚醒方法，內聯 / 外聯分開

| 場景 | 點叫醒 | 工具 |
|---|---|---|
| 內聯，屋企 WiFi / LAN | Magic Packet，WOL | 電話 App：Wake On Lan、Fing，或者另一部電腦打 `wol` 指令 |
| 外聯，街外經 Tailscale | 先經 Tailscale 呼叫，再經屋企內網嘅另一部裝置發 Magic Packet，或者直接經 Tailscale Wake | 需要一個屋企常開嘅中繼：例如 Router 支援 WOL，或者另一部唔瞓覺嘅裝置（舊電話 / Raspberry Pi）幫手發 Magic Packet |
| 手動測試 | 合蓋 → 等 1 分鐘 → 發 Magic Packet → 計時 | 先做手動測試，唔好一開始就做自動 |

**V10 M0 先做手動，唔好一開始就做自動喚醒 Proxy。** 手動測到時間先，先至諗自動。自動喚醒 Proxy 係 M4 先做。

**自動喚醒 Proxy 概念（M4 先做，M0 只係知有呢樣）：**
- 用家打「入 DATA / SEARCH」，Request 先去到一個常開嘅小 Proxy（例如 Router / 舊電話）。
- Proxy 發 Magic Packet 叫醒 JOE-SERVER，等佢 ONLINE，再將 Request Forward 去 JOE-SERVER。
- 用家見到「Server 喚醒中...」，等 20-30 秒，唔好話佢壞咗。

---

## 4. 測試案例，3 個一定要做

### TC1：內聯喚醒，短 STANDBY，1 分鐘
- 步驟：合蓋 → 等 1 分鐘 → 喺屋企 WiFi 發 Magic Packet → 計時。
- 測：由發 Magic Packet 到 Ping 到，到 Docker 起返，到 API 答到，到第一次 Search 有答案，總共幾耐。

### TC2：內聯喚醒，長 STANDBY，8 小時
- 步驟：夜晚合蓋 → 朝早 8 小時後，喺屋企 WiFi 發 Magic Packet → 計時。
- 測：同 TC1 一樣，但要睇下 8 小時後會唔會自動轉咗 Hibernate，WAKE 會唔會慢咗好多。

### TC3：外聯喚醒，經 Tailscale
- 步驟：喺街外，電話連 Tailscale，試下 Ping JOE-SERVER → 如果 Ping 唔到，經屋企中繼發 Magic Packet → 計時。
- 測：外聯喚醒要幾耐，Tailscale 重連要幾耐，第一次 Search 要幾耐。

**每個 TC 做 3 次，取中位數，唔好只做一次。**

---

## 5. 計時點，點樣計 OFFLINE 到 ONLINE 嘅整體過程

**唔好只計一個時間，要計 6 個時間點：**

| 時間點 | 點計 | 點解要計 |
|---|---|---|
| T0：合蓋 OFFLINE | 合上蓋嗰一刻，記低時間 | 起點 |
| T1：發出喚醒 | 發 Magic Packet 嗰一刻，記低時間 | 喚醒開始 |
| T2：Ping 通 | `ping JOE-SERVER` 第一次有回應，記低時間 | 網絡醒咗 |
| T3：Docker + App 起返 | `docker ps` 見到 3 個容器都係 Up，`curl /health` 有回應，記低時間 | App 醒咗 |
| T4：第一次 Search 有答案 | 打「下一堂滑板班幾時？」第一次有答案，記低時間 | 第一次 WAKE UP + CONNECTION 時間，呢個係用家感受到嘅時間 |
| T5：第二次 Search 有答案 | 即刻再打一次同一個問題，記低時間 | ONLINE 之後正常時間，睇下係咪返返 3-5 秒 |

**公式：**
- 第一次 WAKE UP + CONNECTION 時間 = T4 - T1
- ONLINE 之後正常時間 = T5 - T4 嗰個 Search 嘅時間
- 整體 OFFLINE 到 ONLINE = T4 - T0

**目標值，V10 要求：**
- 第一次 WAKE UP + CONNECTION：<= 30 秒，接受。> 60 秒，唔接受，要改設定。
- ONLINE 之後正常時間：3-5 秒，唔好因為 STANDBY 之後變慢。
- 如果第一次要 30 秒，用家見到「Server 喚醒中...」係可以接受嘅，唔好扮即刻答到。

---

## 6. 測試 Log 模板，次次都要咁記

**每次測試，開一個新 Log，寫入 PROGRESS.md 嘅 Sprint -1 部分。**

```
=== JOE-SERVER STANDBY 喚醒測試 ===
日期：2026-__-__ __:__
測試案例：TC1 / TC2 / TC3，第 __ 次
測試前狀態：合蓋前 Docker 係咪 Up？Tailscale 係咪 Up？插電？插 Ethernet 定 WiFi？
T0 合蓋 OFFLINE：__:__:__
T1 發出喚醒：__:__:__，用咩工具發？內聯 / 外聯？
T2 Ping 通：__:__:__，用咩指令？ping / tailscale ping？
T3 Docker + App 起返：__:__:__，docker ps 結果？
T4 第一次 Search 有答案：__:__:__，問題係咩？答案係咩？用咗幾多秒？
T5 第二次 Search 有答案：__:__:__，問題係咩？用咗幾多秒？
第一次 WAKE UP + CONNECTION 時間：__ 秒
ONLINE 之後正常時間：__ 秒
整體 OFFLINE 到 ONLINE：__ 秒
有冇轉咗 Hibernate？有 / 冇
有冇出錯？Error Log：
備註：
測試人：JOE
結果：PASS / FAIL
```

**測試指令，Copy 就用得：**

```powershell
# 睇下 Sleep 支援
powercfg /a

# 睇下上次係咩喚醒咗部機
powercfg /lastwake

# Ping 測試，計時
ping JOE-SERVER -t

# Tailscale Ping 測試
tailscale ping JOE-SERVER

# Docker 睇下容器起返未
docker ps

# Healthcheck
curl http://JOE-SERVER:3000/health

# 計時 Search，PowerShell 計時
$start = Get-Date
curl -Method POST http://JOE-SERVER:3000/ask -Body '{"q":"下一堂滑板班幾時？"}' -ContentType "application/json"
$end = Get-Date
($end - $start).TotalSeconds
```

**Magic Packet 發送，Windows 另一部機：**
```powershell
# 用 PowerShell 發 WOL，AA:BB:CC:DD:EE:FF 換做 JOE-SERVER 嘅 MAC Address
$mac = "AA-BB-CC-DD-EE-FF"
$macBytes = $mac -split "-" | ForEach-Object {[byte]("0x" + $_)}
$packet = [byte[]](,0xFF * 6) + ($macBytes * 16)
$udp = New-Object System.Net.Sockets.UdpClient
$udp.Connect("192.168.1.255", 9)
$udp.Send($packet, $packet.Length) | Out-Null
$udp.Close()
Write-Host "Magic Packet 已發送"
```

---

## 7. 常見失敗，點解會 WAKE 唔到

| 失敗 | 原因 | 點修 |
|---|---|---|
| 合蓋之後，發 Magic Packet 冇反應 | BIOS 冇開 Wake on LAN，或者 Network Adapter 冇勾「允許喚醒」 | 返去 2.2 + 2.3 檢查 |
| Sleep 2 小時之後，WAKE 要 60 秒 | 自動轉咗 Hibernate | 設定 > 電源 > 睡眠 > 插電時永不進入休眠，關閉混合式睡眠 |
| WiFi WAKE 唔到 | WiFi Wake 唔穩定，或者 Router 唔 Forward Magic Packet | 改用 Ethernet 線，唔好用 WiFi 嚟做 STANDBY |
| Tailscale WAKE 唔到 | Tailscale 喺 STANDBY 斷咗，WAKE 之後要 10 秒先重連 | 先用內聯 Magic Packet 喚醒，等 Tailscale 重連，先至做外聯測試 |
| Docker WAKE 之後起唔返 | Docker Desktop 喺 Sleep 之後唔自動恢復 | Docker 設定 Restart Always，仲要喺 WAKE 之後等 10 秒先好測 API |
| Ollama WAKE 之後答得好慢 | Ollama Model 要重新 Load 入 RAM，第一次要 10-20 秒 | 第一次 Search 慢係正常，要同第二次 Search 分開計，唔好將第一次當正常時間 |

---

## 8. 點樣判斷 Sprint -1 過唔過

**過：**
- TC1、TC2、TC3 全部做 3 次，第一次 WAKE UP + CONNECTION 時間中位數 <= 30 秒。
- ONLINE 之後第二次 Search，3-5 秒，唔好因為 STANDBY 之後變慢。
- 冇自動轉 Hibernate。
- Log 寫晒，PROGRESS.md 有齊 9 次測試紀錄。

**唔過：**
- 第一次 WAKE UP 要 > 60 秒，或者成日 WAKE 唔到。
- ONLINE 之後第二次 Search 都要 10 秒以上，唔係正常時間。
- 成日自動轉 Hibernate。

**唔過點算：**
- 唔好開 M1，返去改設定，改到過為止。
- 如果改極都唔過，考慮放棄 STANDBY，改做 7x24 開住，但要寫明點解放棄，唔好扮 STANDBY 得但實際唔得。

---

## 9. 審批

- JOE：______，日期：______
- 阿 Sir：______，日期：______
- 決定：Sprint -1 STANDBY 喚醒測試通過 / 唔通過，M1 開唔開波。
