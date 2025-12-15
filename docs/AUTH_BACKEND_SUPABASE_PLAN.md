# Auth Backend (Supabase) Plan — `lib/features/auth`

## Context (current state)

- `lib/features/auth` already follows clean-architecture structure and exposes a single `AuthRepository` contract used by `AuthController`.
- Backend selection is implemented in `lib/features/auth/data/providers/auth_providers.dart`:
  - `MockAuthRepository` (default, controlled via `USE_MOCK_AUTH=true`)
  - `CloudFunctionsAuthRepository` (placeholder for backend endpoints)
- UI flows now call the repository/controller (no local `Future.delayed` mocks) for:
  - `lib/features/auth/presentation/screens/phone_login_screen.dart` (OTP request + Google/Apple)
  - `lib/features/auth/presentation/screens/otp_verification_screen.dart` (OTP verify)
  - `lib/features/auth/presentation/screens/account_details_screen.dart` (profile write via `updateUserData`)
- Supabase dependency exists in `pubspec.yaml` (`supabase_flutter`) and is optionally initialized in `lib/main.dart` when env vars are present.

## Goal (target state)

Use Supabase Auth semantics (OTP/OAuth), but call them via **backend cloud-function endpoints**. Until those endpoints exist, keep the app working end-to-end using a **mock backend**. When backend is ready, switching mock ↔ real should be a **configuration flip** (or a minimal provider swap), not a UI rewrite.

Key requirements:
- Presentation layer stays backend-agnostic (no direct Supabase calls in widgets).
- Switching mock ↔ real is isolated to providers/configuration.
- Keep the existing `AuthRepository` interface stable; if a method is not ready, return a consistent `Failure.featureNotAvailable(...)`.

## Proposed architecture

### 1) Backend selection (mock vs cloud functions)

- Add an environment flag:
  - `USE_MOCK_AUTH=true|false` (default `true` for dev until backend is ready)
- `authRepositoryProvider` chooses implementation based on `USE_MOCK_AUTH`.

### 2) Split responsibilities

**Mock implementation (already in place)**
- `lib/features/auth/data/datasources/mock_auth_store.dart`
- `lib/features/auth/data/repositories/mock_auth_repository.dart`

**Real backend (cloud functions)**
- `lib/features/auth/data/datasources/auth_api_endpoints.dart` (endpoint paths; will be implemented by backend)
- `lib/features/auth/data/repositories/cloud_functions_auth_repository.dart` (currently a placeholder)

**Core client/provider**
- `lib/core/providers/supabase_providers.dart` exposes `supabaseClientProvider` (currently unused by auth; kept for future direct Supabase usage if desired).

### 3) Supabase initialization

Initialize in `lib/main.dart` once env is loaded:
- `Supabase.initialize(url: EnvironmentConfig.supabaseUrl, anonKey: EnvironmentConfig.supabaseAnonKey)`
- For session persistence, use `FlutterAuthClientOptions` default storage unless we need to align with the project’s encrypted Hive strategy later.

## Supabase backend contract (DB + auth)

### Auth (Supabase Auth)

Minimal set to unblock current UI (implemented via backend endpoints later):
- Email/password: `signUp`, `signInWithPassword`, `resetPasswordForEmail`
- OAuth:
  - Google: native Google sign-in + `supabase.auth.signInWithIdToken(provider: OAuthProvider.google, ...)`
  - Apple: native Apple sign-in + `supabase.auth.signInWithIdToken(provider: OAuthProvider.apple, ...)`
- Phone OTP (if required by product):
  - `signInWithOtp(phone: ...)` (send code)
  - `verifyOTP(...)` (confirm code)

Auth state stream:
- In the app: repository emits `AuthState` via `authStateChanges`.
- In backend-ready mode: `CloudFunctionsAuthRepository` will map backend responses → `AuthState`.

### Profile table (`profiles`)

Backend-owned recommendation (not implemented in app right now):

Create a `profiles` table keyed by `auth.users.id`:
- `id uuid primary key references auth.users(id) on delete cascade`
- `email text`
- `display_name text`
- `phone_number text`
- `first_name text`
- `last_name text`
- `date_of_birth text` (or `date` if we want strict typing)
- `gender text`
- `country text`
- `language text`
- `timezone text`
- `photo_url text`
- `roles text[]`
- `preferences jsonb`
- `created_at timestamptz default now()`
- `updated_at timestamptz default now()`

Policies:
- Enable RLS and allow:
  - `select` where `id = auth.uid()`
  - `insert/update` where `id = auth.uid()`

Profile upsert strategy (choose one):
- Client-side `upsert` into `profiles` after sign-in/sign-up
- Or DB trigger on `auth.users` insert to auto-create a `profiles` row (recommended)

## Mapping to existing domain models

### `UserModel`

Populate from:
- Supabase `User` (auth identity) + `profiles` row (app fields)

### `AuthState`

On authenticated session:
- `idToken` ← Supabase access token
- `refreshToken` ← Supabase refresh token
- `tokenExpiry` ← session expiry timestamp

Non-1:1 mappings:
- `emailVerificationRequired`: map from Supabase user confirmation status (if email confirmation is enabled)
- `mfaRequired`, provider linking/unlinking: keep as `notSupported` until required

## Implementation checkpoints (track progress)

### Checkpoint 0 — Planning complete

- [x] Confirm required auth methods for v1:
  - [x] Email/password
  - [x] Phone OTP
  - [x] Google OAuth
  - [x] Apple OAuth
- [x] Confirm whether email confirmation is enabled in Supabase for production (not required).

### Checkpoint 1 — Configuration + initialization

- [x] Add `USE_MOCK_AUTH` to `.env.example` (see `.env.example`).
  - [ ] Add `USE_MOCK_AUTH` to local `.env.dev/.env.staging/.env.production` (gitignored; do locally).
- [x] Initialize Supabase during app startup (after `EnvironmentConfig.initialize()`) when env vars exist (`lib/main.dart`).
- [x] Add a core `supabaseClientProvider` (`lib/core/providers/supabase_providers.dart`).

### Checkpoint 2 — Mock backend (works today)

- [x] Implement `MockAuthRepository` + store that:
  - [x] simulates OTP send/verify
  - [x] simulates Google/Apple sign-in
  - [x] produces consistent `AuthState` and `authStateChanges`
  - [x] persists mock session in Hive (`HiveService.userBox`)
- [x] Wire `authRepositoryProvider` to return mock when `USE_MOCK_AUTH=true` (`lib/features/auth/data/providers/auth_providers.dart`).

### Checkpoint 3 — Cloud functions backend (real, not deployed yet)

- [x] Add endpoint contract placeholders (`lib/features/auth/data/datasources/auth_api_endpoints.dart`).
- [x] Add repository placeholder that returns `featureNotAvailable` until backend exists (`lib/features/auth/data/repositories/cloud_functions_auth_repository.dart`).
- [ ] Implement `CloudFunctionsAuthRepository` to call backend endpoints and map responses → `AuthState` + `UserModel`.

### Checkpoint 4 — Presentation wiring (remove local mocks)

- [x] `PhoneLoginScreen` calls controller/repo instead of `Future.delayed`.
- [x] `OtpVerificationScreen` uses `verifyPhoneWithCode`.
- [x] `SignupScreen` uses `createUserWithEmailAndPassword` and is routed in `buildAppRoutes()`.
- [x] `AccountDetailsScreen` uses `updateUserData`.

### Checkpoint 5 — “Backend ready” switch

- [ ] Flip `USE_MOCK_AUTH=false` (dev/staging first).
- [ ] Provide backend base URL + any keys in env files.
- [ ] Confirm OAuth redirect URIs + client IDs (if backend does native token exchange).
- [ ] Replace only `CloudFunctionsAuthRepository` endpoint calls/mapping (no UI changes).

## Decisions (confirmed)

1) **Phone OTP**: follow Supabase OTP semantics, but **mock the calls for now** (backend not deployed yet).
2) **Email verification**: **not required** in production.
3) **Profile**: keep mocked for now; real profile will be provided via **cloud functions** endpoints (swap endpoints/config only).
