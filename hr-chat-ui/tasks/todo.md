# Task List: WSO2 IS Login Flow

## Pre-requisite (manual — human action required)
- [ ] Register SPA in WSO2 IS, note Client ID, configure redirect URLs (see plan.md)
- [ ] Fill in `.env.local` with real values (template created at `hr-chat-ui/.env.local`)

---

## Phase 1: SDK Wiring

- [x] **Task 1** — Install `@asgardeo/auth-react`, add `.env.local`, create `src/auth.config.js`, wrap tree in `<AuthProvider>` in `main.jsx`
- [x] **Task 2** — Add `<LoginPage>` with Sign In button, add auth guard in `App.jsx`

### Checkpoint 1
- [x] `npm run build` clean
- [ ] Full OIDC sign-in round-trip works  ← needs real IS config
- [ ] Human review ✋

---

## Phase 2: User Context

- [x] **Task 3** — Resolve user info via `getBasicUserInfo()`, show initials avatar + display name in header, add Sign Out button calling `signOut()`

### Checkpoint 2
- [x] `npm run build` clean
- [ ] Sign-in → user info visible → sign-out → back to login page  ← needs real IS config
- [ ] Human review ✋

---

## Phase 3: Security

- [x] **Task 4** — Call `getAccessToken()` in `sendMessage`, attach `Authorization: Bearer` header to every `/chatAssistant/chat` request

### Checkpoint 3 (Final)
- [x] `npm run build` clean, zero errors
- [ ] Full flow verified end-to-end in browser  ← needs real IS config
- [ ] Human review ✋
