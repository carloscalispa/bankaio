# Copilot Instructions for BankAIO

## Project Overview
- **BankAIO** is a Flutter application with a modular architecture, using Riverpod for state management and Firebase for backend services.
- The codebase is organized by feature and layer (config, core, data, domain, features, helpers, injection, presentation, routes, shared).
- Authentication, routing, and theming are handled in `lib/core/` and `lib/main.dart`.
- Integration with Firebase is initialized in `main.dart` via `initializeFirebaseWithEnv`.

## Key Architectural Patterns
- **Riverpod** is used for dependency injection and state management. Providers are defined and consumed throughout the app.
- **Router**: Navigation is managed via a custom router in `core/routes/router.dart`.
- **Theme**: App-wide theming is set in `core/theme/theme.dart`.
- **AuthListener**: Handles authentication state changes globally.
- **Environment Config**: Environment-specific settings are managed in `core/config/environment.dart`.

## Testing & Workflows
- **Integration tests** are in `integration_test/` and use Firebase emulators. See `integration_test/README.md` for detailed test structure and commands.
- Run all integration tests: `flutter test integration_test/`
- Start Firebase emulators before running tests: `firebase emulators:start`
- Use test credentials: `ccalispa@yahoo.es` / `carlitos1001`
- Tests use custom helpers (e.g., `pumpUntilFound`, `waitForNoLoadingIndicators`) and follow the Page Object Pattern.

## Project Conventions
- **Feature-first structure**: Code is grouped by feature and layer for scalability.
- **Environment-aware bootstrapping**: Use `initializeFirebaseWithEnv` with `useEmulators` for local/dev/prod.
- **No sensitive data**: Only test credentials are present; production secrets are not committed.
- **Logging**: Integration tests use emoji-based logging for clarity.
- **State isolation**: Each test cleans up state to avoid cross-test pollution.

## External Integrations
- **Firebase**: Auth, Firestore, Functions. Emulator support is built-in for local testing.
- **Flutter Riverpod**: For state management and dependency injection.

## Examples
- Main entry: `lib/main.dart` shows app bootstrapping, Firebase init, and Riverpod setup.
- Routing: `core/routes/router.dart` defines navigation structure.
- Theming: `core/theme/theme.dart` for app-wide styles.
- Auth: `core/auth/auth_listener.dart` for global auth state handling.

## Recommendations for AI Agents
- Follow the feature/layer structure when adding new code.
- Use existing helpers and patterns for tests and UI logic.
- Reference `integration_test/README.md` for test conventions and workflows.
- Prefer Riverpod for new stateful logic.
- Always use environment-aware initialization for Firebase and other services.

---
For more details, see the main `README.md` and `integration_test/README.md`.
