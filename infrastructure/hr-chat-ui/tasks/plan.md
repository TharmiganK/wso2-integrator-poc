# Implementation Plan: WSO2 IS Login Flow

## Overview

Add OIDC-based authentication to the HR Chat Assistant React + Vite app using the
`@asgardeo/auth-react` SDK (v5.6.2). The flow: unauthenticated users see a login page →
clicking "Sign In" redirects to WSO2 IS → IS redirects back with an auth code → SDK
exchanges it for tokens → user lands on the chat UI. All API calls then include a Bearer
token. No client-side router is needed — a simple `isAuthenticated` conditional render
is sufficient.

## Architecture Decisions

- **`@asgardeo/auth-react`** — WSO2's own React SDK; handles PKCE, token storage,
  refresh, and `useAuthContext()` hook. Chosen over raw `oidc-client-ts` to stay in the
  WSO2 ecosystem.
- **No React Router** — the app has one screen (chat) and one gate (login). A router
  would add complexity with no benefit. Auth state drives conditional rendering instead.
- **`.env.local` for IS config** — `VITE_*` env vars keep client IDs out of source
  control and make environment switching trivial.
- **`src/auth.config.js`** — single source of truth for `AuthProvider` props, so the
  config is testable and not buried in JSX.
- **Auth guard at the `App` boundary** — `App.jsx` checks `isAuthenticated` and renders
  either `<LoginPage>` or the chat UI. Keeps auth logic out of individual components.
- **Bearer token on every chat request** — `getAccessToken()` is called inside
  `sendMessage` so the Ballerina backend can optionally validate the JWT later.

## Dependency Graph

```
WSO2 IS SPA Registration (manual — provides clientID)
    │
    └── .env.local  (VITE_AUTH_CLIENT_ID, VITE_AUTH_BASE_URL, redirect URLs)
            │
            └── src/auth.config.js
                    │
                    └── src/main.jsx  <AuthProvider config={authConfig}>
                                │
                                ├── src/LoginPage.jsx   (useAuthContext → signIn())
                                │
                                └── src/App.jsx
                                        ├── auth guard  (isAuthenticated)
                                        ├── header user info  (getBasicUserInfo())
                                        └── sendMessage  (getAccessToken() → Bearer)
```

Implementation order follows bottom-up: IS registration → env/config → AuthProvider →
login page + guard → user info → token forwarding.

---

## Phase 1: SDK Wiring

### Task 1: Install SDK, configure AuthProvider, wire `.env.local`

**Description:** Install `@asgardeo/auth-react`, create `.env.local` with IS connection
variables, add `src/auth.config.js` that reads them, and wrap the React tree in
`<AuthProvider>` inside `main.jsx`. After this task the app boots and immediately
redirects to WSO2 IS (because no user is authenticated yet). There is no login page yet —
the redirect is the proof that wiring works.

**Acceptance criteria:**
- [ ] `npm run dev` starts without errors
- [ ] Opening `http://localhost:5173` in a browser triggers a redirect to the WSO2 IS
      login URL (i.e., the browser navigates to `https://<IS_HOST>/oauth2/authorize?...`)
- [ ] No `Cannot find module` or missing env-var errors in the console

**Verification:**
- [ ] Build succeeds: `npm run build`
- [ ] Manual: open app, confirm redirect URL contains `client_id`, `code_challenge`, and
      `redirect_uri` matching `.env.local` values

**Dependencies:** None (WSO2 IS app must be registered first — see pre-requisite below)

**Files touched:**
- `package.json` (add `@asgardeo/auth-react`)
- `.env.local` (new — git-ignored)
- `.gitignore` (ensure `.env.local` is listed)
- `src/auth.config.js` (new)
- `src/main.jsx`

**Estimated scope:** Small

---

### Task 2: Login page + auth guard (complete sign-in round-trip)

**Description:** Add a `<LoginPage>` component with a "Sign In with WSO2" button that
calls `signIn()` from `useAuthContext`. Add an auth guard in `App.jsx` that renders
`<LoginPage>` when `!isAuthenticated` and the existing chat UI when `isAuthenticated`.
After this task the full OIDC round-trip works: user lands on login page → clicks Sign In
→ IS login form → redirected back → chat UI appears.

**Acceptance criteria:**
- [ ] Unauthenticated visit to `localhost:5173` shows the login page (not the chat)
- [ ] Clicking "Sign In" redirects to WSO2 IS login form
- [ ] After successful IS login, user is redirected back to `localhost:5173` and the chat
      UI is shown
- [ ] Refreshing the page while authenticated keeps the user on the chat (token persisted
      in session storage by SDK)
- [ ] No auth-related errors in the browser console after redirect

**Verification:**
- [ ] Build succeeds: `npm run build`
- [ ] Manual: full sign-in flow from login page to chat UI
- [ ] Manual: hard refresh on chat UI stays authenticated

**Dependencies:** Task 1

**Files touched:**
- `src/LoginPage.jsx` (new)
- `src/LoginPage.css` (new)
- `src/App.jsx` (add `useAuthContext`, conditional render)

**Estimated scope:** Small–Medium

---

## Checkpoint: After Tasks 1–2

- [ ] `npm run build` clean
- [ ] Full OIDC sign-in round-trip works manually
- [ ] Chat UI is unreachable without authentication
- [ ] **Human review before proceeding**

---

## Phase 2: User Context

### Task 3: User info in header + logout button

**Description:** After sign-in, resolve the logged-in user's display name and email via
`getBasicUserInfo()`. Replace the static 🤝 emoji avatar with a circle showing the
user's initials. Add a logout button to the header that calls `signOut()`. This gives the
UI a personalised feel and completes the session lifecycle.

**Acceptance criteria:**
- [ ] Header shows the user's display name (or username if display name is absent)
- [ ] Avatar circle shows the first letter of the display name in place of the emoji
- [ ] "Sign Out" button appears in the header
- [ ] Clicking "Sign Out" clears the session and returns the user to the login page
- [ ] User info does not flash or cause layout shift on load

**Verification:**
- [ ] Build succeeds: `npm run build`
- [ ] Manual: sign in, verify name + initial render correctly
- [ ] Manual: sign out, verify chat is no longer accessible

**Dependencies:** Task 2

**Files touched:**
- `src/App.jsx` (header section — `getBasicUserInfo`, signOut button)
- `src/App.css` (user avatar styles — initial circle, sign-out button)

**Estimated scope:** Small

---

## Checkpoint: After Task 3

- [ ] `npm run build` clean
- [ ] Sign-in, user info, and sign-out all work end-to-end
- [ ] **Human review before proceeding**

---

## Phase 3: Security

### Task 4: Forward Bearer token on every chat API call

**Description:** Call `getAccessToken()` inside `sendMessage` and attach the result as
`Authorization: Bearer <token>` on the `POST /chatAssistant/chat` request. This allows
the Ballerina backend to validate the caller's identity now or in a future iteration. The
Vite proxy will forward the header unchanged to `localhost:9090`.

**Acceptance criteria:**
- [ ] Every `POST /chatAssistant/chat` request includes `Authorization: Bearer <token>`
      (visible in browser DevTools → Network tab)
- [ ] Chat still functions correctly after the header is added
- [ ] If `getAccessToken()` returns null/undefined (edge case), the request is blocked
      and an error message is shown rather than sending a tokenless request

**Verification:**
- [ ] Build succeeds: `npm run build`
- [ ] Manual: DevTools Network → request headers contain `Authorization: Bearer …`
- [ ] Manual: chat reply still arrives after adding the header

**Dependencies:** Task 3

**Files touched:**
- `src/App.jsx` (`sendMessage` function only)

**Estimated scope:** Extra Small

---

## Checkpoint: Complete

- [ ] `npm run build` clean, zero warnings
- [ ] Full flow end-to-end: anonymous → login page → IS login → chat → token in requests
      → sign out → login page
- [ ] All acceptance criteria in Tasks 1–4 manually verified
- [ ] Ready for human review / merge

---

## Pre-requisite: WSO2 IS Application Registration

Before Task 1 can be started, register an SPA in WSO2 IS:

1. Log in to WSO2 IS Management Console
2. **Applications → New Application → Single Page Application**
3. Set **Allowed redirect URLs**: `http://localhost:5173`
4. Set **Allowed logout redirect URLs**: `http://localhost:5173`
5. Enable **PKCE** (mandatory for SPAs)
6. Under **API Authorisation**, allow the `openid`, `profile`, and `email` scopes
7. Note the generated **Client ID** — this goes into `.env.local`

`.env.local` template (never commit this file):
```
VITE_AUTH_CLIENT_ID=<client-id-from-IS>
VITE_AUTH_BASE_URL=https://<IS_HOST>:<IS_PORT>
VITE_SIGN_IN_REDIRECT_URL=http://localhost:5173
VITE_SIGN_OUT_REDIRECT_URL=http://localhost:5173
```

---

## Risks and Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| WSO2 IS running on self-signed TLS | High — browser blocks redirect | Import IS cert into browser trust store, or run IS with a valid cert |
| `@asgardeo/auth-react` peer dep conflict with React 19 | Medium | Check peer deps at install time; SDK v5.x targets React 18 but React 19 is backwards compatible in practice |
| IS redirect URL mismatch | High — auth fails silently | Exactly match `.env.local` value with the URL registered in IS (trailing slash matters) |
| Token expiry mid-session | Low — SDK auto-refreshes | SDK handles silent token renewal; test by waiting past access token TTL |
| `getAccessToken()` called before hydration | Low | Call inside `sendMessage` (event-driven), not in a render or effect |

## Open Questions

- What is the WSO2 IS host and port for this environment? (Needed before Task 1)
- Should the Ballerina backend validate the JWT, or is the token purely for future use?
- Should "New Session" also clear auth, or only clear chat history? (Current plan: chat history only)
