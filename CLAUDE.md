# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Projects

### MetricPulse

Native iOS app for GrubHub delivery drivers to track Premier tier metrics (OCR, SCR, OTM) over a 14-day rolling window. Built with Swift / SwiftUI / SwiftData. No third-party dependencies. Minimum deployment target: iOS 26.5.

**Build commands:**
```bash
# Build Debug
xcodebuild -project MetricPulse/MetricPulse.xcodeproj -scheme MetricPulse -configuration Debug build

# Build Release
xcodebuild -project MetricPulse/MetricPulse.xcodeproj -scheme MetricPulse -configuration Release build
```

No test suite or linter is configured yet.

**File structure:**
```
MetricPulse/
├── App/
│   ├── MetricPulseApp.swift       — @main entry, model container setup, seeding
│   └── MainTabView.swift          — TabView, deep link handling, reschedule triggers
├── Models/
│   ├── MetricLog.swift            — core shift log model
│   ├── TierConfig.swift           — Premier/Plus/Standard thresholds + seed data
│   └── AppSettings.swift          — driver name, market, preferences, onboarding gate
├── Engine/
│   ├── WindowSnapshot.swift       — result types (WindowSnapshot, MetricAverages, AgingAlert, DayProjection)
│   └── MetricEngine.swift         — rolling window, averages, tier resolution, aging alerts, projections
├── Notifications/
│   ├── AlertContentBuilder.swift  — builds UNMutableNotificationContent per alert
│   ├── NotificationPermission.swift — @Observable permission status + request
│   ├── NotificationScheduler.swift — schedules/clears UNNotificationRequests
│   └── NotificationObserver.swift  — delegate, deep link routing, reschedule trigger
├── Onboarding/
│   ├── OnboardingView.swift        — container, page control, save + complete logic
│   ├── OnboardingWelcomePage.swift — animated welcome + feature bullets
│   ├── OnboardingMetricsPage.swift — expandable OCR/SCR/OTM explainer cards
│   ├── OnboardingProfilePage.swift — name + market capture
│   └── OnboardingNotificationsPage.swift — mock notification previews + permission request
└── Views/
    ├── Dashboard/
    │   ├── DashboardView.swift      — main dashboard, consumes WindowSnapshot
    │   ├── TierBadgeView.swift      — Premier/Plus/Standard badge
    │   ├── MetricCardRow.swift      — three metric cards with progress bars
    │   ├── WindowStripView.swift    — 14-dot timeline strip
    │   └── AgingAlertCard.swift     — aging-out alert cards
    ├── Timeline/
    │   ├── TimelineView.swift       — 60-day scrollable timeline
    │   ├── TimelineHeaderRow.swift  — sticky column headers
    │   ├── TimelineDayRow.swift     — one row per day
    │   ├── DayDetailSheet.swift     — tap a row to see full metric breakdown
    │   └── MetricPill.swift         — colored percentage pill used across screens
    ├── LogEntry/
    │   ├── LogEntryView.swift       — shift log entry form + LogEntryViewModel
    │   ├── StepperRow.swift         — reusable stepper component
    │   └── RatePreview.swift        — live rate feedback pill
    ├── Calculator/
    │   ├── CalculatorView.swift     — main calculator screen
    │   ├── RequiredMetricRow.swift  — per-metric required vs current bar
    │   ├── AchievabilityBanner.swift — pass/fail summary banner
    │   └── ScenarioCompareView.swift — 1–7 shift side-by-side table
    └── Settings/
        ├── SettingsView.swift        — main settings + NotificationSettingsView + AcknowledgementsView
        ├── TierThresholdEditor.swift — slider-based threshold editing per tier
        ├── PartnerModeSection.swift  — two-driver household toggle (foundation laid)
        └── DataManagementSection.swift — CSV export + delete all + ShareSheet
```

**Key architecture decisions:**

- **Engine is stateless** — `MetricEngine` is a pure struct with static methods. Views query SwiftData, pass the array to `MetricEngine.snapshot()`, and get a `WindowSnapshot` back. No shared state.
- **Raw counts stored, rates computed** — `MetricLog` stores `ordersOffered`, `ordersCompleted`, etc. as integers. `ocr`, `scr`, `otm` are computed properties.
- **Currency as cents** — `earningsCents: Int?` avoids floating-point drift; `earnings: Double?` is computed for display only.
- **TierConfig is user-editable** — thresholds vary by market. Seeded with Premier (90/90/85), Plus (85/85/80), Standard (0/0/0).
- **Notifications are fully local** — `NotificationScheduler` rebuilds the full pending set on every log change or foreground entry. Stable request IDs prevent duplicates.
- **Onboarding gate** — `RootView` checks `AppSettings.onboardingComplete`; false shows `OnboardingView`, true shows `MainTabView`.

**iOS 26 / Xcode 26 SDK compatibility fixes already applied:**

- `center.notificationSettings()` — no longer async, `await` removed
- `center.removeAllPendingNotificationRequests()` — no longer async
- `center.setNotificationCategories()` — no longer async
- `setBadgeCount` — now uses completion handler: `center.setBadgeCount(n) { _ in }`
- `Color.tertiary` / `Color.quaternary` — require explicit `Color(.tertiaryLabel)` in ternary expressions

**Adding a new Swift file to the project:**

The project uses a manual `project.pbxproj` (no file-system synchronized group). To register a new `.swift` file, edit `MetricPulse/MetricPulse.xcodeproj/project.pbxproj` and add entries in four places using a unique 24-character hex UUID for each:

1. **PBXFileReference section** — declare the file:
   ```
   AABBCCDDEEFF001122334455 /* MyFile.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = MyFile.swift; sourceTree = "<group>"; };
   ```
2. **PBXBuildFile section** — link it to the Sources phase:
   ```
   FFEEDDCCBBAA998877665544 /* MyFile.swift in Sources */ = {isa = PBXBuildFile; fileRef = AABBCCDDEEFF001122334455 /* MyFile.swift */; };
   ```
3. **New Group children array** (group ID `8E41BBA32FCEA97B00EA5AA1`) — add the FileReference UUID.
4. **PBXSourcesBuildPhase files array** (phase ID `8E41BB8E2FCEA82900EA5AA1`) — add the BuildFile UUID.
