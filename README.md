# Flutter Starter Kit

See [ARCHITECTURE.md](ARCHITECTURE.md) for the full design (package
boundaries, dependency rules, testing strategy, ADRs).

## Prerequisites

This repo pins its Flutter SDK version via [FVM](https://fvm.app/) in
[`.fvmrc`](.fvmrc). **Never run a bare `flutter`, `dart`, or `melos`
command** — always go through FVM, so you're guaranteed to use the exact
SDK version this project was built and tested against, not whatever
happens to be your machine's ambient/global Flutter install (see
ADR-006 for why this matters).

```bash
dart pub global activate fvm   # once, if you don't have it yet
fvm install                    # installs the pinned version from .fvmrc
```

Every command in this repo is one of exactly three forms:

```bash
fvm flutter <args>       # e.g. fvm flutter pub get
fvm dart <args>          # e.g. fvm dart format .
fvm exec melos run <name>  # e.g. fvm exec melos run analyze
```

## Common tasks

```bash
fvm flutter pub get            # resolve the whole workspace
fvm exec melos run gen         # codegen (freezed/json_serializable/injectable)
fvm exec melos run analyze     # dart analyze, every package
fvm exec melos run test        # dart test / flutter test, every package
fvm exec melos run format      # dart format --set-exit-if-changed

fvm flutter run --flavor dev -t apps/mobile/lib/main_dev.dart \
  --dart-define=API_BASE_URL=<url>
```

`--flavor dev|staging|prod` pairs with `-t apps/mobile/lib/main_<flavor>.dart`
— see §30 of ARCHITECTURE.md for the full flavor story.
