# fintech_demo — "Verdant Bank"

A template digital-banking UI, built to exercise every
`packages/design_system` component inside real, navigable screens rather
than Widgetbook's isolated per-widget use cases. Static mock data only
(`lib/src/data/mock_data.dart`), no network calls, no DI container — a UI
showcase, not a shippable app (contrast with `apps/mobile`, the real
composition root).

Fintech was picked deliberately: dashboards, multi-step forms, tables,
charts, transfer/payment flows, and settings screens together touch a
wider breadth of component types than most other domains would in one
app. Two components genuinely missing from `design_system` when this app
needed them were added there, not duplicated locally — `AppLineChart`
(§10.14) and `AppStepper` (§10.25); see
`docs/VERDANT_DESIGN_SYSTEM.md`'s v1.8 revision note.

## Run it

```
cd apps/fintech_demo
fvm flutter run -d chrome
```

## Screens → components

| Screen | design_system components exercised |
|---|---|
| Splash | `AppLoadingIndicator` |
| Onboarding | `AppButton` |
| Login | `AppTextField`, `AppPasswordField`, `AppButton`, `AppDialog`, `AppSnackBar` |
| OTP verify | `AppOtpField`, `AppLoadingIndicator`, `AppSnackBar` |
| Register (KYC) | `AppStepper`, `AppTextField`, `AppDropdown`, `AppDatePicker`, `AppRadio`, `AppCard`, `AppCheckbox`, `AppDialog` |
| Home (shell) | `AppNavigationBar`/`AppSidebar` (`AdaptiveLayout`), `AppExpressiveCard`, `AppBarChart`, `AppList`, `AppTag`, `AppStatusBadge`, `AppTooltip` |
| Cards | `AppCard`, `AppSwitch`, `AppMenu`, `VerdantIcon` |
| Transfer | `AppSearchField`, `AppAvatar`, `AppTextField`, `AppRadio`, `AppDialog`, `AppSnackBar` |
| Bills | `AppDropdown`, `AppTextField`, `AppDatePicker`, `AppSwitch`, `AppTable` |
| Transactions | `AppSearchField`, `AppTabs`, `AppList`, `AppStatusBadge`, `AppStateView`, `AppLoadingIndicator` |
| Invest | `AppLineChart`, `AppTabs`, `AppList`, `AppTag`, `AppAvatar` |
| Notifications | `AppStateView` |
| Profile / Settings | `AppAvatar`, `AppExpressiveCard`, `AppSwitch`, `AppTooltip`, `AppBottomSheet`, `AppDialog`, `AppButton` |

## Tests

`test/app_smoke_test.dart` renders every top-level page against real mock
data and asserts it builds without throwing, plus one end-to-end
navigation test (splash → onboarding → login). This is not a substitute
for `design_system`'s own golden-tested component coverage — it's a
regression guard on this app's own wiring (routes, mock-data plumbing,
per-page composition), which golden tests one level down can't see.
