# TickSnap - iOS Development Guide

## Executive Summary

TickSnap is a minimalist countdown timer app designed for iOS 17+ that solves the core pain points of existing timer apps: over-complexity, unreliable background notifications, intrusive ads, and excessive subscription pricing. The app provides one-tap preset timers, multi-timer support, auto-repeat functionality, reliable background/lock screen alerts, Live Activity integration, and home screen widgets — all completely free with zero ads and zero subscriptions.

**Target Audience**: US market users who need a simple, reliable daily countdown timer for cooking, exercise, rest intervals, and focus sessions.

**Key Differentiators**:
- One-tap preset launch (Tea 3min, Egg 6min, Rest 1min, etc.)
- Completely free with zero ads, zero subscriptions, zero IAP
- Reliable background and lock screen notifications
- Auto-repeat for cooking/exercise intervals
- Live Activity + Dynamic Island support
- Multiple simultaneous timers

## Competitive Analysis

| App | Strengths | Weaknesses | Our Advantage |
|-----|-----------|------------|---------------|
| Countdown (Find Appiness) | 4.7 rating, 8.9K ratings, free, iCloud sync | Widget requires IAP, focused on event countdowns not daily timers, ads in free version | TickSnap focuses on quick daily timers, not event countdowns; zero ads without paywall |
| Countdown: Event Countdown (ROOT38) | 4.7 rating, 22.5K ratings, 450 icons, widgets | Premium subscription required for ad-free, widgets, sync; complex UI | TickSnap is completely free with all features; simpler, faster UI |
| Timer+ | Multi-mode (countdown, stopwatch, interval, date), Apple Watch, 31 sounds | Feature overload for simple use cases; complex UI | TickSnap is dead simple — one tap to start; no learning curve |
| Countdowns: Track Every Moment | 4.4 rating, no ads, widgets | Pro subscription required for unlimited countdowns and widgets beyond 1 month | TickSnap has no paywall; all features free |
| iOS Native Timer | Free, built-in | iOS 17 redesign made it harder to use; timers pile up; no presets; no multi-timer | TickSnap provides presets, multi-timer, auto-repeat, and clean management |

## Apple Design Guidelines Compliance

- **HIG Timer Patterns**: Use circular progress indicator for countdown visualization; provide clear start/pause/reset controls
- **Notifications**: Use UserNotifications framework for reliable background alerts; respect Do Not Disturb
- **Live Activity**: Follow ActivityKit guidelines for Dynamic Island and Lock Screen presentations
- **Widgets**: Use WidgetKit with accessoryCircular and accessoryRectangular families for home screen
- **Haptics**: Use UIImpactFeedbackGenerator for timer start/completion feedback
- **Accessibility**: Support VoiceOver with meaningful labels; use Dynamic Type for timer display
- **Dark Mode**: Full support with system color adaptation
- **Privacy**: No data collection; all data stored locally on device

## Technical Architecture

- **Language**: Swift 5.9+
- **Framework**: SwiftUI (primary)
- **State Management**: @Observable (iOS 17 Observation framework)
- **Concurrency**: Task + async/await for timer engine
- **Data Persistence**: SwiftData for presets; @AppStorage for settings
- **Notifications**: UserNotifications framework (UNUserNotificationCenter)
- **Audio**: AudioToolbox for system sounds; AVFoundation for custom sounds
- **Live Activity**: ActivityKit for Dynamic Island + Lock Screen
- **Widgets**: WidgetKit for home screen accessories
- **Architecture Pattern**: MVVM with @Observable

## Module Structure

```
TickSnap/
├── TickSnapApp.swift
├── Models/
│   ├── TimerEngine.swift
│   ├── TimerPreset.swift
│   └── SystemSounds.swift
├── Managers/
│   ├── TimerManager.swift
│   ├── NotificationManager.swift
│   └── LiveActivityManager.swift
├── Views/
│   ├── ContentView.swift
│   ├── PresetGridView.swift
│   ├── TimerCardView.swift
│   ├── CircularProgressView.swift
│   ├── NewTimerSheet.swift
│   ├── SettingsView.swift
│   └── ContactSupportView.swift
├── Components/
│   ├── ClockView.swift
│   ├── CircleButton.swift
│   ├── ControlBar.swift
│   └── TimerBackdrop.swift
├── Widget/
│   ├── TimerWidget.swift
│   └── TimerWidgetBundle.swift
├── LiveActivity/
│   └── TimerAttributes.swift
└── Assets.xcassets/
```

## Implementation Flow

1. Create Xcode project with iOS 17.0 deployment target, SwiftUI lifecycle
2. Implement TimerEngine with @Observable, Task-based async/await countdown
3. Implement TimerPreset model with SwiftData @Model
4. Implement TimerManager for multi-timer coordination
5. Build ContentView with preset grid and active timer list
6. Build CircularProgressView with AngularGradient animation
7. Build TimerCardView for individual timer display and controls
8. Build NewTimerSheet for custom timer creation
9. Implement NotificationManager with UNUserNotificationCenter
10. Implement LiveActivityManager with ActivityKit
11. Build Widget with WidgetKit (accessoryCircular + accessoryRectangular)
12. Build SettingsView with sound selection, contact support, policy links
13. Build ContactSupportView with feedback form
14. Polish UI animations, haptics, and transitions
15. Test on iPhone and iPad simulators

## UI/UX Design Specifications

- **Color Scheme**: 
  - Primary: System Orange (#FF9500) — energy, warmth, time association
  - Secondary: System Cyan (#5AC8FA) — progress bar gradient
  - Success: System Green (#34C759) — timer completion
  - Background: System background (adaptive light/dark)
- **Typography**: SF Pro Rounded (system default); monospacedDigit() for timer display
- **Layout**: 
  - Preset grid: 2-column LazyVGrid with 16pt corner radius cards
  - Timer cards: horizontal scroll with swipe-to-delete
  - iPad: max width 720pt for content areas
- **Animations**: 
  - Progress: smooth animation(duration: 0.35)
  - Completion: spring animation + scale effect
  - Transitions: slide and fade for timer list changes
- **Haptics**: 
  - Timer start: UIImpactFeedbackGenerator(.medium)
  - Timer complete: UINotificationFeedbackGenerator(.success)
- **Icon Style**: SF Symbols filled variants throughout

## Code Generation Rules

- Use @Observable macro for all view models (iOS 17 Observation framework)
- All UI updates must run on @MainActor
- Timer engine uses Task + async/await (not Timer.publish)
- SwiftData @Model for persistent data; @AppStorage for simple settings
- Schedule UNUserNotification when timer starts; cancel on pause/reset
- Live Activity starts with active timer; ends immediately on completion
- Widget uses App Group for data sharing
- No comments in code unless explicitly requested
- Single responsibility per module; high cohesion, low coupling
- Follow "Rule of Three" for code abstraction

## Build & Deployment Checklist

- [ ] Xcode project created with iOS 17.0 minimum deployment
- [ ] Bundle ID set to com.zzoutuo.TickSnap
- [ ] App icon generated and configured in Asset Catalog
- [ ] All Swift files compile without errors
- [ ] Build succeeds on iPhone simulator (iPhone XS Max)
- [ ] Build succeeds on iPad simulator (iPad Pro 13-inch M4)
- [ ] App launches and core features work on both simulators
- [ ] No secrets or API keys in source code
- [ ] .gitignore configured properly
- [ ] Code pushed to GitHub repository
- [ ] Policy pages deployed to GitHub Pages
- [ ] App Store metadata prepared (keytext.md)
