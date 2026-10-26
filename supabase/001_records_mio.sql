-- =====================================================================
-- ミオファ的高麗菜園（twmiofa）001：本站專用的紀錄表 records_mio
--
-- 本站與 AZKi 站「開拓者の愉悅部」（twkaitakusha）共用同一個 Supabase 專案：
--   * 帳號（auth.users）、profiles、刪除帳號函式等 → 兩站共用，SQL 在 twkaitakusha/supabase/
--   * 紀錄 → 分開存放：AZKi 站用 records，本站用 records_mio（這個檔案）
-- 執行前提：twkaitakusha/supabase/001～003 已經執行過（本檔沿用其中的 touch_updated_at 函式）。
--
-- 使用方式：Supabase 後台 → SQL Editor → New query → 整段貼上 → Run
-- 可以重複執行（已存在的物件會略過或更新）。
-- =====================================================================

-- ---------- 紀錄表：一列＝一個人的一件周邊 ----------
create table if not exists public.records_mio (
  user_id    uuid        not null default auth.uid() references auth.users (id) on delete cascade,
  book       text        not null check (book in ('mio_ledger', 'mio_voice')),
  item_key   text        not null check (char_length(item_key) between 1 and 200),
  qty        smallint    not null check (qty between 0 and 99),   -- 0 = 已取消（保留列，讓其他裝置知道）
  updated_at timestamptz not null default now(),
  primary key (user_id, book, item_key)
);

-- 更新時間由伺服器蓋章（沿用 twkaitakusha 001 建立的 touch_updated_at）
drop trigger if exists records_mio_touch on public.records_mio;
create trigger records_mio_touch before insert or update on public.records_mio
  for each row execute function public.touch_updated_at();

alter table public.records_mio enable row level security;

-- 只開放給「已登入」的人，未登入（anon）完全不能碰
revoke all on public.records_mio from anon;
grant select, insert, update, delete on public.records_mio to authenticated;

drop policy if exists records_mio_select_own on public.records_mio;
drop policy if exists records_mio_insert_own on public.records_mio;
drop policy if exists records_mio_update_own on public.records_mio;
drop policy if exists records_mio_delete_own on public.records_mio;
create policy records_mio_select_own on public.records_mio for select to authenticated
  using ((select auth.uid()) = user_id);
create policy records_mio_insert_own on public.records_mio for insert to authenticated
  with check ((select auth.uid()) = user_id);
create policy records_mio_update_own on public.records_mio for update to authenticated
  using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy records_mio_delete_own on public.records_mio for delete to authenticated
  using ((select auth.uid()) = user_id);

-- 刪除帳號：delete_my_account() 刪掉 auth.users 那一列時，records_mio 也會因 on delete cascade 一起刪除，不用另外改。
