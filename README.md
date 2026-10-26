# ミオファ的高麗菜園

給ミオファ的大神ミオ周邊收集清單（繳稅紀錄簿）。非官方粉絲網站，與 COVER 株式会社無關。

- 網址：https://ccc15921.github.io/twmiofa/
- 商品資料：Google 試算表發佈的 CSV（網址在 `js/app.js` 的 `CSV_URL`）
- 未登入：紀錄存在瀏覽器 localStorage（鍵名一律 `mio-` 開頭）
- 登入：Google 登入，紀錄同步到 Supabase。與 AZKi 站（twkaitakusha）共用同一個 Supabase 專案與帳號，
  本站紀錄存在 `records_mio` 表（`book` 為 `mio_ledger`），與 AZKi 站的 `records` 分開。本站專用的 SQL 在 `supabase/`（需先執行過 twkaitakusha 的 `supabase/001～003`）。

## 檔案

- `index.html`：繳稅紀錄簿
- `privacy.html`：隱私權政策
- `css/style.css`：樣式（白底、主色 #FF314A，含深色模式）
- `js/app.js`：讀 CSV、列表、篩選、紀錄、匯出入、轉移
- `js/cloud.js`：Google 登入與雲端同步
- `js/transfer.js`、`js/vendor/`：轉移連結／QR Code、supabase-js
- `supabase/001_records_mio.sql`：本站的紀錄表 records_mio

## CSV 日期格式

建議 `2026/03/06`。也接受 `3/6/26`（月/日/年）與 `25/12/7`（年/月/日）。
