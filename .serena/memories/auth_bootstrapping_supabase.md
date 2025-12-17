# Auth Bootstrapping (Supabase)

## Goal
Implements docs/WAFFIR Frontend Integration.md §1 (Authentication & Bootstrapping) using Supabase auth and the required "after-login" bootstrap calls.

## Key Files
- `lib/features/auth/data/repositories/supabase_auth_repository.dart`
  - Supabase-backed `AuthRepository` implementation.
  - OTP: `signInWithOtp(phone)` + `verifyOTP(phone, token)`.
  - Social:
    - Google: uses `google_sign_in_platform_interface` (v3+) to `init` + `authenticate`, then exchanges tokens via `supabase.auth.signInWithIdToken(provider: google)`.
    - Apple: native `sign_in_with_apple` + `supabase.auth.signInWithIdToken(provider: apple, nonce)`.
  - Updates profile metadata via `supabase.auth.updateUser(UserAttributes(data: ...))`.

- `lib/features/auth/data/repositories/supabase_auth_bootstrap_repository.dart`
  - Runs the 4 required calls post-login:
    - `rpc('get_my_account_details')`
    - `from('user_settings').select('*').eq('user_id', uid).maybeSingle()`
    - `rpc('user_has_had_subscription_before')`
    - `rpc('get_my_family_invites')`
  - Handles family invite response: `rpc('respond_family_invite', params: {p_invite_id, p_action})`.

- `lib/features/auth/data/providers/auth_bootstrap_providers.dart`
  - `authBootstrapControllerProvider` (AsyncNotifier) bootstraps after auth state becomes authenticated.
  - `pendingFamilyInviteIdProvider` implemented with `NotifierProvider` (Riverpod 3; avoids legacy `StateProvider`).
  - `isBootstrappedProvider` indicates when bootstrapping is complete.

- Routing integration
  - `lib/core/navigation/route_guards.dart`: AuthGuard now depends on auth status + bootstrap completion (keeps authenticated users on Splash until bootstrapped).
  - `lib/features/onboarding/presentation/screens/splash_screen.dart`: becomes the decision point:
    - City selected? else -> `AppRoutes.citySelection`
    - Authenticated? else -> `AppRoutes.login`
    - Bootstrapped? else -> stay on splash
    - Invite pending? show accept/reject dialog and call `respond_family_invite`
    - Profile complete (name+gender+acceptedTerms) -> `AppRoutes.home` else -> `AppRoutes.accountDetails`

- Deep link stub
  - `lib/features/auth/presentation/screens/family_invite_link_screen.dart` + `AppRoutes.familyInviteLink`:
    - Stores inviteId into `pendingFamilyInviteIdProvider` then redirects to splash (auth first, no auto-accept).

## Env additions
- `.env.example` now includes:
  - `GOOGLE_CLIENT_ID_IOS`, `GOOGLE_CLIENT_ID_WEB`, `GOOGLE_CLIENT_ID_ANDROID` (optional)
  - `APPLE_CLIENT_ID`
  - `DEEP_LINK_SCHEME`, `DEEP_LINK_HOST`

## Riverpod 3 notes
- Avoid `StateProvider` (legacy); prefer `NotifierProvider`.
- Avoid `AsyncValue.valueOrNull`; use `hasValue` + `value`.

## Tooling note
If the environment blocks writing to `~/.dart-tool`, run Dart commands with `--suppress-analytics` (e.g. `dart --suppress-analytics run build_runner ...`).
