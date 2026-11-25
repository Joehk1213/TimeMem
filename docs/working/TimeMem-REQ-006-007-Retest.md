# REQ-006 / REQ-007 現行 Hybrid 5 重測

> 呢份係待執行 runbook，唔係 PASS evidence。

## SERVER LUNA 可執行嘅準備

1. 記錄測試日期、時間、JOE-SERVER IP/Tailnet name、`tailscale status`、`tailscale serve status`。
2. 記錄現行 Compose project/container image digest、frontend/backend/database health，同 `http://127.0.0.1:3000/healthz`。
3. 記錄 ingress 實際將邊個 local URL 透過 Tailnet HTTPS expose；唔可以只寫 command，亦要有成功 browser result。
4. 檢查 router forwarding、UPnP、DMZ、IPv4/IPv6 firewall、Remote Management 同 public DNS/port；保存當日截圖。
5. 保留全部 output 為 dated evidence，唔寫 password、session token、device Serial、IMEI 或私人資料。

## REQ-006 Tailnet 成功

1. Joe 或已授權測試手機開啟 Tailscale，WiFi 關閉並使用 mobile data。
2. 截圖顯示 mobile data、Tailscale connected、時間及 handset model/OS。
3. 用 Safari/Chrome 開已記錄嘅 `https://<joe-server>.ts.net`。
4. 截圖成功載入現行 PWA shell，並記 browser error/result。
5. evidence 必須同現行 compose image digest／測試日期綁定。

## REQ-006 非 Tailnet 拒絕

1. **等 Joe 做：** 用一部唔喺 Tailnet 嘅手機，關 WiFi、用 mobile data。
2. 去完全相同 endpoint；Tailscale 必須 OFF，截圖顯示 OFF、時間及網絡。
3. 預期 DNS failure／unreachable／connection refused；唔接受登入頁或 app response 作 PASS。
4. 保存 denial 截圖。

## REQ-007 PWA shell

1. 只喺 Tailnet 成功測試完成後做。
2. 確認現行 app shell 顯示；M0 唔測 login、Calendar、record 或 data access。
3. 保存 browser PWA 截圖，同 REQ-006 success evidence 對齊時間。

## PASS 先決條件

- Tailnet HTTPS success。
- 非 Tailnet 拒絕。
- router 冇開放入口。
- 現行 stack/image 已識別。
- evidence 有日期、裝置、網絡狀態、結果同 SHA-256 manifest。
- 未做實測就唔更新 GATE 狀態。
