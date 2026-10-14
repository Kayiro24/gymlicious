// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Gymlicious';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDone => 'Done';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonUndo => 'Undo';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonClose => 'Close';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonOptional => 'Optional';

  @override
  String get commonRequired => 'Required';

  @override
  String get commonLoading => 'Loading';

  @override
  String get commonBodyweight => 'BW';

  @override
  String get commonSaveFailed => 'Couldn\'t save your changes';

  @override
  String get commonSomethingWentWrong =>
      'Something went wrong. Please try again.';

  @override
  String get tabHome => 'Home';

  @override
  String get tabTrain => 'Train';

  @override
  String get unitKg => 'kg';

  @override
  String get unitLb => 'lb';

  @override
  String get unitCm => 'cm';

  @override
  String get unitFt => 'ft';

  @override
  String get unitIn => 'in';

  @override
  String weightWithUnit(String value, String unit) {
    return '$value $unit';
  }

  @override
  String get statLast => 'Last';

  @override
  String get statMax => 'Max';

  @override
  String get statNone => '—';

  @override
  String get setRowWeight => 'Weight';

  @override
  String get setRowReps => 'Reps';

  @override
  String get setRowIncrease => 'Increase weight';

  @override
  String get setRowDecrease => 'Decrease weight';

  @override
  String get setRowWarmup => 'Warm-up';

  @override
  String get setRowMarkDone => 'Mark set done';

  @override
  String get setRowMarkNotDone => 'Mark set not done';

  @override
  String get setRowRemove => 'Remove set';

  @override
  String setRowLabel(int number) {
    return 'Set $number';
  }

  @override
  String get setRowNewMax => 'New max';

  @override
  String get quoteRefresh => 'Show another quote';

  @override
  String get quoteLoading => 'Loading a new quote';

  @override
  String get searchHint => 'Search';

  @override
  String get searchClear => 'Clear search';

  @override
  String get filterTitle => 'Filter';

  @override
  String get filterAll => 'All';

  @override
  String get confirmDefaultCancel => 'Cancel';

  @override
  String get errorStateTitle => 'Something went wrong';

  @override
  String get datePickerChoose => 'Choose a date';

  @override
  String get photoPickerAdd => 'Add photo';

  @override
  String get photoPickerChange => 'Change photo';

  @override
  String get photoPickerRemove => 'Remove photo';

  @override
  String get photoPickerCamera => 'Take a photo';

  @override
  String get photoPickerGallery => 'Choose from gallery';

  @override
  String get photoPickerFailed =>
      'That image couldn\'t be used. Try another one.';

  @override
  String get heightFeet => 'Feet';

  @override
  String get heightInches => 'Inches';

  @override
  String get settingsProfileSubtitle => 'Name, body details and photo';

  @override
  String get settingsUnits => 'Units';

  @override
  String get settingsWeightUnit => 'Weight';

  @override
  String get settingsHeightUnit => 'Height';

  @override
  String get settingsUnitKilograms => 'Kilograms (kg)';

  @override
  String get settingsUnitPounds => 'Pounds (lb)';

  @override
  String get settingsUnitCentimetres => 'Centimetres';

  @override
  String get settingsUnitFeetInches => 'Feet and inches';

  @override
  String get settingsIncrement => 'Weight step';

  @override
  String get settingsIncrementHint =>
      'How much the + and − buttons change a set';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsQuotes => 'Quotes';

  @override
  String get settingsQuoteGym => 'Gym';

  @override
  String get settingsQuoteAnime => 'Anime';

  @override
  String get settingsQuoteMix => 'Mix';

  @override
  String get settingsQuoteOff => 'Off';

  @override
  String get settingsQuoteHint =>
      'Anime and Mix fetch extra quotes online when you\'re connected. Nothing about you is sent.';

  @override
  String get settingsData => 'Your data';

  @override
  String get settingsBackup => 'Backup & restore';

  @override
  String get settingsYearDotsWallpaper => 'Year Dots wallpaper';

  @override
  String get settingsAboutSection => 'About';

  @override
  String get settingsAbout => 'About Gymlicious';

  @override
  String get settingsPrivacy => 'Privacy';

  @override
  String get settingsLicenses => 'Open-source licences';

  @override
  String get settingsDangerZone => 'Danger zone';

  @override
  String get settingsReset => 'Reset all data';

  @override
  String get settingsResetSubtitle => 'Erase everything on this device';

  @override
  String aboutVersion(String version) {
    return 'Version $version';
  }

  @override
  String get aboutBody =>
      'A private workout tracker. Your data stays on this device unless you save or share a backup.';

  @override
  String get aboutMedical =>
      'Gymlicious is not a medical app and does not give medical advice.';

  @override
  String get aboutCredits => 'Quote credits';

  @override
  String get aboutAnimeChanCredit =>
      'Anime quotes provided by AnimeChan (animechan.io). Quotes belong to their respective owners.';

  @override
  String get aboutFontCredit =>
      'Plus Jakarta Sans by Tokotype, under the SIL Open Font License.';

  @override
  String get privacyTitle => 'Privacy';

  @override
  String get privacyNoAccounts =>
      'No accounts. There is no sign-up and no login.';

  @override
  String get privacyOnDevice =>
      'Everything you enter stays in a file on this device. We never receive it.';

  @override
  String get privacyQuotes =>
      'When quotes are set to Anime or Mix, the app asks AnimeChan for quotes. AnimeChan sees your device\'s IP address, as any website would. No personal data or identifiers are sent.';

  @override
  String get privacyBackups =>
      'Backups are plain JSON files that you save or share yourself. Anyone with the file can read it, so keep it somewhere safe.';

  @override
  String get privacyDeviceBackup =>
      'Your phone\'s own device backup (Android backup or iCloud) may include the app\'s data. That backup is managed by your phone, not by us.';

  @override
  String get privacyAnalytics =>
      'No analytics, no ads and no crash reporting that uploads data.';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileUnitsLabel => 'Units';

  @override
  String get profileUnitsMetric => 'kg · cm';

  @override
  String get profileUnitsImperial => 'lb · ft/in';

  @override
  String get profileName => 'Name';

  @override
  String get profileGender => 'Gender';

  @override
  String get profileGenderMale => 'Male';

  @override
  String get profileGenderFemale => 'Female';

  @override
  String get profileGenderOther => 'Other';

  @override
  String get profileGenderPreferNot => 'Prefer not to say';

  @override
  String get profileWeight => 'Body weight';

  @override
  String get profileHeight => 'Height';

  @override
  String get profileDateOfBirth => 'Date of birth';

  @override
  String get profileAge => 'Age';

  @override
  String get profileUseAge => 'I\'d rather enter my age';

  @override
  String get profileUseDateOfBirth => 'Enter my date of birth instead';

  @override
  String profileAgeIs(int age) {
    return 'Age: $age';
  }

  @override
  String profileBmi(String value) {
    return 'Body mass index: $value';
  }

  @override
  String get profileBmiNote =>
      'BMI is a rough guide and doesn\'t account for muscle.';

  @override
  String get profileErrorRequired => 'Please fill this in';

  @override
  String get profileErrorNameTooLong => 'Use 40 characters or fewer';

  @override
  String get profileErrorInvalidNumber => 'Enter a number';

  @override
  String profileErrorWeightRange(String min, String max, String unit) {
    return 'Enter between $min and $max $unit';
  }

  @override
  String get profileErrorHeightRangeCm => 'Enter between 90 and 250 cm';

  @override
  String get profileErrorHeightRangeImperial =>
      'Enter between 2 ft 11 in and 8 ft 2 in';

  @override
  String get profileErrorHeightInches => 'Inches must be from 0 to 11.5';

  @override
  String get profileErrorFutureDate => 'That date is in the future';

  @override
  String get profileErrorAgeRange => 'You need to be between 13 and 100';

  @override
  String get profileSave => 'Save changes';

  @override
  String get profileSaved => 'Profile saved';

  @override
  String get profilePhotoFailed => 'Couldn\'t save the photo. Try another one.';

  @override
  String get backupTitle => 'Backup & restore';

  @override
  String get backupLastNever => 'Last backup: never';

  @override
  String backupLastAt(String when) {
    return 'Last backup: $when';
  }

  @override
  String backupDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: 'yesterday',
      zero: 'today',
    );
    return '$_temp0';
  }

  @override
  String get backupOldWarning =>
      'It\'s been a while. Save a fresh copy so a lost phone doesn\'t mean lost progress.';

  @override
  String get backupSave => 'Save backup to device';

  @override
  String get backupShare => 'Share backup';

  @override
  String get backupWhatsApp => 'Send on WhatsApp';

  @override
  String get backupWhatsAppTip =>
      'Tip: send it to yourself in WhatsApp to keep a copy.';

  @override
  String get backupRestore => 'Restore from backup';

  @override
  String get backupUndoRestore => 'Undo last restore';

  @override
  String get backupUndoRestoreHint =>
      'Brings back the data you had just before your last restore.';

  @override
  String get backupWorking => 'Preparing your backup…';

  @override
  String get backupSaved => 'Backup saved';

  @override
  String get backupShared => 'Backup ready to share';

  @override
  String get backupFailed => 'Couldn\'t create the backup. Please try again.';

  @override
  String get backupCancelled => 'Nothing was saved.';

  @override
  String get backupWhatsAppMissing =>
      'WhatsApp isn\'t installed, so here\'s the share sheet instead.';

  @override
  String get backupWhatsAppHelp =>
      'To restore from WhatsApp: download the file in WhatsApp, then pick it here. On iPhone, tap \"Save to Files\" first.';

  @override
  String get backupInfoTitle => 'Where is my data?';

  @override
  String get backupInfoBody =>
      'Everything lives in a file on this phone. If you uninstall the app or lose the phone, your data is gone unless you\'ve saved or shared a backup file. Saving one takes a few seconds.';

  @override
  String get backupInfoLink => 'What happens if I uninstall?';

  @override
  String get backupReminderToggle => 'Weekly backup reminder';

  @override
  String get backupReminderToggleHint => 'A gentle notification once a week.';

  @override
  String get backupBannerToggle => 'Remind me in the app';

  @override
  String get backupNotificationDenied =>
      'Notifications are turned off for Gymlicious in your phone\'s settings.';

  @override
  String get backupNotificationTitle => 'Time for a backup?';

  @override
  String get backupNotificationBody =>
      'Save or share a copy of your workouts so they\'re safe.';

  @override
  String get backupNotificationChannel => 'Backup reminders';

  @override
  String get backupBannerText =>
      'Your workouts only live on this phone. Save a backup?';

  @override
  String get backupBannerAction => 'Back up';

  @override
  String get backupBannerDismiss => 'Not now';

  @override
  String get restoreTitle => 'Restore this backup?';

  @override
  String get restorePreviewName => 'Name';

  @override
  String get restorePreviewExercises => 'Exercises';

  @override
  String get restorePreviewSessions => 'Workouts';

  @override
  String get restorePreviewDate => 'Backed up';

  @override
  String get restorePreviewPhoto => 'Profile photo';

  @override
  String get restorePreviewPhotoYes => 'Included';

  @override
  String get restorePreviewPhotoNo => 'Not included';

  @override
  String get restoreWarning =>
      'This replaces everything currently in the app. You can undo it once from Backup & restore.';

  @override
  String get restoreConfirm => 'Restore';

  @override
  String get restoreWorking => 'Restoring your data…';

  @override
  String get restoreDone => 'All restored';

  @override
  String get restoreFailed =>
      'Restore didn\'t finish. Your previous data is still there.';

  @override
  String get restoreNotABackup => 'This file isn\'t a Gymlicious backup.';

  @override
  String get restoreDamaged =>
      'This backup looks damaged, so it can\'t be restored.';

  @override
  String get restoreNewerApp =>
      'This backup is from a newer version. Please update the app first.';

  @override
  String get restoreInvalid =>
      'Some data in this backup isn\'t readable, so it can\'t be restored.';

  @override
  String get undoRestoreDone => 'Your previous data is back';

  @override
  String get resetTitle => 'Reset all data';

  @override
  String get resetIntro =>
      'This erases your profile, exercises, splits, workouts and settings from this phone. It can\'t be undone.';

  @override
  String get resetBackupFirst => 'Save a backup first';

  @override
  String resetTypeToConfirm(String word) {
    return 'Type $word to confirm';
  }

  @override
  String get resetConfirmWord => 'DELETE';

  @override
  String get resetButton => 'Erase everything';

  @override
  String get resetDone => 'All data erased';

  @override
  String get gateRestore => 'Restore from backup';

  @override
  String get gateHeading => 'Welcome to Gymlicious. Let\'s get you set up.';

  @override
  String get gateSubheading =>
      'Everything you enter stays on this device. No account needed.';

  @override
  String get gateContinue => 'Continue';

  @override
  String get gateFixErrors => 'A few details need a look.';

  @override
  String get splitStepTitle => 'Pick a split';

  @override
  String get splitStepSubtitle => 'A starting rotation you can edit any time.';

  @override
  String get splitStepOwn => 'I\'ll create my own';

  @override
  String get splitStepOwnSubtitle => 'Start with an empty split';

  @override
  String splitStepDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get setUpLater => 'Set up later';

  @override
  String get weightsStepTitle => 'Starting weights';

  @override
  String get weightsStepSubtitle =>
      'Optional. Enter your best and most recent weights so your history isn\'t empty on day one.';

  @override
  String get weightsStepMax => 'Best';

  @override
  String get weightsStepLast => 'Last';

  @override
  String get weightsStepSave => 'Save and finish';

  @override
  String get weightsStepInvalid => 'Enter a weight, or leave it empty';

  @override
  String get muscleChest => 'Chest';

  @override
  String get muscleBack => 'Back';

  @override
  String get muscleShoulders => 'Shoulders';

  @override
  String get muscleBiceps => 'Biceps';

  @override
  String get muscleTriceps => 'Triceps';

  @override
  String get muscleForearms => 'Forearms';

  @override
  String get muscleQuads => 'Quads';

  @override
  String get muscleHamstrings => 'Hamstrings';

  @override
  String get muscleGlutes => 'Glutes';

  @override
  String get muscleCalves => 'Calves';

  @override
  String get muscleCore => 'Core';

  @override
  String get muscleFullBody => 'Full body';

  @override
  String get muscleCardio => 'Cardio';

  @override
  String get equipmentBarbell => 'Barbell';

  @override
  String get equipmentDumbbell => 'Dumbbell';

  @override
  String get equipmentMachine => 'Machine';

  @override
  String get equipmentCable => 'Cable';

  @override
  String get equipmentBodyweight => 'Bodyweight';

  @override
  String get equipmentKettlebell => 'Kettlebell';

  @override
  String get equipmentBand => 'Band';

  @override
  String get equipmentOther => 'Other';

  @override
  String get exercisesTitle => 'Exercises';

  @override
  String get exercisesSearchHint => 'Search exercises';

  @override
  String get exercisesFilter => 'Filter by muscle';

  @override
  String get exercisesShowArchived => 'Archived';

  @override
  String get exercisesAdd => 'Add exercise';

  @override
  String get exercisesEmpty =>
      'No exercises match. Try another search or add your own.';

  @override
  String get exercisesNoneSelected => 'Pick an exercise to see its progress.';

  @override
  String get exerciseFormTitle => 'New exercise';

  @override
  String get exerciseEditTitle => 'Edit exercise';

  @override
  String get exerciseName => 'Name';

  @override
  String get exerciseMuscle => 'Muscle group';

  @override
  String get exerciseEquipment => 'Equipment';

  @override
  String get exerciseStartingMax => 'Starting max';

  @override
  String get exerciseStartingMaxHint =>
      'Your best lift before using the app, if you know it.';

  @override
  String get exerciseNameTaken => 'You already have an exercise with this name';

  @override
  String get exerciseNameEmpty => 'Give it a name';

  @override
  String get exerciseNameTooLong => 'Use 60 characters or fewer';

  @override
  String get exerciseSave => 'Save';

  @override
  String exerciseMaxOn(String date) {
    return 'Max · $date';
  }

  @override
  String exerciseLastOn(String date) {
    return 'Last · $date';
  }

  @override
  String get exerciseFromBaseline => 'Starting max';

  @override
  String get exerciseProgress => 'Progress';

  @override
  String get exerciseProgressEmpty =>
      'Log this exercise to see your progress here.';

  @override
  String exerciseChartLabel(int count) {
    return 'Best weight per session, $count sessions';
  }

  @override
  String get exerciseHistory => 'History';

  @override
  String get exerciseHistoryEmpty => 'No sessions yet.';

  @override
  String get exerciseNotes => 'Notes';

  @override
  String get exerciseNotesHint => 'Cues, seat height, grip…';

  @override
  String get exerciseArchive => 'Archive exercise';

  @override
  String get exerciseDelete => 'Delete exercise';

  @override
  String get exerciseUnarchive => 'Restore exercise';

  @override
  String get exerciseArchived => 'Archived. It stays in your history.';

  @override
  String get exerciseDeleted => 'Exercise deleted';

  @override
  String get exerciseArchiveQuestion => 'Archive this exercise?';

  @override
  String get exerciseArchiveExplain =>
      'It has history, so it will be hidden from pickers but kept in your past workouts.';

  @override
  String get exerciseDeleteQuestion => 'Delete this exercise?';

  @override
  String get exerciseDeleteExplain =>
      'It hasn\'t been logged yet, so it will be removed completely.';

  @override
  String exerciseSetSummary(String weight, String reps) {
    return '$weight × $reps';
  }

  @override
  String get exerciseWarmupMark => 'warm-up';

  @override
  String get exerciseNotFound => 'This exercise no longer exists.';

  @override
  String get trainTitle => 'Train';

  @override
  String get trainActiveSplit => 'Active split';

  @override
  String get trainChooseSplit => 'Choose a split';

  @override
  String get trainNoSplits =>
      'No splits yet. Create one, or start a freestyle workout.';

  @override
  String get trainUpNext => 'Up next';

  @override
  String get trainRestDay => 'Rest day';

  @override
  String trainExerciseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count exercises',
      one: '1 exercise',
      zero: 'No exercises',
    );
    return '$_temp0';
  }

  @override
  String get trainFreestyle => 'Freestyle workout';

  @override
  String get trainFreestyleSubtitle => 'Add exercises as you go';

  @override
  String get trainSplits => 'Your splits';

  @override
  String get trainNewSplit => 'New split';

  @override
  String get trainEditSplit => 'Edit';

  @override
  String get trainDraftExists => 'You have a workout in progress';

  @override
  String get trainResume => 'Resume workout';

  @override
  String get trainDiscard => 'Discard';

  @override
  String get trainDiscardQuestion => 'Discard this workout?';

  @override
  String get trainDiscardExplain => 'Sets you logged in it will be lost.';

  @override
  String get splitEditorNewTitle => 'New split';

  @override
  String get splitEditorTitle => 'Edit split';

  @override
  String get splitName => 'Split name';

  @override
  String get splitDefaultName => 'My split';

  @override
  String splitDefaultDay(int number) {
    return 'Day $number';
  }

  @override
  String get splitDays => 'Days';

  @override
  String get splitDayName => 'Day name';

  @override
  String get splitRestDay => 'Rest day';

  @override
  String get splitAddDay => 'Add day';

  @override
  String get splitAddExercise => 'Add exercise';

  @override
  String get splitRemoveDay => 'Remove day';

  @override
  String splitRemoveExercise(String name) {
    return 'Remove $name';
  }

  @override
  String get splitReorderHint => 'Hold and drag to reorder';

  @override
  String get splitMakeActive => 'Make active';

  @override
  String get splitIsActive => 'Active';

  @override
  String get splitDelete => 'Delete split';

  @override
  String get splitDeleteQuestion => 'Delete this split?';

  @override
  String get splitDeleteExplain => 'Your past workouts stay in history.';

  @override
  String get splitSave => 'Save split';

  @override
  String get splitNameRequired => 'Give the split a name';

  @override
  String get pickerTitle => 'Add exercise';

  @override
  String get pickerNewExercise => 'Create a new exercise';

  @override
  String get sessionFreestyle => 'Freestyle';

  @override
  String sessionElapsed(int minutes) {
    return '$minutes min';
  }

  @override
  String get sessionAddSet => 'Add set';

  @override
  String get sessionAddExercise => 'Add exercise';

  @override
  String get sessionFinish => 'Finish';

  @override
  String get sessionDiscard => 'Discard workout';

  @override
  String get sessionExerciseNote => 'Note';

  @override
  String get sessionMoveUp => 'Move up';

  @override
  String get sessionMoveDown => 'Move down';

  @override
  String get sessionRemoveExercise => 'Remove exercise';

  @override
  String get sessionEmpty => 'Add an exercise to start logging.';

  @override
  String sessionLastMax(String last, String max) {
    return 'Last $last · Max $max';
  }

  @override
  String get sessionNewMax => 'New max';

  @override
  String get sessionSetRemoved => 'Set removed';

  @override
  String get sessionFinishNothingDone =>
      'Nothing was marked done, so this workout wasn\'t saved.';

  @override
  String get sessionFinishQuestion => 'Finish workout?';

  @override
  String sessionFinishUndone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sets aren\'t marked done and won\'t be saved.',
      one: '1 set isn\'t marked done and won\'t be saved.',
    );
    return '$_temp0';
  }

  @override
  String get summaryTitle => 'Nice work';

  @override
  String get summaryDuration => 'Duration';

  @override
  String get summaryExercises => 'Exercises';

  @override
  String get summarySets => 'Sets';

  @override
  String get summaryNewMaxes => 'New maxes';

  @override
  String get summaryNoNewMax => 'No new maxes this time. Consistency counts.';

  @override
  String get summaryDone => 'Done';

  @override
  String summaryMinutes(int count) {
    return '$count min';
  }

  @override
  String get sessionNoActive => 'There\'s no workout in progress.';

  @override
  String get historyTitle => 'History';

  @override
  String get historyList => 'List';

  @override
  String get historyCalendar => 'Calendar';

  @override
  String get historyEmpty =>
      'No workouts yet. Your finished sessions will show up here.';

  @override
  String historyThisMonth(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessions this month',
      one: '1 session this month',
      zero: 'No sessions this month',
    );
    return '$_temp0';
  }

  @override
  String historyVolume(String value) {
    return 'Volume: $value';
  }

  @override
  String historySessionSummary(String exercises, String sets) {
    return '$exercises · $sets';
  }

  @override
  String historySetCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sets',
      one: '1 set',
    );
    return '$_temp0';
  }

  @override
  String get historyPreviousMonth => 'Previous month';

  @override
  String get historyNextMonth => 'Next month';

  @override
  String historyTrainedDay(String date) {
    return '$date, trained';
  }

  @override
  String get historyNoSessionsOnDay => 'No workouts on this day.';

  @override
  String get historySelectSession => 'Pick a workout to see the details.';

  @override
  String get sessionDetailTitle => 'Workout';

  @override
  String get sessionDetailDate => 'Date';

  @override
  String get sessionDetailEdit => 'Edit workout';

  @override
  String get sessionDetailDelete => 'Delete workout';

  @override
  String get sessionDetailDeleteQuestion => 'Delete this workout?';

  @override
  String get sessionDetailDeleteExplain =>
      'Max and last weights will be recalculated without it.';

  @override
  String get sessionDetailDeleted => 'Workout deleted';

  @override
  String get sessionDetailSaved => 'Workout updated';

  @override
  String get sessionDetailMissing => 'This workout no longer exists.';

  @override
  String get sessionEditSave => 'Save changes';

  @override
  String homeGreetingMorning(String name) {
    return 'Good morning, $name';
  }

  @override
  String homeGreetingAfternoon(String name) {
    return 'Good afternoon, $name';
  }

  @override
  String homeGreetingEvening(String name) {
    return 'Good evening, $name';
  }

  @override
  String get homeOpenProfile => 'Open profile';

  @override
  String get homeResumeTitle => 'Workout in progress';

  @override
  String homeResumeSubtitle(String day, String time) {
    return '$day · started $time';
  }

  @override
  String get yearTitle => 'Year';

  @override
  String get yearLayoutContinuous => 'Continuous';

  @override
  String get yearLayoutMonths => 'Months';

  @override
  String yearSummaryLine(int day, int total, int left, int percent) {
    return 'Day $day of $total · $left left · $percent%';
  }

  @override
  String yearLeftOnlyLine(int left) {
    return '$left days left';
  }

  @override
  String yearDotTooltip(String date, int day) {
    return '$date · Day $day';
  }

  @override
  String yearDotDone(String date, int day) {
    return '$date, day $day, done';
  }

  @override
  String yearDotToday(String date, int day) {
    return '$date, day $day, today';
  }

  @override
  String yearDotLeft(String date, int day) {
    return '$date, day $day, upcoming';
  }

  @override
  String yearGridSummary(int day, int total, int left) {
    return 'Year progress: day $day of $total, $left days left';
  }

  @override
  String get yearWallpaper => 'Wallpaper';

  @override
  String get wallpaperTitle => 'Year Dots wallpaper';

  @override
  String get wallpaperLayout => 'Layout';

  @override
  String get wallpaperColours => 'Colours';

  @override
  String get wallpaperPresetLight => 'Light';

  @override
  String get wallpaperPresetDark => 'Dark';

  @override
  String get wallpaperPresetBlack => 'Black';

  @override
  String get wallpaperPresetEmber => 'Ember';

  @override
  String get wallpaperTextLine => 'Text';

  @override
  String get wallpaperTextLeftAndPercent => 'Days left + %';

  @override
  String get wallpaperTextLeftOnly => 'Days left';

  @override
  String get wallpaperTextNone => 'None';

  @override
  String wallpaperTopMargin(int percent) {
    return 'Space for the clock: $percent%';
  }

  @override
  String wallpaperPadding(int value) {
    return 'Side padding: $value';
  }

  @override
  String get wallpaperSetLive => 'Set as wallpaper';

  @override
  String get wallpaperSetLiveHint =>
      'Opens your phone\'s wallpaper preview. It updates by itself every day.';

  @override
  String get wallpaperLiveFailed =>
      'Couldn\'t open the wallpaper picker. Save an image instead.';

  @override
  String get wallpaperSaveImage => 'Save wallpaper image';

  @override
  String get wallpaperSaveImageHint =>
      'Saves today\'s picture to Photos. Set it as your wallpaper from there.';

  @override
  String get wallpaperIosNote =>
      'iPhones don\'t allow live wallpapers, so the image shows the day it was made. Save a new one whenever you like.';

  @override
  String get wallpaperSamsungNote =>
      'Some phones limit live wallpapers on the lock screen. If yours does, use a saved image there.';

  @override
  String get wallpaperSaved => 'Saved to Photos';

  @override
  String get wallpaperSaveFailed =>
      'Couldn\'t save the image. Check the app\'s Photos permission.';

  @override
  String get wallpaperWorking => 'Drawing your wallpaper…';

  @override
  String get recoveryTitle => 'We couldn\'t read your data';

  @override
  String get recoveryBody =>
      'Your data file and its automatic copy both appear to be damaged. You can restore from a backup file, or start fresh.';

  @override
  String get recoveryRestore => 'Restore from backup';

  @override
  String get recoveryStartFresh => 'Start fresh';

  @override
  String get recoveryStartFreshQuestion => 'Start fresh?';

  @override
  String get recoveryStartFreshExplain =>
      'This permanently erases the damaged data on this device. Restore from a backup first if you have one.';

  @override
  String get navigationLabel => 'Main navigation';

  @override
  String streakDayLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'day streak',
      one: 'day streak',
    );
    return '$_temp0';
  }

  @override
  String streakSemantics(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count-day streak',
      one: '1-day streak',
      zero: 'No streak yet',
    );
    return '$_temp0';
  }

  @override
  String streakWeeksOnTrack(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count weeks on track',
      one: '1 week on track',
      zero: 'No weeks on track yet',
    );
    return '$_temp0';
  }

  @override
  String streakBest(int count) {
    return 'Best: $count';
  }

  @override
  String weekRingLabel(int done, int goal) {
    return '$done of $goal days';
  }

  @override
  String stepIndicatorLabel(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String xpLevel(int level) {
    return 'Level $level';
  }

  @override
  String xpToNextLevel(int xp, int next) {
    return '$xp XP to level $next';
  }

  @override
  String badgeEarnedOn(String date) {
    return 'Earned $date';
  }

  @override
  String get badgeLocked => 'Not earned yet';

  @override
  String get dayStateDone => 'workout done';

  @override
  String get dayStateNoWorkout => 'no workout';

  @override
  String get dayStateRest => 'rest day';

  @override
  String get dayStatePlanned => 'planned';

  @override
  String get dayStateUpcoming => 'upcoming';

  @override
  String get dayStateToday => 'today';

  @override
  String get celebrationContinue => 'Tap anywhere to continue';

  @override
  String numberChoiceSemantics(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get tabPlan => 'Plan';

  @override
  String get tabStats => 'Stats';

  @override
  String get tabMe => 'Me';

  @override
  String get statusMet => 'On track: this week\'s goal is done';

  @override
  String statusMoreToGo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count more to go this week',
      one: '1 more to go this week',
    );
    return '$_temp0';
  }

  @override
  String get statusLastChanceToday => 'Last chance today';

  @override
  String get statusTrainToday => 'Train today to stay on track';

  @override
  String get statusFreshStartToday => 'Fresh start today';

  @override
  String statusNewStreak(int count) {
    return 'New streak: day $count';
  }

  @override
  String get todayTitle => 'Today';

  @override
  String get todayQuestion => 'Did you work out today?';

  @override
  String get todayCheckIn => 'I worked out today';

  @override
  String get todayDone => 'Done. Nice work!';

  @override
  String get todayUndo => 'Undo';

  @override
  String get todayAddDetails => 'Add note or time';

  @override
  String todayStartWorkout(String day) {
    return 'Start workout: $day';
  }

  @override
  String get todayRestDay =>
      'Sunday is your rest day. Trained anyway? It counts as a bonus.';

  @override
  String todayPlanned(String note) {
    return 'Planned: $note';
  }

  @override
  String dayLabel(String date, String state) {
    return '$date, $state';
  }

  @override
  String get daySheetDone => 'Worked out';

  @override
  String get daySheetDoneHint => 'Turn on if you trained this day';

  @override
  String get daySheetFutureHint => 'You can tick this off on the day.';

  @override
  String get daySheetNote => 'Note';

  @override
  String get daySheetNoteHint => 'e.g. Chest + triceps';

  @override
  String get daySheetTime => 'Time';

  @override
  String get daySheetPlannedTime => 'Planned time';

  @override
  String get daySheetAddTime => 'Add time';

  @override
  String get daySheetClearTime => 'Clear time';

  @override
  String get daySheetDuration => 'Duration';

  @override
  String daySheetMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get daySheetNoDuration => 'None';

  @override
  String daySheetSessionLogged(String time) {
    return 'Workout logged at $time';
  }

  @override
  String get daySheetViewWorkout => 'View workout';

  @override
  String get daySheetSave => 'Save';

  @override
  String get planTitle => 'Plan';

  @override
  String get planPreviousWeek => 'Previous week';

  @override
  String get planNextWeek => 'Next week';

  @override
  String get planPreviousMonth => 'Previous month';

  @override
  String get planNextMonth => 'Next month';

  @override
  String get planThisWeek => 'This week';

  @override
  String get planLegendDone => 'Done';

  @override
  String get planLegendNoWorkout => 'No workout';

  @override
  String get planLegendRest => 'Rest day';

  @override
  String get planLegendPlanned => 'Planned';

  @override
  String get planLegendUpcoming => 'Upcoming';

  @override
  String get planHint => 'Tap any day to tick it off or plan it.';

  @override
  String get homeNextBadge => 'Next badge';

  @override
  String get homeAllBadges => 'Every badge earned. Legendary!';

  @override
  String get statsTitle => 'Stats';

  @override
  String get statsCurrentStreak => 'Current streak';

  @override
  String get statsBestStreak => 'Best streak';

  @override
  String get statsTotalWorkouts => 'Total workouts';

  @override
  String get statsWeeksOnTrack => 'Weeks on track';

  @override
  String get statsThisWeek => 'This week';

  @override
  String get statsThisMonth => 'This month';

  @override
  String statsWorkoutCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count workouts',
      one: '1 workout',
    );
    return '$_temp0';
  }

  @override
  String get statsConsistency => 'Consistency';

  @override
  String statsConsistencyHelp(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Weeks that met your goal, out of your last $count.',
      one: 'Your last week, measured against your goal.',
    );
    return '$_temp0';
  }

  @override
  String get statsLastWeeks => 'Last 8 weeks';

  @override
  String get statsLastWeeksHelp => 'Workouts each week. The line is your goal.';

  @override
  String get statsTimeOfDay => 'When you train';

  @override
  String get statsTimeOfDayEmpty =>
      'Add a time to your check-ins to see when you usually train.';

  @override
  String get statsMorning => 'Morning';

  @override
  String get statsAfternoon => 'Afternoon';

  @override
  String get statsEvening => 'Evening';

  @override
  String get statsNight => 'Night';

  @override
  String statsTypicalTime(String period) {
    return 'Usually: $period';
  }

  @override
  String get statsEmpty =>
      'Your stats grow with every workout. Tick off today to start.';

  @override
  String get statsBadges => 'Badges';

  @override
  String get statsSeeAllBadges => 'See all badges';

  @override
  String get statsYourYear => 'Your year';

  @override
  String get statsYourYearHelp => 'The whole year, one dot per day.';

  @override
  String get statsPersonalRecords => 'Personal records';

  @override
  String get badgeFirstWorkout => 'First workout';

  @override
  String badgeStreak(int count) {
    return '$count-day streak';
  }

  @override
  String get badgeFirstPr => 'First personal record';

  @override
  String get badgeFirstFullWeek => 'First full week';

  @override
  String badgeWorkouts(int count) {
    return '$count workouts';
  }

  @override
  String badgeProgress(int current, int total) {
    return '$current of $total';
  }

  @override
  String badgeNextWorkouts(int count, String badge) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count more workouts to earn $badge',
      one: '1 more workout to earn $badge',
    );
    return '$_temp0';
  }

  @override
  String badgeNextStreak(int count, String badge) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count more streak days to earn $badge',
      one: '1 more streak day to earn $badge',
    );
    return '$_temp0';
  }

  @override
  String badgeNextPr(String badge) {
    return 'Beat one of your best lifts to earn $badge';
  }

  @override
  String badgeNextWeek(String badge) {
    return 'Meet your weekly goal to earn $badge';
  }

  @override
  String get badgesTitle => 'Badges';

  @override
  String celebrateCheckIn(int count) {
    return 'Day $count!';
  }

  @override
  String celebrateLevelUp(int level) {
    return 'Level $level!';
  }

  @override
  String get celebrateLevelUpMessage => 'You\'re getting stronger.';

  @override
  String celebrateBadge(String badge) {
    return 'Badge earned: $badge';
  }

  @override
  String get celebratePr => 'New personal record!';

  @override
  String get celebratePrMessage => 'That\'s a new best. Well done.';

  @override
  String get celebrateWeekGoal => 'Week goal met!';

  @override
  String get goalStepTitle => 'How many days a week do you want to train?';

  @override
  String get goalStepBody =>
      'Pick a goal you can keep. Sunday is your rest day, and a Sunday workout counts as a bonus.';

  @override
  String goalDaysPerWeek(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days a week',
      one: '1 day a week',
    );
    return '$_temp0';
  }

  @override
  String allSetTitle(String name) {
    return 'You\'re all set, $name!';
  }

  @override
  String get allSetBody => 'Tick off each workout and watch your streak grow.';

  @override
  String get allSetGo => 'Let\'s go';

  @override
  String get meTitle => 'Me';

  @override
  String get meEditProfile => 'Edit profile';

  @override
  String get meTraining => 'Training';

  @override
  String get meGymDays => 'Gym days per week';

  @override
  String get meGymDaysHelp =>
      'Applies from this week. Sunday is your rest day.';

  @override
  String get meReminder => 'Daily reminder';

  @override
  String get meReminderHelp =>
      'A gentle note on Monday to Saturday if you haven\'t checked in yet. Off by default.';

  @override
  String get meReminderTime => 'Reminder time';

  @override
  String get meReminderDenied =>
      'Notifications are off for Gymlicious. You can turn them on in system settings.';

  @override
  String get reminderTitle => 'Ready for today?';

  @override
  String get reminderBody => 'Tap to check in or plan your workout.';

  @override
  String get reminderChannel => 'Daily reminder';

  @override
  String get trainExercises => 'Exercises';

  @override
  String get trainPastWorkouts => 'Past workouts';

  @override
  String get trainLastWorkout => 'Last workout';

  @override
  String get quoteNew => 'New quote';
}
