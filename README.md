# TimeMem

TimeMem 係一個以家庭為本、自家託管嘅時間與記憶系統；現行產品要求以 [PRD V10.2](docs/prd/TimeMem-PRD-V10-2.md) 為準。V10.1 已移至 `docs/archive/TimeMem-PRD-V10-1.md` 作歷史版本。

**M0 仍為 Draft / NOT APPROVED；批准權只在 Joe 手上。**

## 入門

1. 先讀 [PRD V10.2](docs/prd/TimeMem-PRD-V10-2.md) 了解產品範圍及要求。
2. 開工前查看 [TODO](docs/working/TODO.md)；已完成事項見 [PROGRESS](docs/working/PROGRESS.md)。
3. 文件入口見 [docs/README.md](docs/README.md)；正式決策記錄在 [docs/DECISIONS.md](docs/DECISIONS.md)。
4. 設定時可參考 [.env.example](.env.example)，填入本機值前先複製成 `.env`；唔好提交 `.env` 或真密碼/API key。

正式決策以 Repo `docs/DECISIONS.md` 為準；Vault `02-決策-ADR` 只作草稿。

## Hybrid 5 Docker stack

1. 將 `.env.docker.example` 複製成 `.env`，設定隨機 `TIMEMEM_DB_PASSWORD` 及 `TIMEMEM_SESSION_SECRET`。
2. 如需建立初始 Owner，臨時設定 6 位數 `TIMEMEM_BOOTSTRAP_PIN`；建立後應移除該值。
3. 執行 `docker compose config` 做設定檢查，再執行 `docker compose up -d --build`。

唯一主機入口是 `127.0.0.1:444`。Compose 只包含 `frontend`、`backend`、`database`；
PostgreSQL 資料保存在獨立 named volume `timemem_hybrid5_postgres_data`，不會因重建容器而刪除。
