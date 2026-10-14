# Checkin

The daily "Did you work out today?" check-in: one entry per date (done, note, time, duration), the weekly goal history, and the streak rules (`WeeklyStreakCalculator`, plan section 4). Owns the Plan tab, the Today card and the day sheet. Days with a logged session count automatically unless the user chose otherwise (D49).

Public API: `checkin.dart`. Module: `checkin_module.dart`.

Tests:
```sh
flutter test test/features/checkin test/app/check_in_flow_test.dart
```
