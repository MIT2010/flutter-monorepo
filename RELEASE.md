# Release Runbook

The fourth document, alongside [README.md](README.md), [ARCHITECTURE.md](ARCHITECTURE.md)
(§30 Release Strategy / §31 Versioning Strategy — the *why*), and
[CONTRIBUTING.md](CONTRIBUTING.md). This file is the *how* — every step
below has actually been run at least once against this repo (dated
2026-07-12), not transcribed from what should theoretically work. Where
something was found NOT to work as documented, that's recorded here too,
not smoothed over.

---

## 1. Prerequisites

### Android signing

`apps/mobile/android/app/build.gradle.kts`'s `release` build type signs
with the **debug key** until `apps/mobile/android/key.properties` exists
— that's deliberate for `flutter run --release` (quick local testing,
zero setup), but a `.aab` signed that way cannot be uploaded to Play
Store and shouldn't be distributed to anyone. `melos run build:dev` /
`build:staging` / `build:prod` refuse to even attempt a build without a
real `key.properties` (`tool/verify_signing.dart`) — verified directly:
running `melos run build:dev` today, on a fresh checkout with no
`key.properties`, stops with an explicit TODO message before Gradle ever
runs, rather than silently producing a debug-signed artifact.

To set up real signing, once per project (not once per release):

```bash
keytool -genkey -v -keystore <path-outside-this-repo>/upload-keystore.jks \
  -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Keep the resulting `.jks` **outside this repo entirely** — a password
manager's file storage or your CI provider's secret storage, never
committed, never even placed inside the repo folder where it could be
`git add -A`'d by accident. Then:

```bash
cp apps/mobile/android/key.properties.example apps/mobile/android/key.properties
# edit key.properties: storePassword / keyPassword / keyAlias / storeFile
# (storeFile is the absolute path to the .jks you just generated)
```

`key.properties` and `*.jks`/`*.keystore` are gitignored — verify
`git status` shows nothing after this step.

**Verified 2026-07-12**: generated a throwaway keystore, pointed
`key.properties` at it, ran `melos run build:dev` — it produced a real
`.aab` signed with that keystore (not the debug key), confirming
`build.gradle.kts`'s conditional signing config actually works, not just
that it compiles. The throwaway keystore and `key.properties` were
deleted afterward; neither is committed.

**A real, unrelated bug was found and fixed during this same test**: AGP
disables the `resValue()` build feature by default, and §30's per-flavor
app-name badges (`resValue(type = "string", name = "app_name", ...)` in
`build.gradle.kts`) use it — the very first real build attempt in this
repo's history failed with *"Product Flavor dev contains custom resource
values, but the feature is disabled"* before ever reaching the signing
step. Fixed by adding `buildFeatures { resValues = true }`. This had been
sitting broken, undetected, since the flavors were first added — nobody
had run `flutter build` (only `flutter run`, which doesn't hit the same
resource-merging path the same way) until this runbook was written.

### iOS signing

**Not verified on this machine — no macOS/Xcode toolchain available in
this environment.** iOS code signing is enforced by Xcode itself at
archive time (missing Team ID / provisioning profile is already a hard
failure, unlike Android's silent debug-key fallback), so the same class
of "succeeds with the wrong signature, no warning" risk does not appear
to apply — but that claim is reasoned from how Xcode signing generally
behaves, not from having personally run it against this repo's
`Runner.xcodeproj`.

What IS verified: `apps/mobile/ios/Flutter/Release-<flavor>.xcconfig` and
`Runner.xcodeproj/xcshareddata/xcschemes/<flavor>.xcscheme` genuinely
exist for all three flavors (checked directly), so the flavor plumbing
itself is real, just untested end-to-end for a release archive.

To set up, on a Mac with Xcode:
1. Open `apps/mobile/ios/Runner.xcworkspace` in Xcode.
2. For each flavor scheme (`dev`/`staging`/`prod`), under
   **Signing & Capabilities**, set your Team and let Xcode manage (or
   provide) a real provisioning profile.
3. Export `ExportOptions.plist` (Xcode: Product → Archive → Distribute
   App, choosing your method, then reuse the plist it writes) into
   `apps/mobile/ios/ExportOptions.plist`. `tool/verify_signing.dart ios`
   checks for this file's existence before an eventual `flutter build ipa`
   — same "stop loudly, not silently" shape as the Android check, but
   this half has not been exercised against a real Xcode build.

---

## 2. Building a release artifact

Android only has a melos script today — iOS requires a Mac, and this
runbook doesn't claim otherwise:

```bash
melos run build:dev       # apps/mobile/build/app/outputs/bundle/devRelease/app-dev-release.aab
melos run build:staging   # .../stagingRelease/app-staging-release.aab
melos run build:prod      # .../prodRelease/app-prod-release.aab
```

Each is `tool/verify_signing.dart android && flutter build appbundle
--flavor <name> -t lib/main_<name>.dart` — the signing gate runs first,
every time.

For iOS, once signing is set up on a Mac (§1 above):

```bash
fvm flutter build ipa --flavor prod -t lib/main_prod.dart
```

No melos script wraps this yet (nothing to point it at without a Mac to
test against) — a reasonable follow-up once the iOS half of §1 is
actually exercised once for real.

---

## 3. Versioning (`melos version`)

§31 of ARCHITECTURE.md names `melos version` (Conventional Commits →
automatic SemVer bump + changelog) as the versioning mechanism.

**Run for real against this repo's actual history, 2026-07-12 —
result: it does nothing.**

```
$ melos version --no-git-commit-version --yes
No packages were found that required versioning.
```

Root cause, checked directly: **zero of this repo's 22 commits use
Conventional Commits format** (`git log --format="%s" | grep -icE
'^(feat|fix|chore|docs|refactor|perf|test|build|ci)(\(.+\))?:'` → `0`).
Every commit message so far is a free-form imperative description ("Add
ADR-012: ...", "Move MIGRATION.md to docs/..."). `melos version`'s
Conventional-Commits parser has nothing to key a version bump off, so it
correctly finds nothing to do — this isn't a melos bug, it's that §31's
own precondition was never actually followed by this repo's own history,
including every commit made while building the features this kit ships.

**This is a real, unresolved gap, not smoothed over**: either (a) commit
messages need to start following Conventional Commits from here forward
for `melos version` to ever do anything on this repo again, or (b) §31
needs to be honest that versioning is manual (`melos version <package>
<major|patch|minor|build|exactVersion>`, the second documented form of
the command) until/unless that convention is adopted. Neither decision
is made here — flagging it is as far as this runbook goes.

When there IS something to version (either after adopting Conventional
Commits, or via the manual per-package form), the real command:

```bash
melos version --yes    # or: melos version <package> <bump>
```

writes `CHANGELOG.md` + bumps `pubspec.yaml` versions, then commits and
tags by default (`--git-commit-version`/`--git-tag-version`, both on by
default) — review the diff it produces before it's the historical
record, the same way you'd review any other commit.

---

## 4. Rollback plan

**§30's stated plan — "keep the previous prod .aab/.ipa artifact in CI
storage for 90 days" — is aspirational, not real yet.** `ci.yaml` today
only runs `gen → analyze → format → test`; nothing builds or uploads a
release artifact on any trigger, so there is no CI-stored history of past
`.aab`/`.ipa` files to roll back to. Recorded here rather than left
implicit, so nobody assumes this exists because the strategy doc
describes it.

**What actually works today, for a solo dev with no CI artifact
storage:**

1. **First lever, and the fastest one: the store's own rollout controls.**
   - **Play Console**: if the release used a staged rollout (recommended
     — start new prod releases at a small percentage, not 100%), halting
     it is immediate and doesn't require any local artifact at all.
     Already-installed users keep the broken version until you ship a
     fix, but the bleeding stops for everyone else instantly.
   - **App Store Connect**: no staged-rollout halt equivalent as clean as
     Play's, but you can pull a release from sale / expedite a fixed
     build's review.
2. **If you need to actually re-publish the previous binary** (staged
   rollout wasn't used, or the store-level halt isn't enough): you need
   your own copy of the previous `.aab`/`.ipa` — there is no other
   source right now. Keep the last few `melos run build:*` outputs
   somewhere outside git (binary build artifacts don't belong in commit
   history) — a dedicated cloud-storage folder is enough for a solo
   project at this scale; don't build release-artifact infrastructure
   you don't have the release cadence to justify yet (§32's scaling
   table reasoning applies here too).
3. **A real git revert is still correct for the *code*** — rolling back
   the binary (steps 1-2) buys time; reverting the commit(s) that caused
   the regression is still the actual fix, same as any other bug.

**A concrete next step, not built here**: once real signing secrets
exist for a specific project, a `workflow_dispatch` (or git-tag-triggered)
GitHub Actions job — same shape as `.github/workflows/goldens.yml` — that
runs `melos run build:prod` with the signing secrets injected via GitHub
Secrets, then `actions/upload-artifact` (GitHub retains these 90 days by
default, matching §30's number) would make the "keep the artifact for 90
days" claim literally true. Not built as part of this runbook because it
needs real signing credentials this repo doesn't have and can't fabricate
convincingly — sketched here so it isn't reinvented from scratch, not
because it was tried and abandoned.

---

## See also

- [ARCHITECTURE.md](ARCHITECTURE.md) §30 (Release Strategy) / §31
  (Versioning Strategy) — the reasoning this runbook makes concrete.
- [CONTRIBUTING.md](CONTRIBUTING.md) §6 — CI, and the golden-file
  regeneration workflow this runbook's `workflow_dispatch` pattern
  (§4 above) is modeled on.
