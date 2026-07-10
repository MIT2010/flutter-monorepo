# Flutter Starter Kit

See [ARCHITECTURE.md](ARCHITECTURE.md) for the full design (package
boundaries, dependency rules, testing strategy, ADRs).

## Prerequisites

This repo **requires** [FVM](https://fvm.app/) — it is not optional tooling,
it's enforced (see ADR-006). Right after cloning, and before running
anything else:

```bash
dart pub global activate fvm    # once, if you don't have it yet
fvm use <versi-di-.fvmrc> --pin # installs + pins the exact SDK from .fvmrc
melos run doctor                # verifies the pin actually took effect
```

`melos run doctor` must print `FVM OK` before you touch anything else in
this repo. If it doesn't, fix that first — nothing downstream is trustworthy
until it does.

### Bootstrapping a new project from this kit — mandatory first step

If you're using this kit **as the starting point for a new project** (not
just exploring the kit itself), do this **before writing any feature
code** — not as a fix-it-later item (ADR-011):

1. **Replace every platform's placeholder identifier**
   (`com.example.mobile`) with your real one:
   - Android: `namespace` and `applicationId` in
     `apps/mobile/android/app/build.gradle.kts`, and move
     `apps/mobile/android/app/src/main/kotlin/com/example/mobile/MainActivity.kt`
     to match the new package path (updating its `package` declaration).
   - iOS + macOS: `PRODUCT_BUNDLE_IDENTIFIER` in
     `apps/mobile/ios/Runner.xcodeproj/project.pbxproj` and
     `apps/mobile/macos/Runner/Configs/AppInfo.xcconfig` +
     `apps/mobile/macos/Runner.xcodeproj/project.pbxproj`.
   - Linux: `APPLICATION_ID` in `apps/mobile/linux/CMakeLists.txt`.
2. **Prefix every key in
   `packages/authentication/lib/src/data/datasources/secure_token_storage.dart`**
   (`access_token`, `refresh_token`, `cached_user`) with the same
   identifier, pattern `com.<nama-app>.mobile.` — **this is the step that
   actually matters on Windows** (ADR-011): `flutter_secure_storage_windows`
   stores every key as a Windows Credential Manager entry named *literally*
   after the key, with no per-app namespace at all. Two different projects
   bootstrapped from this kit on the same Windows account, both left
   unprefixed, will silently share the same login session. Step 1 alone
   doesn't fix this on Windows — bundle identifiers only matter for
   Android/iOS/macOS's OS-level sandboxing.

Skipping this is easy to miss because nothing fails — the app still runs,
tests still pass, and the bleed only shows up as "why am I already logged
in" the first time you run two kit-bootstrapped projects side by side on
the same machine.

**Generated code (`*.freezed.dart`, `*.g.dart`, `*.config.dart`,
`*.module.dart`) isn't committed** (ADR-007) — run `melos run get` then
`melos run gen` right after cloning, or nothing will compile yet. The one
exception is hive_ce's `*.g.yaml` schema-migration files, which *are*
committed (see the `gen` row below).

**`melos run <anything>` is already safe** — every script body calls
`fvm flutter`/`fvm dart` internally, so the pinned SDK is used even if you
never type `fvm` yourself. But **ad-hoc commands outside melos scripts**
(`flutter run`, a manual `flutter pub get`, etc.) are not — those still
need you to type the `fvm` prefix by hand:

```bash
fvm flutter <args>   # e.g. fvm flutter pub get, fvm flutter run
fvm dart <args>       # e.g. fvm dart format .
```

## Common tasks

All of these are `melos run <name>` — none need an `fvm` prefix, it's
already baked in (see Prerequisites above).

| Script | What it does | When to use it |
| --- | --- | --- |
| `doctor` | Verifies FVM is installed, pinned, and active | First thing after cloning; whenever something feels "off" version-wise |
| `get` | `fvm flutter pub get` — resolves the whole workspace in one step (Pub Workspaces links every `packages/*` and `apps/mobile` automatically) | After cloning, after pulling changes that touch any `pubspec.yaml`, after `clean` |
| `analyze` | `dart analyze` on every package | Before committing/pushing; CI runs it too |
| `format` | `dart format --set-exit-if-changed` on every package | Before committing; CI runs it too |
| `test` | `flutter test` on every package that has a `test/` folder | Before committing/pushing; CI runs it too |
| `gen` | Codegen (freezed/json_serializable/injectable/hive_ce), ordered so `core` rebuilds before packages that depend on it | Right after cloning (its output isn't committed — ADR-007) and after changing any `@freezed`/`@injectable`/`@JsonSerializable`/`@GenerateAdapters` class |
| `clean` | `flutter clean` on every package, through the pinned SDK | When the build feels stale/corrupted, or before a fresh `get` |
| `upgrade` | `flutter pub upgrade` — bumps deps to the newest version still allowed by `pubspec.yaml` constraints | Deliberately, never as a reflex — see `outdated` first |
| `outdated` | `flutter pub outdated` — reports packages with newer versions outside current constraints, doesn't change anything | Every quarter per §33 of ARCHITECTURE.md (Long-Term Maintenance Strategy) — **read each package's changelog before acting on this, never auto-upgrade blind** |
| `run:dev` / `run:staging` / `run:prod` | Runs `apps/mobile` with the matching flavor and entry point | Manual testing per environment — **`run:prod` talks to the real production API, don't use it for casual testing** |
| `run:dev:web` | Same as `run:dev` but forced to Chrome | Quick web-target smoke testing |

`--flavor dev|staging|prod` pairs with `-t apps/mobile/lib/main_<flavor>.dart`
— see §30 of ARCHITECTURE.md for the full flavor story.

## Scaffolding a new feature (`mason make feature`)

```bash
dart pub global activate mason_cli   # once, if you don't have it yet
mason get                            # once per clone (reads mason.yaml)
mason make feature --feature_name=settings -o .
fvm flutter pub get                  # the hook already added it to workspace:
melos run gen
```

The brick generates the **minimal proven slice** (§14, ADR-009): entity →
repository contract + impl → remote datasource → Cubit → page → test
skeleton, pre-wired to `core`/`design_system`/`shared`, and the post-gen
hook adds the package to the root `workspace:` list automatically.

**It deliberately does NOT generate** a UseCase or local caching — those
are per-feature manual decisions, not boilerplate (§21/ADR-004 and §11):
`feature_profile`'s `UpdateProfileUseCase` is the reference for a justified
UseCase, `feature_home` for the offline-cache flow. Wiring into
`apps/mobile` (pubspec dependency, `GoRoute`, the generated
`Feature<Name>PackageModule` in `injection.dart`) also stays manual — see
[bricks/feature/README.md](bricks/feature/README.md).
