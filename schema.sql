-- ============================================================
-- Supabase → SQL Editor 에 붙여넣고 실행하세요.
-- ============================================================

-- 1. 보드 테이블: 보드 하나가 JSON 한 덩어리
create table if not exists public.board (
  id         text primary key,          -- 'party-2026'
  data       jsonb not null,            -- 대시보드 전체 상태
  client_id  text,                      -- 에코 방지용 (누가 쓴 변경인지)
  updated_by text,                      -- 표시용 이름
  updated_at timestamptz not null default now()
);

-- 2. RLS 활성화
alter table public.board enable row level security;

-- 3. 정책: 인증 없이 누구나 읽고 쓸 수 있게 (URL을 아는 사람 = 편집 가능)
--    ⚠ 이 테이블에는 민감한 정보를 넣지 마세요.
drop policy if exists "anon read"   on public.board;
drop policy if exists "anon insert" on public.board;
drop policy if exists "anon update" on public.board;

create policy "anon read"   on public.board for select using (true);
create policy "anon insert" on public.board for insert with check (true);
create policy "anon update" on public.board for update using (true) with check (true);

-- 4. 실시간(Realtime) 발행 대상에 추가
alter publication supabase_realtime add table public.board;

-- 5. UPDATE 시 이전 행 정보까지 전달되도록 (선택이지만 권장)
alter table public.board replica identity full;
