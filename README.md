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
| `gen` | Codegen (freezed/json_serializable/injectable), ordered so `core` rebuilds before packages that depend on it | After changing any `@freezed`/`@injectable`/`@JsonSerializable` class |
| `clean` | `flutter clean` on every package, through the pinned SDK | When the build feels stale/corrupted, or before a fresh `get` |
| `upgrade` | `flutter pub upgrade` — bumps deps to the newest version still allowed by `pubspec.yaml` constraints | Deliberately, never as a reflex — see `outdated` first |
| `outdated` | `flutter pub outdated` — reports packages with newer versions outside current constraints, doesn't change anything | Every quarter per §33 of ARCHITECTURE.md (Long-Term Maintenance Strategy) — **read each package's changelog before acting on this, never auto-upgrade blind** |
| `run:dev` / `run:staging` / `run:prod` | Runs `apps/mobile` with the matching flavor and entry point | Manual testing per environment — **`run:prod` talks to the real production API, don't use it for casual testing** |
| `run:dev:web` | Same as `run:dev` but forced to Chrome | Quick web-target smoke testing |

`--flavor dev|staging|prod` pairs with `-t apps/mobile/lib/main_<flavor>.dart`
— see §30 of ARCHITECTURE.md for the full flavor story.
