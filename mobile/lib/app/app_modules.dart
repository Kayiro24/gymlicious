import 'package:gym_tracker/core/module/feature_module.dart';
import 'package:gym_tracker/features/backup/backup.dart';
import 'package:gym_tracker/features/checkin/checkin.dart';
import 'package:gym_tracker/features/exercises/exercises.dart';
import 'package:gym_tracker/features/history/history.dart';
import 'package:gym_tracker/features/home/home.dart';
import 'package:gym_tracker/features/onboarding/onboarding.dart';
import 'package:gym_tracker/features/profile/profile.dart';
import 'package:gym_tracker/features/quotes/quotes.dart';
import 'package:gym_tracker/features/rewards/rewards.dart';
import 'package:gym_tracker/features/settings/settings.dart';
import 'package:gym_tracker/features/stats/stats.dart';
import 'package:gym_tracker/features/train/train.dart';
import 'package:gym_tracker/features/workouts/workouts.dart';
import 'package:gym_tracker/features/year_dots/year_dots.dart';

/// Every feature plugged into the app. Adding a feature means adding it here.
final appModules = <FeatureModule>[
  workoutsModule,
  checkinModule,
  rewardsModule,
  profileModule,
  settingsModule,
  onboardingModule,
  homeModule,
  trainModule,
  exercisesModule,
  historyModule,
  yearDotsModule,
  statsModule,
  backupModule,
  quotesModule,
];
