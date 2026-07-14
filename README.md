딥하우스 라운지 파티 — 공동 기획 보드
URL을 아는 사람은 누구나 실시간으로 함께 편집하는 파티 기획 대시보드.
정적 페이지(GitHub Pages) + Supabase(데이터 + 실시간 동기화)로 서버 없이 굴러갑니다.
---
1. Supabase 준비 (5분)
https://supabase.com 에서 새 프로젝트 생성
좌측 SQL Editor → `schema.sql` 내용을 붙여넣고 Run
Project Settings → API 에서 두 값을 복사
`Project URL`
`anon` `public` key
2. 값 채우기
`index.html` 상단의 설정 블록을 채웁니다.
```js
const SUPABASE_URL      = "https://xxxxxxxx.supabase.co";
const SUPABASE_ANON_KEY = "eyJhbGciOi...";
const BOARD_ID          = "party-2026";
```
> 비워두면 오프라인 모드로 뜨고, 상단에 경고 배너가 표시됩니다. (저장·공유 안 됨)
3. GitHub에 올리기
```bash
mkdir party-board && cd party-board
# index.html, schema.sql, README.md 를 이 폴더에 넣기

git init
git add .
git commit -m "init: live party planning board"
git branch -M main
git remote add origin https://github.com/<USERNAME>/party-board.git
git push -u origin main
```
4. GitHub Pages 켜기
repo → Settings → Pages → Source: `Deploy from a branch` → Branch: `main` / `/ (root)` → Save
1~2분 뒤 아래 주소로 열립니다.
```
https://<USERNAME>.github.io/party-board/
```
이 URL을 같이 기획하는 사람들에게 보내면 끝입니다.
---
동작 방식
항목	내용
저장	편집 0.5초 뒤 자동 저장 (디바운스). 상단 점이 노랑 → 초록으로 바뀜
실시간	Supabase Realtime 구독. 다른 사람의 수정이 즉시 반영됨
충돌	Last-write-wins. 같은 칸을 동시에 고치면 나중에 저장한 쪽이 이김
커서 보호	내가 타이핑 중이면 원격 변경을 보류했다가, 포커스가 빠질 때 적용
이름	상단 입력칸에 이름을 적으면 "누가 수정함"이 다른 사람에게 표시됨
편집 조작
✎ 편집 버튼을 켜면 모든 텍스트가 편집 가능해집니다 (`Ctrl/Cmd + B`로 굵게)
+ 카드 추가 — 하단 버튼. 자유 형식 카드가 추가됩니다
카드 헤더의 ▲▼ — 카드 순서 변경, × — 카드 삭제
기획 순서 카드: 번호 클릭 → 기본 / 완료 / 진행 중 순환
리스크 카드: 라벨 클릭 → 리스크 / 자산 / 자산=리스크 순환
타임라인 카드: 편집 모드에서 VU 미터 막대 클릭 → 레벨 조정
베뉴 질문지: ★ 필수 표시, 체크박스로 답변 완료, 아래 줄에 답변 메모
주의
`anon key`는 소스에 그대로 노출됩니다. URL을 아는 사람은 누구나 편집·삭제할 수 있습니다. 의도된 동작이지만, 민감한 정보는 넣지 마세요.
초기화 버튼은 모두의 보드를 되돌립니다. 누르기 전에 내보내기로 JSON 백업을 받아두세요.
보드 여러 개 쓰기
`BOARD_ID`만 바꾸면 됩니다. 같은 페이지에서 URL 파라미터로 나누고 싶다면:
```js
const BOARD_ID = new URLSearchParams(location.search).get("board") || "party-2026";
```
→ `?board=summer-rooftop` 으로 별도 보드 사용
