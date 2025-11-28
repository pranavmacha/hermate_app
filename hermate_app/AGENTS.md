# HerTrack App – Project Guide

## Purpose and Platform
HerTrack is a Flutter application that helps users track menstrual cycles, predict upcoming periods, and log daily symptoms. The app uses Hive for local persistence and is themed around a friendly pink palette.

## App Entry and Routing
- `lib/main.dart` initializes Hive, opens the `cycleData` box, and launches `MenstrualApp` with Material 3 theming and a seed color of `AppColors.primary`. The initial route is `/onboarding`, and navigation is handled through `AppRoutes.generateRoute` mapping `/onboarding`, `/home`, and `/calendar`.
- Core colors live in `lib/core/constants/colors.dart`, defining primary, accent, background, and text palette constants.

## Persistent Data Model
- Period tracking data is stored in the Hive box `cycleData` under keys:
  - `periodLogs`: list of maps containing `start` and `end` ISO strings for each recorded cycle.
  - `lastPeriodStart` / `lastPeriodEnd`: current or most recent period boundaries.
- Symptom logging data is stored via `SymptomStorage` (`lib/features/calendar/storage/symptom_storage.dart`) using the `symptomLogs` key. Entries are serialized/deserialized through the `SymptomEntry` model, which captures date, mood, flow, cramps level, headache/back pain flags, energy level, sleep hours, and notes.

## Key Screens and Flows
- **Onboarding (`lib/presentation/screens/onboarding/onboarding_screen.dart`)**: Welcomes the user with imagery, descriptive copy, and a “Get Started” button that routes to the home screen.
- **Home Dashboard (`lib/presentation/screens/home/home_screen.dart`)**: Provides two tabs (Home and Learn). The Home tab shows:
  - Cycle summary card with current day, days until next period, phase inference (Menstrual, Follicular, Ovulation, Luteal), and progress visualization.
  - Quick actions to open the calendar or (placeholder) log symptoms.
  - Phase-specific symptom highlights and a wellness checklist tailored to the inferred phase.
  - Preview card linking to the education hub.
- **Calendar (`lib/presentation/screens/calendar/calendar_screen.dart`)**:
  - TableCalendar view with custom decorators for logged period days and predicted upcoming days based on average cycle length.
  - Actions to mark period start/end with validation (prevents overlapping cycles, warns on unusually long durations), reset calendar data, and reset full history.
  - Floating action button opens the Symptom Log screen for the selected date. History and refresh icons open the log history view or clear calendar state.
- **Symptom Log (`lib/features/calendar/screens/symptom_log_screen.dart`)**: Form to record mood, flow, cramps severity, headache/back pain toggles, energy, sleep hours, and optional notes. Saves entries to Hive and confirms with a snackbar.
- **Log History (`lib/presentation/screens/calendar/log_history_screen.dart`)**: Displays recorded cycles with expansion tiles, per-cycle stats (start/end dates, period length, cycle length), and aggregate statistics (averages, shortest/longest, total cycles). Provides a destructive action to delete all history.
- **Education Hub (`lib/presentation/screens/education/education_screen.dart`)**: Tabbed content covering cycle basics, hygiene and relief, eco-friendly products, myths vs facts, and nutrition, with rich textual guidance.

## User Experience Notes
- The UI uses `AppColors` for a cohesive pink theme and sets a `Poppins` font family.
- Snackbars are used throughout for feedback (e.g., save confirmations, validation warnings).
- Many screens employ cards, chips, and sliders to keep inputs approachable and readable.

## Dependencies
Primary runtime dependencies (see `pubspec.yaml`):
- `table_calendar` for calendar visualization.
- `hive` and `hive_flutter` for local data storage.

## Running the App
1. Ensure Flutter and Dart are installed.
2. Fetch packages: `flutter pub get`.
3. Run the app on a simulator or device: `flutter run`.
4. On first launch, Hive boxes are initialized automatically by `main.dart`.
