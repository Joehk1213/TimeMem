# Home Hub 概覽（由舊 Root README 搬移）

> 以下內容由原 Root README 搬到此處，保留原有概覽及歷史資料。現行要求請以 [PRD V10.2](../PRD.md) 為準；V10.1 已移至 `TimeMem-PRD-V10-1.md`。Vault 路徑結構僅為舊參考。

# TimeMem — 屋企 Home Hub

**一句講晒：舊電腦翻新用，好似 ROUTER 咁，屋企長開，當一個家庭個人整合集，好似 NAS 咁，多一個長期插火牛嘅電子設備。**

**定位：** 個人化工具，唔係商業賺錢產品。返返去初心，做晒 JOE 想做嘅嘢，滿意值做滿，先至開心 SHARE。商業火花有冇，到時先知。

## 睇邊份？唔好睇晒成個 Folder

| 想做咩 | 睇邊份 |
|---|---|
| 想知做咩、做到咩標準先叫完成 | `01-PRD-最終版 / TimeMem-PRD-V10-Final.md` — 唯一最終版 |
| 想知點裝、點 SET Server | `03-SOP / TimeMem-Install-SOP-Lock-Version.md` — Lock 版，唔使 BIOS，唔使 WOL |
| 想知點擺部機 | `03-SOP / TimeMem-Home-Hub-Physical-Setup.md` — 左電源，右 LAN，企係度，擺喺 ROUTER 隔離 |
| 想知點包裝俾屋企人聽 | `03-SOP / TimeMem-Home-Hub-Packaging.md` |
| 想直接裝 | `04-Scripts / Install-OneClick.ps1` + `Set-Server-Lock-Simple.ps1` |
| 想睇舊版、AI 意見 | `05-Archive-舊版+AI意見` — 參考用，唔好照舊版做 |

## 10 點滿意清單，就係驗收標準

1. 拉 PDF，20 堂一次入
2. 問問題，3-5 秒有答案
3. 相片自動指返 RECORD
4. NAS / 舊電腦一鍵安裝 → 而家改做 Home Hub，舊電腦翻新用，好似 ROUTER 咁長開
5. 備份還原一鍵
6. 好生動嘅相片牆背景，有特效 + 卡片回顧
7. User Friendly
8. 人性化，廣東話、中英混合輸入層，都明白得到（信心值）
9. 如果理解不能（信心低），就係詢問位
10. 越用越適合我

## Home Hub 正常狀況

- 舊電腦翻新，買個架企係度，左邊插電源，右邊插 LAN 線，擺喺 ROUTER 隔離。
- WIN+L 鎖機，或者合上蓋 = 唔做任何嘢，部機一直開住，鎖住畫面，唔使 WOL，唔使 BIOS。
- 電話開 TimeMem，見到隨機相片 + 故事卡片，問「下一堂滑板班幾時？」3-5 秒有答案。

## 舊 Folder 結構參考

```
TimeMem-整理-2026-11-09/
├── 00-總覽 / 00-總覽-預覽卡.md (呢份)
├── 01-PRD-最終版 / TimeMem-PRD-V10-Final.md (唯一最終版)
├── 02-README / README.md (呢份)
├── 03-SOP / 4 份 SOP (Lock 版 + 簡單版 + 包裝 + 物理擺位 + 舊 WOL 參考)
├── 04-Scripts / 4 個 .ps1 (一鍵安裝 + 一鍵 SET 鎖機 + 舊 WOL 參考)
└── 05-Archive-舊版+AI意見 / 舊 PRD / 舊 README / AI Feedback / IDEA (參考用)
```