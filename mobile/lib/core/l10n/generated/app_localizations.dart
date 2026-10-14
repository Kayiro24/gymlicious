import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Gymlicious'**
  String get appTitle;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get commonUndo;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get commonOptional;

  /// No description provided for @commonRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get commonRequired;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get commonLoading;

  /// No description provided for @commonBodyweight.
  ///
  /// In en, this message translates to:
  /// **'BW'**
  String get commonBodyweight;

  /// No description provided for @commonSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save your changes'**
  String get commonSaveFailed;

  /// No description provided for @commonSomethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get commonSomethingWentWrong;

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabTrain.
  ///
  /// In en, this message translates to:
  /// **'Train'**
  String get tabTrain;

  /// No description provided for @unitKg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get unitKg;

  /// No description provided for @unitLb.
  ///
  /// In en, this message translates to:
  /// **'lb'**
  String get unitLb;

  /// No description provided for @unitCm.
  ///
  /// In en, this message translates to:
  /// **'cm'**
  String get unitCm;

  /// No description provided for @unitFt.
  ///
  /// In en, this message translates to:
  /// **'ft'**
  String get unitFt;

  /// No description provided for @unitIn.
  ///
  /// In en, this message translates to:
  /// **'in'**
  String get unitIn;

  /// No description provided for @weightWithUnit.
  ///
  /// In en, this message translates to:
  /// **'{value} {unit}'**
  String weightWithUnit(String value, String unit);

  /// No description provided for @statLast.
  ///
  /// In en, this message translates to:
  /// **'Last'**
  String get statLast;

  /// No description provided for @statMax.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get statMax;

  /// No description provided for @statNone.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get statNone;

  /// No description provided for @setRowWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get setRowWeight;

  /// No description provided for @setRowReps.
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get setRowReps;

  /// No description provided for @setRowIncrease.
  ///
  /// In en, this message translates to:
  /// **'Increase weight'**
  String get setRowIncrease;

  /// No description provided for @setRowDecrease.
  ///
  /// In en, this message translates to:
  /// **'Decrease weight'**
  String get setRowDecrease;

  /// No description provided for @setRowWarmup.
  ///
  /// In en, this message translates to:
  /// **'Warm-up'**
  String get setRowWarmup;

  /// No description provided for @setRowMarkDone.
  ///
  /// In en, this message translates to:
  /// **'Mark set done'**
  String get setRowMarkDone;

  /// No description provided for @setRowMarkNotDone.
  ///
  /// In en, this message translates to:
  /// **'Mark set not done'**
  String get setRowMarkNotDone;

  /// No description provided for @setRowRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove set'**
  String get setRowRemove;

  /// No description provided for @setRowLabel.
  ///
  /// In en, this message translates to:
  /// **'Set {number}'**
  String setRowLabel(int number);

  /// No description provided for @setRowNewMax.
  ///
  /// In en, this message translates to:
  /// **'New max'**
  String get setRowNewMax;

  /// No description provided for @quoteRefresh.
  ///
  /// In en, this message translates to:
  /// **'Show another quote'**
  String get quoteRefresh;

  /// No description provided for @quoteLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading a new quote'**
  String get quoteLoading;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchHint;

  /// No description provided for @searchClear.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get searchClear;

  /// No description provided for @filterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filterTitle;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @confirmDefaultCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get confirmDefaultCancel;

  /// No description provided for @errorStateTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorStateTitle;

  /// No description provided for @datePickerChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose a date'**
  String get datePickerChoose;

  /// No description provided for @photoPickerAdd.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get photoPickerAdd;

  /// No description provided for @photoPickerChange.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get photoPickerChange;

  /// No description provided for @photoPickerRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get photoPickerRemove;

  /// No description provided for @photoPickerCamera.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get photoPickerCamera;

  /// No description provided for @photoPickerGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get photoPickerGallery;

  /// No description provided for @photoPickerFailed.
  ///
  /// In en, this message translates to:
  /// **'That image couldn\'t be used. Try another one.'**
  String get photoPickerFailed;

  /// No description provided for @heightFeet.
  ///
  /// In en, this message translates to:
  /// **'Feet'**
  String get heightFeet;

  /// No description provided for @heightInches.
  ///
  /// In en, this message translates to:
  /// **'Inches'**
  String get heightInches;

  /// No description provided for @settingsProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Name, body details and photo'**
  String get settingsProfileSubtitle;

  /// No description provided for @settingsUnits.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get settingsUnits;

  /// No description provided for @settingsWeightUnit.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get settingsWeightUnit;

  /// No description provided for @settingsHeightUnit.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get settingsHeightUnit;

  /// No description provided for @settingsUnitKilograms.
  ///
  /// In en, this message translates to:
  /// **'Kilograms (kg)'**
  String get settingsUnitKilograms;

  /// No description provided for @settingsUnitPounds.
  ///
  /// In en, this message translates to:
  /// **'Pounds (lb)'**
  String get settingsUnitPounds;

  /// No description provided for @settingsUnitCentimetres.
  ///
  /// In en, this message translates to:
  /// **'Centimetres'**
  String get settingsUnitCentimetres;

  /// No description provided for @settingsUnitFeetInches.
  ///
  /// In en, this message translates to:
  /// **'Feet and inches'**
  String get settingsUnitFeetInches;

  /// No description provided for @settingsIncrement.
  ///
  /// In en, this message translates to:
  /// **'Weight step'**
  String get settingsIncrement;

  /// No description provided for @settingsIncrementHint.
  ///
  /// In en, this message translates to:
  /// **'How much the + and − buttons change a set'**
  String get settingsIncrementHint;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsQuotes.
  ///
  /// In en, this message translates to:
  /// **'Quotes'**
  String get settingsQuotes;

  /// No description provided for @settingsQuoteGym.
  ///
  /// In en, this message translates to:
  /// **'Gym'**
  String get settingsQuoteGym;

  /// No description provided for @settingsQuoteAnime.
  ///
  /// In en, this message translates to:
  /// **'Anime'**
  String get settingsQuoteAnime;

  /// No description provided for @settingsQuoteMix.
  ///
  /// In en, this message translates to:
  /// **'Mix'**
  String get settingsQuoteMix;

  /// No description provided for @settingsQuoteOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get settingsQuoteOff;

  /// No description provided for @settingsQuoteHint.
  ///
  /// In en, this message translates to:
  /// **'Anime and Mix fetch extra quotes online when you\'re connected. Nothing about you is sent.'**
  String get settingsQuoteHint;

  /// No description provided for @settingsData.
  ///
  /// In en, this message translates to:
  /// **'Your data'**
  String get settingsData;

  /// No description provided for @settingsBackup.
  ///
  /// In en, this message translates to:
  /// **'Backup & restore'**
  String get settingsBackup;

  /// No description provided for @settingsYearDotsWallpaper.
  ///
  /// In en, this message translates to:
  /// **'Year Dots wallpaper'**
  String get settingsYearDotsWallpaper;

  /// No description provided for @settingsAboutSection.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAboutSection;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About Gymlicious'**
  String get settingsAbout;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settingsPrivacy;

  /// No description provided for @settingsLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open-source licences'**
  String get settingsLicenses;

  /// No description provided for @settingsDangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger zone'**
  String get settingsDangerZone;

  /// No description provided for @settingsReset.
  ///
  /// In en, this message translates to:
  /// **'Reset all data'**
  String get settingsReset;

  /// No description provided for @settingsResetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Erase everything on this device'**
  String get settingsResetSubtitle;

  /// No description provided for @aboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String aboutVersion(String version);

  /// No description provided for @aboutBody.
  ///
  /// In en, this message translates to:
  /// **'A private workout tracker. Your data stays on this device unless you save or share a backup.'**
  String get aboutBody;

  /// No description provided for @aboutMedical.
  ///
  /// In en, this message translates to:
  /// **'Gymlicious is not a medical app and does not give medical advice.'**
  String get aboutMedical;

  /// No description provided for @aboutCredits.
  ///
  /// In en, this message translates to:
  /// **'Quote credits'**
  String get aboutCredits;

  /// No description provided for @aboutAnimeChanCredit.
  ///
  /// In en, this message translates to:
  /// **'Anime quotes provided by AnimeChan (animechan.io). Quotes belong to their respective owners.'**
  String get aboutAnimeChanCredit;

  /// No description provided for @aboutFontCredit.
  ///
  /// In en, this message translates to:
  /// **'Plus Jakarta Sans by Tokotype, under the SIL Open Font License.'**
  String get aboutFontCredit;

  /// No description provided for @privacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacyTitle;

  /// No description provided for @privacyNoAccounts.
  ///
  /// In en, this message translates to:
  /// **'No accounts. There is no sign-up and no login.'**
  String get privacyNoAccounts;

  /// No description provided for @privacyOnDevice.
  ///
  /// In en, this message translates to:
  /// **'Everything you enter stays in a file on this device. We never receive it.'**
  String get privacyOnDevice;

  /// No description provided for @privacyQuotes.
  ///
  /// In en, this message translates to:
  /// **'When quotes are set to Anime or Mix, the app asks AnimeChan for quotes. AnimeChan sees your device\'s IP address, as any website would. No personal data or identifiers are sent.'**
  String get privacyQuotes;

  /// No description provided for @privacyBackups.
  ///
  /// In en, this message translates to:
  /// **'Backups are plain JSON files that you save or share yourself. Anyone with the file can read it, so keep it somewhere safe.'**
  String get privacyBackups;

  /// No description provided for @privacyDeviceBackup.
  ///
  /// In en, this message translates to:
  /// **'Your phone\'s own device backup (Android backup or iCloud) may include the app\'s data. That backup is managed by your phone, not by us.'**
  String get privacyDeviceBackup;

  /// No description provided for @privacyAnalytics.
  ///
  /// In en, this message translates to:
  /// **'No analytics, no ads and no crash reporting that uploads data.'**
  String get privacyAnalytics;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileUnitsLabel.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get profileUnitsLabel;

  /// No description provided for @profileUnitsMetric.
  ///
  /// In en, this message translates to:
  /// **'kg · cm'**
  String get profileUnitsMetric;

  /// No description provided for @profileUnitsImperial.
  ///
  /// In en, this message translates to:
  /// **'lb · ft/in'**
  String get profileUnitsImperial;

  /// No description provided for @profileName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get profileName;

  /// No description provided for @profileGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get profileGender;

  /// No description provided for @profileGenderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get profileGenderMale;

  /// No description provided for @profileGenderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get profileGenderFemale;

  /// No description provided for @profileGenderOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get profileGenderOther;

  /// No description provided for @profileGenderPreferNot.
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get profileGenderPreferNot;

  /// No description provided for @profileWeight.
  ///
  /// In en, this message translates to:
  /// **'Body weight'**
  String get profileWeight;

  /// No description provided for @profileHeight.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get profileHeight;

  /// No description provided for @profileDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get profileDateOfBirth;

  /// No description provided for @profileAge.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get profileAge;

  /// No description provided for @profileUseAge.
  ///
  /// In en, this message translates to:
  /// **'I\'d rather enter my age'**
  String get profileUseAge;

  /// No description provided for @profileUseDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Enter my date of birth instead'**
  String get profileUseDateOfBirth;

  /// No description provided for @profileAgeIs.
  ///
  /// In en, this message translates to:
  /// **'Age: {age}'**
  String profileAgeIs(int age);

  /// No description provided for @profileBmi.
  ///
  /// In en, this message translates to:
  /// **'Body mass index: {value}'**
  String profileBmi(String value);

  /// No description provided for @profileBmiNote.
  ///
  /// In en, this message translates to:
  /// **'BMI is a rough guide and doesn\'t account for muscle.'**
  String get profileBmiNote;

  /// No description provided for @profileErrorRequired.
  ///
  /// In en, this message translates to:
  /// **'Please fill this in'**
  String get profileErrorRequired;

  /// No description provided for @profileErrorNameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Use 40 characters or fewer'**
  String get profileErrorNameTooLong;

  /// No description provided for @profileErrorInvalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a number'**
  String get profileErrorInvalidNumber;

  /// No description provided for @profileErrorWeightRange.
  ///
  /// In en, this message translates to:
  /// **'Enter between {min} and {max} {unit}'**
  String profileErrorWeightRange(String min, String max, String unit);

  /// No description provided for @profileErrorHeightRangeCm.
  ///
  /// In en, this message translates to:
  /// **'Enter between 90 and 250 cm'**
  String get profileErrorHeightRangeCm;

  /// No description provided for @profileErrorHeightRangeImperial.
  ///
  /// In en, this message translates to:
  /// **'Enter between 2 ft 11 in and 8 ft 2 in'**
  String get profileErrorHeightRangeImperial;

  /// No description provided for @profileErrorHeightInches.
  ///
  /// In en, this message translates to:
  /// **'Inches must be from 0 to 11.5'**
  String get profileErrorHeightInches;

  /// No description provided for @profileErrorFutureDate.
  ///
  /// In en, this message translates to:
  /// **'That date is in the future'**
  String get profileErrorFutureDate;

  /// No description provided for @profileErrorAgeRange.
  ///
  /// In en, this message translates to:
  /// **'You need to be between 13 and 100'**
  String get profileErrorAgeRange;

  /// No description provided for @profileSave.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get profileSave;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile saved'**
  String get profileSaved;

  /// No description provided for @profilePhotoFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save the photo. Try another one.'**
  String get profilePhotoFailed;

  /// No description provided for @backupTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup & restore'**
  String get backupTitle;

  /// No description provided for @backupLastNever.
  ///
  /// In en, this message translates to:
  /// **'Last backup: never'**
  String get backupLastNever;

  /// No description provided for @backupLastAt.
  ///
  /// In en, this message translates to:
  /// **'Last backup: {when}'**
  String backupLastAt(String when);

  /// No description provided for @backupDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{today} =1{yesterday} other{{count} days ago}}'**
  String backupDaysAgo(int count);

  /// No description provided for @backupOldWarning.
  ///
  /// In en, this message translates to:
  /// **'It\'s been a while. Save a fresh copy so a lost phone doesn\'t mean lost progress.'**
  String get backupOldWarning;

  /// No description provided for @backupSave.
  ///
  /// In en, this message translates to:
  /// **'Save backup to device'**
  String get backupSave;

  /// No description provided for @backupShare.
  ///
  /// In en, this message translates to:
  /// **'Share backup'**
  String get backupShare;

  /// No description provided for @backupWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Send on WhatsApp'**
  String get backupWhatsApp;

  /// No description provided for @backupWhatsAppTip.
  ///
  /// In en, this message translates to:
  /// **'Tip: send it to yourself in WhatsApp to keep a copy.'**
  String get backupWhatsAppTip;

  /// No description provided for @backupRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore from backup'**
  String get backupRestore;

  /// No description provided for @backupUndoRestore.
  ///
  /// In en, this message translates to:
  /// **'Undo last restore'**
  String get backupUndoRestore;

  /// No description provided for @backupUndoRestoreHint.
  ///
  /// In en, this message translates to:
  /// **'Brings back the data you had just before your last restore.'**
  String get backupUndoRestoreHint;

  /// No description provided for @backupWorking.
  ///
  /// In en, this message translates to:
  /// **'Preparing your backup…'**
  String get backupWorking;

  /// No description provided for @backupSaved.
  ///
  /// In en, this message translates to:
  /// **'Backup saved'**
  String get backupSaved;

  /// No description provided for @backupShared.
  ///
  /// In en, this message translates to:
  /// **'Backup ready to share'**
  String get backupShared;

  /// No description provided for @backupFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t create the backup. Please try again.'**
  String get backupFailed;

  /// No description provided for @backupCancelled.
  ///
  /// In en, this message translates to:
  /// **'Nothing was saved.'**
  String get backupCancelled;

  /// No description provided for @backupWhatsAppMissing.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp isn\'t installed, so here\'s the share sheet instead.'**
  String get backupWhatsAppMissing;

  /// No description provided for @backupWhatsAppHelp.
  ///
  /// In en, this message translates to:
  /// **'To restore from WhatsApp: download the file in WhatsApp, then pick it here. On iPhone, tap \"Save to Files\" first.'**
  String get backupWhatsAppHelp;

  /// No description provided for @backupInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Where is my data?'**
  String get backupInfoTitle;

  /// No description provided for @backupInfoBody.
  ///
  /// In en, this message translates to:
  /// **'Everything lives in a file on this phone. If you uninstall the app or lose the phone, your data is gone unless you\'ve saved or shared a backup file. Saving one takes a few seconds.'**
  String get backupInfoBody;

  /// No description provided for @backupInfoLink.
  ///
  /// In en, this message translates to:
  /// **'What happens if I uninstall?'**
  String get backupInfoLink;

  /// No description provided for @backupReminderToggle.
  ///
  /// In en, this message translates to:
  /// **'Weekly backup reminder'**
  String get backupReminderToggle;

  /// No description provided for @backupReminderToggleHint.
  ///
  /// In en, this message translates to:
  /// **'A gentle notification once a week.'**
  String get backupReminderToggleHint;

  /// No description provided for @backupBannerToggle.
  ///
  /// In en, this message translates to:
  /// **'Remind me in the app'**
  String get backupBannerToggle;

  /// No description provided for @backupNotificationDenied.
  ///
  /// In en, this message translates to:
  /// **'Notifications are turned off for Gymlicious in your phone\'s settings.'**
  String get backupNotificationDenied;

  /// No description provided for @backupNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Time for a backup?'**
  String get backupNotificationTitle;

  /// No description provided for @backupNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'Save or share a copy of your workouts so they\'re safe.'**
  String get backupNotificationBody;

  /// No description provided for @backupNotificationChannel.
  ///
  /// In en, this message translates to:
  /// **'Backup reminders'**
  String get backupNotificationChannel;

  /// No description provided for @backupBannerText.
  ///
  /// In en, this message translates to:
  /// **'Your workouts only live on this phone. Save a backup?'**
  String get backupBannerText;

  /// No description provided for @backupBannerAction.
  ///
  /// In en, this message translates to:
  /// **'Back up'**
  String get backupBannerAction;

  /// No description provided for @backupBannerDismiss.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get backupBannerDismiss;

  /// No description provided for @restoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore this backup?'**
  String get restoreTitle;

  /// No description provided for @restorePreviewName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get restorePreviewName;

  /// No description provided for @restorePreviewExercises.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get restorePreviewExercises;

  /// No description provided for @restorePreviewSessions.
  ///
  /// In en, this message translates to:
  /// **'Workouts'**
  String get restorePreviewSessions;

  /// No description provided for @restorePreviewDate.
  ///
  /// In en, this message translates to:
  /// **'Backed up'**
  String get restorePreviewDate;

  /// No description provided for @restorePreviewPhoto.
  ///
  /// In en, this message translates to:
  /// **'Profile photo'**
  String get restorePreviewPhoto;

  /// No description provided for @restorePreviewPhotoYes.
  ///
  /// In en, this message translates to:
  /// **'Included'**
  String get restorePreviewPhotoYes;

  /// No description provided for @restorePreviewPhotoNo.
  ///
  /// In en, this message translates to:
  /// **'Not included'**
  String get restorePreviewPhotoNo;

  /// No description provided for @restoreWarning.
  ///
  /// In en, this message translates to:
  /// **'This replaces everything currently in the app. You can undo it once from Backup & restore.'**
  String get restoreWarning;

  /// No description provided for @restoreConfirm.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restoreConfirm;

  /// No description provided for @restoreWorking.
  ///
  /// In en, this message translates to:
  /// **'Restoring your data…'**
  String get restoreWorking;

  /// No description provided for @restoreDone.
  ///
  /// In en, this message translates to:
  /// **'All restored'**
  String get restoreDone;

  /// No description provided for @restoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Restore didn\'t finish. Your previous data is still there.'**
  String get restoreFailed;

  /// No description provided for @restoreNotABackup.
  ///
  /// In en, this message translates to:
  /// **'This file isn\'t a Gymlicious backup.'**
  String get restoreNotABackup;

  /// No description provided for @restoreDamaged.
  ///
  /// In en, this message translates to:
  /// **'This backup looks damaged, so it can\'t be restored.'**
  String get restoreDamaged;

  /// No description provided for @restoreNewerApp.
  ///
  /// In en, this message translates to:
  /// **'This backup is from a newer version. Please update the app first.'**
  String get restoreNewerApp;

  /// No description provided for @restoreInvalid.
  ///
  /// In en, this message translates to:
  /// **'Some data in this backup isn\'t readable, so it can\'t be restored.'**
  String get restoreInvalid;

  /// No description provided for @undoRestoreDone.
  ///
  /// In en, this message translates to:
  /// **'Your previous data is back'**
  String get undoRestoreDone;

  /// No description provided for @resetTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset all data'**
  String get resetTitle;

  /// No description provided for @resetIntro.
  ///
  /// In en, this message translates to:
  /// **'This erases your profile, exercises, splits, workouts and settings from this phone. It can\'t be undone.'**
  String get resetIntro;

  /// No description provided for @resetBackupFirst.
  ///
  /// In en, this message translates to:
  /// **'Save a backup first'**
  String get resetBackupFirst;

  /// No description provided for @resetTypeToConfirm.
  ///
  /// In en, this message translates to:
  /// **'Type {word} to confirm'**
  String resetTypeToConfirm(String word);

  /// No description provided for @resetConfirmWord.
  ///
  /// In en, this message translates to:
  /// **'DELETE'**
  String get resetConfirmWord;

  /// No description provided for @resetButton.
  ///
  /// In en, this message translates to:
  /// **'Erase everything'**
  String get resetButton;

  /// No description provided for @resetDone.
  ///
  /// In en, this message translates to:
  /// **'All data erased'**
  String get resetDone;

  /// No description provided for @gateRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore from backup'**
  String get gateRestore;

  /// No description provided for @gateHeading.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Gymlicious. Let\'s get you set up.'**
  String get gateHeading;

  /// No description provided for @gateSubheading.
  ///
  /// In en, this message translates to:
  /// **'Everything you enter stays on this device. No account needed.'**
  String get gateSubheading;

  /// No description provided for @gateContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get gateContinue;

  /// No description provided for @gateFixErrors.
  ///
  /// In en, this message translates to:
  /// **'A few details need a look.'**
  String get gateFixErrors;

  /// No description provided for @splitStepTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick a split'**
  String get splitStepTitle;

  /// No description provided for @splitStepSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A starting rotation you can edit any time.'**
  String get splitStepSubtitle;

  /// No description provided for @splitStepOwn.
  ///
  /// In en, this message translates to:
  /// **'I\'ll create my own'**
  String get splitStepOwn;

  /// No description provided for @splitStepOwnSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start with an empty split'**
  String get splitStepOwnSubtitle;

  /// No description provided for @splitStepDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String splitStepDays(int count);

  /// No description provided for @setUpLater.
  ///
  /// In en, this message translates to:
  /// **'Set up later'**
  String get setUpLater;

  /// No description provided for @weightsStepTitle.
  ///
  /// In en, this message translates to:
  /// **'Starting weights'**
  String get weightsStepTitle;

  /// No description provided for @weightsStepSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Optional. Enter your best and most recent weights so your history isn\'t empty on day one.'**
  String get weightsStepSubtitle;

  /// No description provided for @weightsStepMax.
  ///
  /// In en, this message translates to:
  /// **'Best'**
  String get weightsStepMax;

  /// No description provided for @weightsStepLast.
  ///
  /// In en, this message translates to:
  /// **'Last'**
  String get weightsStepLast;

  /// No description provided for @weightsStepSave.
  ///
  /// In en, this message translates to:
  /// **'Save and finish'**
  String get weightsStepSave;

  /// No description provided for @weightsStepInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a weight, or leave it empty'**
  String get weightsStepInvalid;

  /// No description provided for @muscleChest.
  ///
  /// In en, this message translates to:
  /// **'Chest'**
  String get muscleChest;

  /// No description provided for @muscleBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get muscleBack;

  /// No description provided for @muscleShoulders.
  ///
  /// In en, this message translates to:
  /// **'Shoulders'**
  String get muscleShoulders;

  /// No description provided for @muscleBiceps.
  ///
  /// In en, this message translates to:
  /// **'Biceps'**
  String get muscleBiceps;

  /// No description provided for @muscleTriceps.
  ///
  /// In en, this message translates to:
  /// **'Triceps'**
  String get muscleTriceps;

  /// No description provided for @muscleForearms.
  ///
  /// In en, this message translates to:
  /// **'Forearms'**
  String get muscleForearms;

  /// No description provided for @muscleQuads.
  ///
  /// In en, this message translates to:
  /// **'Quads'**
  String get muscleQuads;

  /// No description provided for @muscleHamstrings.
  ///
  /// In en, this message translates to:
  /// **'Hamstrings'**
  String get muscleHamstrings;

  /// No description provided for @muscleGlutes.
  ///
  /// In en, this message translates to:
  /// **'Glutes'**
  String get muscleGlutes;

  /// No description provided for @muscleCalves.
  ///
  /// In en, this message translates to:
  /// **'Calves'**
  String get muscleCalves;

  /// No description provided for @muscleCore.
  ///
  /// In en, this message translates to:
  /// **'Core'**
  String get muscleCore;

  /// No description provided for @muscleFullBody.
  ///
  /// In en, this message translates to:
  /// **'Full body'**
  String get muscleFullBody;

  /// No description provided for @muscleCardio.
  ///
  /// In en, this message translates to:
  /// **'Cardio'**
  String get muscleCardio;

  /// No description provided for @equipmentBarbell.
  ///
  /// In en, this message translates to:
  /// **'Barbell'**
  String get equipmentBarbell;

  /// No description provided for @equipmentDumbbell.
  ///
  /// In en, this message translates to:
  /// **'Dumbbell'**
  String get equipmentDumbbell;

  /// No description provided for @equipmentMachine.
  ///
  /// In en, this message translates to:
  /// **'Machine'**
  String get equipmentMachine;

  /// No description provided for @equipmentCable.
  ///
  /// In en, this message translates to:
  /// **'Cable'**
  String get equipmentCable;

  /// No description provided for @equipmentBodyweight.
  ///
  /// In en, this message translates to:
  /// **'Bodyweight'**
  String get equipmentBodyweight;

  /// No description provided for @equipmentKettlebell.
  ///
  /// In en, this message translates to:
  /// **'Kettlebell'**
  String get equipmentKettlebell;

  /// No description provided for @equipmentBand.
  ///
  /// In en, this message translates to:
  /// **'Band'**
  String get equipmentBand;

  /// No description provided for @equipmentOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get equipmentOther;

  /// No description provided for @exercisesTitle.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get exercisesTitle;

  /// No description provided for @exercisesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search exercises'**
  String get exercisesSearchHint;

  /// No description provided for @exercisesFilter.
  ///
  /// In en, this message translates to:
  /// **'Filter by muscle'**
  String get exercisesFilter;

  /// No description provided for @exercisesShowArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get exercisesShowArchived;

  /// No description provided for @exercisesAdd.
  ///
  /// In en, this message translates to:
  /// **'Add exercise'**
  String get exercisesAdd;

  /// No description provided for @exercisesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No exercises match. Try another search or add your own.'**
  String get exercisesEmpty;

  /// No description provided for @exercisesNoneSelected.
  ///
  /// In en, this message translates to:
  /// **'Pick an exercise to see its progress.'**
  String get exercisesNoneSelected;

  /// No description provided for @exerciseFormTitle.
  ///
  /// In en, this message translates to:
  /// **'New exercise'**
  String get exerciseFormTitle;

  /// No description provided for @exerciseEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit exercise'**
  String get exerciseEditTitle;

  /// No description provided for @exerciseName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get exerciseName;

  /// No description provided for @exerciseMuscle.
  ///
  /// In en, this message translates to:
  /// **'Muscle group'**
  String get exerciseMuscle;

  /// No description provided for @exerciseEquipment.
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get exerciseEquipment;

  /// No description provided for @exerciseStartingMax.
  ///
  /// In en, this message translates to:
  /// **'Starting max'**
  String get exerciseStartingMax;

  /// No description provided for @exerciseStartingMaxHint.
  ///
  /// In en, this message translates to:
  /// **'Your best lift before using the app, if you know it.'**
  String get exerciseStartingMaxHint;

  /// No description provided for @exerciseNameTaken.
  ///
  /// In en, this message translates to:
  /// **'You already have an exercise with this name'**
  String get exerciseNameTaken;

  /// No description provided for @exerciseNameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Give it a name'**
  String get exerciseNameEmpty;

  /// No description provided for @exerciseNameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Use 60 characters or fewer'**
  String get exerciseNameTooLong;

  /// No description provided for @exerciseSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get exerciseSave;

  /// No description provided for @exerciseMaxOn.
  ///
  /// In en, this message translates to:
  /// **'Max · {date}'**
  String exerciseMaxOn(String date);

  /// No description provided for @exerciseLastOn.
  ///
  /// In en, this message translates to:
  /// **'Last · {date}'**
  String exerciseLastOn(String date);

  /// No description provided for @exerciseFromBaseline.
  ///
  /// In en, this message translates to:
  /// **'Starting max'**
  String get exerciseFromBaseline;

  /// No description provided for @exerciseProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get exerciseProgress;

  /// No description provided for @exerciseProgressEmpty.
  ///
  /// In en, this message translates to:
  /// **'Log this exercise to see your progress here.'**
  String get exerciseProgressEmpty;

  /// No description provided for @exerciseChartLabel.
  ///
  /// In en, this message translates to:
  /// **'Best weight per session, {count} sessions'**
  String exerciseChartLabel(int count);

  /// No description provided for @exerciseHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get exerciseHistory;

  /// No description provided for @exerciseHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No sessions yet.'**
  String get exerciseHistoryEmpty;

  /// No description provided for @exerciseNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get exerciseNotes;

  /// No description provided for @exerciseNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Cues, seat height, grip…'**
  String get exerciseNotesHint;

  /// No description provided for @exerciseArchive.
  ///
  /// In en, this message translates to:
  /// **'Archive exercise'**
  String get exerciseArchive;

  /// No description provided for @exerciseDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete exercise'**
  String get exerciseDelete;

  /// No description provided for @exerciseUnarchive.
  ///
  /// In en, this message translates to:
  /// **'Restore exercise'**
  String get exerciseUnarchive;

  /// No description provided for @exerciseArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived. It stays in your history.'**
  String get exerciseArchived;

  /// No description provided for @exerciseDeleted.
  ///
  /// In en, this message translates to:
  /// **'Exercise deleted'**
  String get exerciseDeleted;

  /// No description provided for @exerciseArchiveQuestion.
  ///
  /// In en, this message translates to:
  /// **'Archive this exercise?'**
  String get exerciseArchiveQuestion;

  /// No description provided for @exerciseArchiveExplain.
  ///
  /// In en, this message translates to:
  /// **'It has history, so it will be hidden from pickers but kept in your past workouts.'**
  String get exerciseArchiveExplain;

  /// No description provided for @exerciseDeleteQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete this exercise?'**
  String get exerciseDeleteQuestion;

  /// No description provided for @exerciseDeleteExplain.
  ///
  /// In en, this message translates to:
  /// **'It hasn\'t been logged yet, so it will be removed completely.'**
  String get exerciseDeleteExplain;

  /// No description provided for @exerciseSetSummary.
  ///
  /// In en, this message translates to:
  /// **'{weight} × {reps}'**
  String exerciseSetSummary(String weight, String reps);

  /// No description provided for @exerciseWarmupMark.
  ///
  /// In en, this message translates to:
  /// **'warm-up'**
  String get exerciseWarmupMark;

  /// No description provided for @exerciseNotFound.
  ///
  /// In en, this message translates to:
  /// **'This exercise no longer exists.'**
  String get exerciseNotFound;

  /// No description provided for @trainTitle.
  ///
  /// In en, this message translates to:
  /// **'Train'**
  String get trainTitle;

  /// No description provided for @trainActiveSplit.
  ///
  /// In en, this message translates to:
  /// **'Active split'**
  String get trainActiveSplit;

  /// No description provided for @trainChooseSplit.
  ///
  /// In en, this message translates to:
  /// **'Choose a split'**
  String get trainChooseSplit;

  /// No description provided for @trainNoSplits.
  ///
  /// In en, this message translates to:
  /// **'No splits yet. Create one, or start a freestyle workout.'**
  String get trainNoSplits;

  /// No description provided for @trainUpNext.
  ///
  /// In en, this message translates to:
  /// **'Up next'**
  String get trainUpNext;

  /// No description provided for @trainRestDay.
  ///
  /// In en, this message translates to:
  /// **'Rest day'**
  String get trainRestDay;

  /// No description provided for @trainExerciseCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No exercises} =1{1 exercise} other{{count} exercises}}'**
  String trainExerciseCount(int count);

  /// No description provided for @trainFreestyle.
  ///
  /// In en, this message translates to:
  /// **'Freestyle workout'**
  String get trainFreestyle;

  /// No description provided for @trainFreestyleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add exercises as you go'**
  String get trainFreestyleSubtitle;

  /// No description provided for @trainSplits.
  ///
  /// In en, this message translates to:
  /// **'Your splits'**
  String get trainSplits;

  /// No description provided for @trainNewSplit.
  ///
  /// In en, this message translates to:
  /// **'New split'**
  String get trainNewSplit;

  /// No description provided for @trainEditSplit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get trainEditSplit;

  /// No description provided for @trainDraftExists.
  ///
  /// In en, this message translates to:
  /// **'You have a workout in progress'**
  String get trainDraftExists;

  /// No description provided for @trainResume.
  ///
  /// In en, this message translates to:
  /// **'Resume workout'**
  String get trainResume;

  /// No description provided for @trainDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get trainDiscard;

  /// No description provided for @trainDiscardQuestion.
  ///
  /// In en, this message translates to:
  /// **'Discard this workout?'**
  String get trainDiscardQuestion;

  /// No description provided for @trainDiscardExplain.
  ///
  /// In en, this message translates to:
  /// **'Sets you logged in it will be lost.'**
  String get trainDiscardExplain;

  /// No description provided for @splitEditorNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New split'**
  String get splitEditorNewTitle;

  /// No description provided for @splitEditorTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit split'**
  String get splitEditorTitle;

  /// No description provided for @splitName.
  ///
  /// In en, this message translates to:
  /// **'Split name'**
  String get splitName;

  /// No description provided for @splitDefaultName.
  ///
  /// In en, this message translates to:
  /// **'My split'**
  String get splitDefaultName;

  /// No description provided for @splitDefaultDay.
  ///
  /// In en, this message translates to:
  /// **'Day {number}'**
  String splitDefaultDay(int number);

  /// No description provided for @splitDays.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get splitDays;

  /// No description provided for @splitDayName.
  ///
  /// In en, this message translates to:
  /// **'Day name'**
  String get splitDayName;

  /// No description provided for @splitRestDay.
  ///
  /// In en, this message translates to:
  /// **'Rest day'**
  String get splitRestDay;

  /// No description provided for @splitAddDay.
  ///
  /// In en, this message translates to:
  /// **'Add day'**
  String get splitAddDay;

  /// No description provided for @splitAddExercise.
  ///
  /// In en, this message translates to:
  /// **'Add exercise'**
  String get splitAddExercise;

  /// No description provided for @splitRemoveDay.
  ///
  /// In en, this message translates to:
  /// **'Remove day'**
  String get splitRemoveDay;

  /// No description provided for @splitRemoveExercise.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}'**
  String splitRemoveExercise(String name);

  /// No description provided for @splitReorderHint.
  ///
  /// In en, this message translates to:
  /// **'Hold and drag to reorder'**
  String get splitReorderHint;

  /// No description provided for @splitMakeActive.
  ///
  /// In en, this message translates to:
  /// **'Make active'**
  String get splitMakeActive;

  /// No description provided for @splitIsActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get splitIsActive;

  /// No description provided for @splitDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete split'**
  String get splitDelete;

  /// No description provided for @splitDeleteQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete this split?'**
  String get splitDeleteQuestion;

  /// No description provided for @splitDeleteExplain.
  ///
  /// In en, this message translates to:
  /// **'Your past workouts stay in history.'**
  String get splitDeleteExplain;

  /// No description provided for @splitSave.
  ///
  /// In en, this message translates to:
  /// **'Save split'**
  String get splitSave;

  /// No description provided for @splitNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Give the split a name'**
  String get splitNameRequired;

  /// No description provided for @pickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Add exercise'**
  String get pickerTitle;

  /// No description provided for @pickerNewExercise.
  ///
  /// In en, this message translates to:
  /// **'Create a new exercise'**
  String get pickerNewExercise;

  /// No description provided for @sessionFreestyle.
  ///
  /// In en, this message translates to:
  /// **'Freestyle'**
  String get sessionFreestyle;

  /// No description provided for @sessionElapsed.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String sessionElapsed(int minutes);

  /// No description provided for @sessionAddSet.
  ///
  /// In en, this message translates to:
  /// **'Add set'**
  String get sessionAddSet;

  /// No description provided for @sessionAddExercise.
  ///
  /// In en, this message translates to:
  /// **'Add exercise'**
  String get sessionAddExercise;

  /// No description provided for @sessionFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get sessionFinish;

  /// No description provided for @sessionDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard workout'**
  String get sessionDiscard;

  /// No description provided for @sessionExerciseNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get sessionExerciseNote;

  /// No description provided for @sessionMoveUp.
  ///
  /// In en, this message translates to:
  /// **'Move up'**
  String get sessionMoveUp;

  /// No description provided for @sessionMoveDown.
  ///
  /// In en, this message translates to:
  /// **'Move down'**
  String get sessionMoveDown;

  /// No description provided for @sessionRemoveExercise.
  ///
  /// In en, this message translates to:
  /// **'Remove exercise'**
  String get sessionRemoveExercise;

  /// No description provided for @sessionEmpty.
  ///
  /// In en, this message translates to:
  /// **'Add an exercise to start logging.'**
  String get sessionEmpty;

  /// No description provided for @sessionLastMax.
  ///
  /// In en, this message translates to:
  /// **'Last {last} · Max {max}'**
  String sessionLastMax(String last, String max);

  /// No description provided for @sessionNewMax.
  ///
  /// In en, this message translates to:
  /// **'New max'**
  String get sessionNewMax;

  /// No description provided for @sessionSetRemoved.
  ///
  /// In en, this message translates to:
  /// **'Set removed'**
  String get sessionSetRemoved;

  /// No description provided for @sessionFinishNothingDone.
  ///
  /// In en, this message translates to:
  /// **'Nothing was marked done, so this workout wasn\'t saved.'**
  String get sessionFinishNothingDone;

  /// No description provided for @sessionFinishQuestion.
  ///
  /// In en, this message translates to:
  /// **'Finish workout?'**
  String get sessionFinishQuestion;

  /// No description provided for @sessionFinishUndone.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 set isn\'t marked done and won\'t be saved.} other{{count} sets aren\'t marked done and won\'t be saved.}}'**
  String sessionFinishUndone(int count);

  /// No description provided for @summaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Nice work'**
  String get summaryTitle;

  /// No description provided for @summaryDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get summaryDuration;

  /// No description provided for @summaryExercises.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get summaryExercises;

  /// No description provided for @summarySets.
  ///
  /// In en, this message translates to:
  /// **'Sets'**
  String get summarySets;

  /// No description provided for @summaryNewMaxes.
  ///
  /// In en, this message translates to:
  /// **'New maxes'**
  String get summaryNewMaxes;

  /// No description provided for @summaryNoNewMax.
  ///
  /// In en, this message translates to:
  /// **'No new maxes this time. Consistency counts.'**
  String get summaryNoNewMax;

  /// No description provided for @summaryDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get summaryDone;

  /// No description provided for @summaryMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String summaryMinutes(int count);

  /// No description provided for @sessionNoActive.
  ///
  /// In en, this message translates to:
  /// **'There\'s no workout in progress.'**
  String get sessionNoActive;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// No description provided for @historyList.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get historyList;

  /// No description provided for @historyCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get historyCalendar;

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No workouts yet. Your finished sessions will show up here.'**
  String get historyEmpty;

  /// No description provided for @historyThisMonth.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No sessions this month} =1{1 session this month} other{{count} sessions this month}}'**
  String historyThisMonth(int count);

  /// No description provided for @historyVolume.
  ///
  /// In en, this message translates to:
  /// **'Volume: {value}'**
  String historyVolume(String value);

  /// No description provided for @historySessionSummary.
  ///
  /// In en, this message translates to:
  /// **'{exercises} · {sets}'**
  String historySessionSummary(String exercises, String sets);

  /// No description provided for @historySetCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 set} other{{count} sets}}'**
  String historySetCount(int count);

  /// No description provided for @historyPreviousMonth.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get historyPreviousMonth;

  /// No description provided for @historyNextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get historyNextMonth;

  /// No description provided for @historyTrainedDay.
  ///
  /// In en, this message translates to:
  /// **'{date}, trained'**
  String historyTrainedDay(String date);

  /// No description provided for @historyNoSessionsOnDay.
  ///
  /// In en, this message translates to:
  /// **'No workouts on this day.'**
  String get historyNoSessionsOnDay;

  /// No description provided for @historySelectSession.
  ///
  /// In en, this message translates to:
  /// **'Pick a workout to see the details.'**
  String get historySelectSession;

  /// No description provided for @sessionDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get sessionDetailTitle;

  /// No description provided for @sessionDetailDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get sessionDetailDate;

  /// No description provided for @sessionDetailEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit workout'**
  String get sessionDetailEdit;

  /// No description provided for @sessionDetailDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete workout'**
  String get sessionDetailDelete;

  /// No description provided for @sessionDetailDeleteQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete this workout?'**
  String get sessionDetailDeleteQuestion;

  /// No description provided for @sessionDetailDeleteExplain.
  ///
  /// In en, this message translates to:
  /// **'Max and last weights will be recalculated without it.'**
  String get sessionDetailDeleteExplain;

  /// No description provided for @sessionDetailDeleted.
  ///
  /// In en, this message translates to:
  /// **'Workout deleted'**
  String get sessionDetailDeleted;

  /// No description provided for @sessionDetailSaved.
  ///
  /// In en, this message translates to:
  /// **'Workout updated'**
  String get sessionDetailSaved;

  /// No description provided for @sessionDetailMissing.
  ///
  /// In en, this message translates to:
  /// **'This workout no longer exists.'**
  String get sessionDetailMissing;

  /// No description provided for @sessionEditSave.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get sessionEditSave;

  /// No description provided for @homeGreetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning, {name}'**
  String homeGreetingMorning(String name);

  /// No description provided for @homeGreetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon, {name}'**
  String homeGreetingAfternoon(String name);

  /// No description provided for @homeGreetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening, {name}'**
  String homeGreetingEvening(String name);

  /// No description provided for @homeOpenProfile.
  ///
  /// In en, this message translates to:
  /// **'Open profile'**
  String get homeOpenProfile;

  /// No description provided for @homeResumeTitle.
  ///
  /// In en, this message translates to:
  /// **'Workout in progress'**
  String get homeResumeTitle;

  /// No description provided for @homeResumeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{day} · started {time}'**
  String homeResumeSubtitle(String day, String time);

  /// No description provided for @yearTitle.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get yearTitle;

  /// No description provided for @yearLayoutContinuous.
  ///
  /// In en, this message translates to:
  /// **'Continuous'**
  String get yearLayoutContinuous;

  /// No description provided for @yearLayoutMonths.
  ///
  /// In en, this message translates to:
  /// **'Months'**
  String get yearLayoutMonths;

  /// No description provided for @yearSummaryLine.
  ///
  /// In en, this message translates to:
  /// **'Day {day} of {total} · {left} left · {percent}%'**
  String yearSummaryLine(int day, int total, int left, int percent);

  /// No description provided for @yearLeftOnlyLine.
  ///
  /// In en, this message translates to:
  /// **'{left} days left'**
  String yearLeftOnlyLine(int left);

  /// No description provided for @yearDotTooltip.
  ///
  /// In en, this message translates to:
  /// **'{date} · Day {day}'**
  String yearDotTooltip(String date, int day);

  /// No description provided for @yearDotDone.
  ///
  /// In en, this message translates to:
  /// **'{date}, day {day}, done'**
  String yearDotDone(String date, int day);

  /// No description provided for @yearDotToday.
  ///
  /// In en, this message translates to:
  /// **'{date}, day {day}, today'**
  String yearDotToday(String date, int day);

  /// No description provided for @yearDotLeft.
  ///
  /// In en, this message translates to:
  /// **'{date}, day {day}, upcoming'**
  String yearDotLeft(String date, int day);

  /// No description provided for @yearGridSummary.
  ///
  /// In en, this message translates to:
  /// **'Year progress: day {day} of {total}, {left} days left'**
  String yearGridSummary(int day, int total, int left);

  /// No description provided for @yearWallpaper.
  ///
  /// In en, this message translates to:
  /// **'Wallpaper'**
  String get yearWallpaper;

  /// No description provided for @wallpaperTitle.
  ///
  /// In en, this message translates to:
  /// **'Year Dots wallpaper'**
  String get wallpaperTitle;

  /// No description provided for @wallpaperLayout.
  ///
  /// In en, this message translates to:
  /// **'Layout'**
  String get wallpaperLayout;

  /// No description provided for @wallpaperColours.
  ///
  /// In en, this message translates to:
  /// **'Colours'**
  String get wallpaperColours;

  /// No description provided for @wallpaperPresetLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get wallpaperPresetLight;

  /// No description provided for @wallpaperPresetDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get wallpaperPresetDark;

  /// No description provided for @wallpaperPresetBlack.
  ///
  /// In en, this message translates to:
  /// **'Black'**
  String get wallpaperPresetBlack;

  /// No description provided for @wallpaperPresetEmber.
  ///
  /// In en, this message translates to:
  /// **'Ember'**
  String get wallpaperPresetEmber;

  /// No description provided for @wallpaperTextLine.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get wallpaperTextLine;

  /// No description provided for @wallpaperTextLeftAndPercent.
  ///
  /// In en, this message translates to:
  /// **'Days left + %'**
  String get wallpaperTextLeftAndPercent;

  /// No description provided for @wallpaperTextLeftOnly.
  ///
  /// In en, this message translates to:
  /// **'Days left'**
  String get wallpaperTextLeftOnly;

  /// No description provided for @wallpaperTextNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get wallpaperTextNone;

  /// No description provided for @wallpaperTopMargin.
  ///
  /// In en, this message translates to:
  /// **'Space for the clock: {percent}%'**
  String wallpaperTopMargin(int percent);

  /// No description provided for @wallpaperPadding.
  ///
  /// In en, this message translates to:
  /// **'Side padding: {value}'**
  String wallpaperPadding(int value);

  /// No description provided for @wallpaperSetLive.
  ///
  /// In en, this message translates to:
  /// **'Set as wallpaper'**
  String get wallpaperSetLive;

  /// No description provided for @wallpaperSetLiveHint.
  ///
  /// In en, this message translates to:
  /// **'Opens your phone\'s wallpaper preview. It updates by itself every day.'**
  String get wallpaperSetLiveHint;

  /// No description provided for @wallpaperLiveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the wallpaper picker. Save an image instead.'**
  String get wallpaperLiveFailed;

  /// No description provided for @wallpaperSaveImage.
  ///
  /// In en, this message translates to:
  /// **'Save wallpaper image'**
  String get wallpaperSaveImage;

  /// No description provided for @wallpaperSaveImageHint.
  ///
  /// In en, this message translates to:
  /// **'Saves today\'s picture to Photos. Set it as your wallpaper from there.'**
  String get wallpaperSaveImageHint;

  /// No description provided for @wallpaperIosNote.
  ///
  /// In en, this message translates to:
  /// **'iPhones don\'t allow live wallpapers, so the image shows the day it was made. Save a new one whenever you like.'**
  String get wallpaperIosNote;

  /// No description provided for @wallpaperSamsungNote.
  ///
  /// In en, this message translates to:
  /// **'Some phones limit live wallpapers on the lock screen. If yours does, use a saved image there.'**
  String get wallpaperSamsungNote;

  /// No description provided for @wallpaperSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved to Photos'**
  String get wallpaperSaved;

  /// No description provided for @wallpaperSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save the image. Check the app\'s Photos permission.'**
  String get wallpaperSaveFailed;

  /// No description provided for @wallpaperWorking.
  ///
  /// In en, this message translates to:
  /// **'Drawing your wallpaper…'**
  String get wallpaperWorking;

  /// No description provided for @recoveryTitle.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t read your data'**
  String get recoveryTitle;

  /// No description provided for @recoveryBody.
  ///
  /// In en, this message translates to:
  /// **'Your data file and its automatic copy both appear to be damaged. You can restore from a backup file, or start fresh.'**
  String get recoveryBody;

  /// No description provided for @recoveryRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore from backup'**
  String get recoveryRestore;

  /// No description provided for @recoveryStartFresh.
  ///
  /// In en, this message translates to:
  /// **'Start fresh'**
  String get recoveryStartFresh;

  /// No description provided for @recoveryStartFreshQuestion.
  ///
  /// In en, this message translates to:
  /// **'Start fresh?'**
  String get recoveryStartFreshQuestion;

  /// No description provided for @recoveryStartFreshExplain.
  ///
  /// In en, this message translates to:
  /// **'This permanently erases the damaged data on this device. Restore from a backup first if you have one.'**
  String get recoveryStartFreshExplain;

  /// No description provided for @navigationLabel.
  ///
  /// In en, this message translates to:
  /// **'Main navigation'**
  String get navigationLabel;

  /// Label under the big streak number.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{day streak} other{day streak}}'**
  String streakDayLabel(int count);

  /// Screen-reader label for the streak number and flame.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No streak yet} =1{1-day streak} other{{count}-day streak}}'**
  String streakSemantics(int count);

  /// Secondary streak number.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No weeks on track yet} =1{1 week on track} other{{count} weeks on track}}'**
  String streakWeeksOnTrack(int count);

  /// Best streak, in workout days.
  ///
  /// In en, this message translates to:
  /// **'Best: {count}'**
  String streakBest(int count);

  /// Weekly progress ring caption.
  ///
  /// In en, this message translates to:
  /// **'{done} of {goal} days'**
  String weekRingLabel(int done, int goal);

  /// Onboarding step indicator.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String stepIndicatorLabel(int current, int total);

  /// Current level on the XP bar.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String xpLevel(int level);

  /// XP remaining until the next level.
  ///
  /// In en, this message translates to:
  /// **'{xp} XP to level {next}'**
  String xpToNextLevel(int xp, int next);

  /// Earned badge date.
  ///
  /// In en, this message translates to:
  /// **'Earned {date}'**
  String badgeEarnedOn(String date);

  /// Semantics state for a locked badge.
  ///
  /// In en, this message translates to:
  /// **'Not earned yet'**
  String get badgeLocked;

  /// Day state, read after the date by screen readers.
  ///
  /// In en, this message translates to:
  /// **'workout done'**
  String get dayStateDone;

  /// Past day without a workout. Never say missed.
  ///
  /// In en, this message translates to:
  /// **'no workout'**
  String get dayStateNoWorkout;

  /// Sunday without a workout.
  ///
  /// In en, this message translates to:
  /// **'rest day'**
  String get dayStateRest;

  /// Day with a note but no workout yet.
  ///
  /// In en, this message translates to:
  /// **'planned'**
  String get dayStatePlanned;

  /// Future day with nothing planned.
  ///
  /// In en, this message translates to:
  /// **'upcoming'**
  String get dayStateUpcoming;

  /// Marks today in a day label.
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get dayStateToday;

  /// Hint under a celebration card.
  ///
  /// In en, this message translates to:
  /// **'Tap anywhere to continue'**
  String get celebrationContinue;

  /// Screen-reader label for a days-per-week chip.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String numberChoiceSemantics(int count);

  /// Bottom navigation: calendar and check-ins.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get tabPlan;

  /// Bottom navigation: statistics.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get tabStats;

  /// Bottom navigation: profile and settings.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get tabMe;

  /// Streak status when the weekly goal is reached.
  ///
  /// In en, this message translates to:
  /// **'On track: this week\'s goal is done'**
  String get statusMet;

  /// Streak status with days to spare.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 more to go this week} other{{count} more to go this week}}'**
  String statusMoreToGo(int count);

  /// One workout needed and today is the last day that can count. Gentle, never alarming.
  ///
  /// In en, this message translates to:
  /// **'Last chance today'**
  String get statusLastChanceToday;

  /// Every remaining day is needed.
  ///
  /// In en, this message translates to:
  /// **'Train today to stay on track'**
  String get statusTrainToday;

  /// No streak right now. Never say the streak broke.
  ///
  /// In en, this message translates to:
  /// **'Fresh start today'**
  String get statusFreshStartToday;

  /// A new streak started inside a week that can no longer meet its goal.
  ///
  /// In en, this message translates to:
  /// **'New streak: day {count}'**
  String statusNewStreak(int count);

  /// Today card heading.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayTitle;

  /// The one daily check-in question.
  ///
  /// In en, this message translates to:
  /// **'Did you work out today?'**
  String get todayQuestion;

  /// Big check-in button.
  ///
  /// In en, this message translates to:
  /// **'I worked out today'**
  String get todayCheckIn;

  /// Shown after checking in today.
  ///
  /// In en, this message translates to:
  /// **'Done. Nice work!'**
  String get todayDone;

  /// Unmarks today's check-in.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get todayUndo;

  /// Opens the day sheet for today.
  ///
  /// In en, this message translates to:
  /// **'Add note or time'**
  String get todayAddDetails;

  /// Secondary button that opens the logger for the up-next day.
  ///
  /// In en, this message translates to:
  /// **'Start workout: {day}'**
  String todayStartWorkout(String day);

  /// Today card on a Sunday that is not done.
  ///
  /// In en, this message translates to:
  /// **'Sunday is your rest day. Trained anyway? It counts as a bonus.'**
  String get todayRestDay;

  /// Shows today's planned note.
  ///
  /// In en, this message translates to:
  /// **'Planned: {note}'**
  String todayPlanned(String note);

  /// Screen-reader label for a calendar day.
  ///
  /// In en, this message translates to:
  /// **'{date}, {state}'**
  String dayLabel(String date, String state);

  /// Done switch in the day sheet.
  ///
  /// In en, this message translates to:
  /// **'Worked out'**
  String get daySheetDone;

  /// Under the Done switch.
  ///
  /// In en, this message translates to:
  /// **'Turn on if you trained this day'**
  String get daySheetDoneHint;

  /// Future days can only be planned.
  ///
  /// In en, this message translates to:
  /// **'You can tick this off on the day.'**
  String get daySheetFutureHint;

  /// Description field label.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get daySheetNote;

  /// Description field hint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Chest + triceps'**
  String get daySheetNoteHint;

  /// Time row label.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get daySheetTime;

  /// Time row label for future days.
  ///
  /// In en, this message translates to:
  /// **'Planned time'**
  String get daySheetPlannedTime;

  /// Button when no time is set.
  ///
  /// In en, this message translates to:
  /// **'Add time'**
  String get daySheetAddTime;

  /// Removes the time.
  ///
  /// In en, this message translates to:
  /// **'Clear time'**
  String get daySheetClearTime;

  /// Duration chips label.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get daySheetDuration;

  /// A duration in minutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String daySheetMinutes(int minutes);

  /// Duration chip for no duration.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get daySheetNoDuration;

  /// When a gym session exists for the day.
  ///
  /// In en, this message translates to:
  /// **'Workout logged at {time}'**
  String daySheetSessionLogged(String time);

  /// Opens the session from the day sheet.
  ///
  /// In en, this message translates to:
  /// **'View workout'**
  String get daySheetViewWorkout;

  /// Saves the day sheet.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get daySheetSave;

  /// Plan screen title.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get planTitle;

  /// Week strip navigation.
  ///
  /// In en, this message translates to:
  /// **'Previous week'**
  String get planPreviousWeek;

  /// Week strip navigation.
  ///
  /// In en, this message translates to:
  /// **'Next week'**
  String get planNextWeek;

  /// Month navigation.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get planPreviousMonth;

  /// Month navigation.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get planNextMonth;

  /// Returns the week strip to today.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get planThisWeek;

  /// Calendar legend.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get planLegendDone;

  /// Calendar legend. Never 'missed'.
  ///
  /// In en, this message translates to:
  /// **'No workout'**
  String get planLegendNoWorkout;

  /// Calendar legend.
  ///
  /// In en, this message translates to:
  /// **'Rest day'**
  String get planLegendRest;

  /// Calendar legend.
  ///
  /// In en, this message translates to:
  /// **'Planned'**
  String get planLegendPlanned;

  /// Calendar legend.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get planLegendUpcoming;

  /// Friendly hint on the Plan screen.
  ///
  /// In en, this message translates to:
  /// **'Tap any day to tick it off or plan it.'**
  String get planHint;

  /// Home teaser heading.
  ///
  /// In en, this message translates to:
  /// **'Next badge'**
  String get homeNextBadge;

  /// Teaser when nothing is left to earn.
  ///
  /// In en, this message translates to:
  /// **'Every badge earned. Legendary!'**
  String get homeAllBadges;

  /// Stats screen title.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get statsTitle;

  /// Stat tile.
  ///
  /// In en, this message translates to:
  /// **'Current streak'**
  String get statsCurrentStreak;

  /// Stat tile.
  ///
  /// In en, this message translates to:
  /// **'Best streak'**
  String get statsBestStreak;

  /// Stat tile.
  ///
  /// In en, this message translates to:
  /// **'Total workouts'**
  String get statsTotalWorkouts;

  /// Stat tile.
  ///
  /// In en, this message translates to:
  /// **'Weeks on track'**
  String get statsWeeksOnTrack;

  /// Stat tile label.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get statsThisWeek;

  /// Stat tile label and heatmap heading.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get statsThisMonth;

  /// Workout count.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 workout} other{{count} workouts}}'**
  String statsWorkoutCount(int count);

  /// Stat tile.
  ///
  /// In en, this message translates to:
  /// **'Consistency'**
  String get statsConsistency;

  /// Explains the consistency percentage.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Your last week, measured against your goal.} other{Weeks that met your goal, out of your last {count}.}}'**
  String statsConsistencyHelp(int count);

  /// Weekly bar chart heading.
  ///
  /// In en, this message translates to:
  /// **'Last 8 weeks'**
  String get statsLastWeeks;

  /// Weekly bar chart help.
  ///
  /// In en, this message translates to:
  /// **'Workouts each week. The line is your goal.'**
  String get statsLastWeeksHelp;

  /// Time-of-day chart heading.
  ///
  /// In en, this message translates to:
  /// **'When you train'**
  String get statsTimeOfDay;

  /// Empty state for the time-of-day chart.
  ///
  /// In en, this message translates to:
  /// **'Add a time to your check-ins to see when you usually train.'**
  String get statsTimeOfDayEmpty;

  /// Before 12:00.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get statsMorning;

  /// 12:00 to 17:00.
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get statsAfternoon;

  /// 17:00 to 21:00.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get statsEvening;

  /// After 21:00.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get statsNight;

  /// Most common time of day.
  ///
  /// In en, this message translates to:
  /// **'Usually: {period}'**
  String statsTypicalTime(String period);

  /// Stats screen empty state.
  ///
  /// In en, this message translates to:
  /// **'Your stats grow with every workout. Tick off today to start.'**
  String get statsEmpty;

  /// Badges section heading.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get statsBadges;

  /// Opens the badges screen.
  ///
  /// In en, this message translates to:
  /// **'See all badges'**
  String get statsSeeAllBadges;

  /// Year Dots entry card title.
  ///
  /// In en, this message translates to:
  /// **'Your year'**
  String get statsYourYear;

  /// Year Dots entry card subtitle.
  ///
  /// In en, this message translates to:
  /// **'The whole year, one dot per day.'**
  String get statsYourYearHelp;

  /// Stat tile.
  ///
  /// In en, this message translates to:
  /// **'Personal records'**
  String get statsPersonalRecords;

  /// Badge title.
  ///
  /// In en, this message translates to:
  /// **'First workout'**
  String get badgeFirstWorkout;

  /// Badge title.
  ///
  /// In en, this message translates to:
  /// **'{count}-day streak'**
  String badgeStreak(int count);

  /// Badge title.
  ///
  /// In en, this message translates to:
  /// **'First personal record'**
  String get badgeFirstPr;

  /// Badge title: first week that met its goal.
  ///
  /// In en, this message translates to:
  /// **'First full week'**
  String get badgeFirstFullWeek;

  /// Badge title.
  ///
  /// In en, this message translates to:
  /// **'{count} workouts'**
  String badgeWorkouts(int count);

  /// Locked badge progress.
  ///
  /// In en, this message translates to:
  /// **'{current} of {total}'**
  String badgeProgress(int current, int total);

  /// Next badge teaser.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 more workout to earn {badge}} other{{count} more workouts to earn {badge}}}'**
  String badgeNextWorkouts(int count, String badge);

  /// Next badge teaser.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 more streak day to earn {badge}} other{{count} more streak days to earn {badge}}}'**
  String badgeNextStreak(int count, String badge);

  /// Next badge teaser.
  ///
  /// In en, this message translates to:
  /// **'Beat one of your best lifts to earn {badge}'**
  String badgeNextPr(String badge);

  /// Next badge teaser.
  ///
  /// In en, this message translates to:
  /// **'Meet your weekly goal to earn {badge}'**
  String badgeNextWeek(String badge);

  /// Badges screen title.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get badgesTitle;

  /// Celebration after checking in today.
  ///
  /// In en, this message translates to:
  /// **'Day {count}!'**
  String celebrateCheckIn(int count);

  /// Level-up celebration.
  ///
  /// In en, this message translates to:
  /// **'Level {level}!'**
  String celebrateLevelUp(int level);

  /// Level-up message.
  ///
  /// In en, this message translates to:
  /// **'You\'re getting stronger.'**
  String get celebrateLevelUpMessage;

  /// Badge celebration.
  ///
  /// In en, this message translates to:
  /// **'Badge earned: {badge}'**
  String celebrateBadge(String badge);

  /// PR celebration.
  ///
  /// In en, this message translates to:
  /// **'New personal record!'**
  String get celebratePr;

  /// PR message.
  ///
  /// In en, this message translates to:
  /// **'That\'s a new best. Well done.'**
  String get celebratePrMessage;

  /// Weekly goal celebration.
  ///
  /// In en, this message translates to:
  /// **'Week goal met!'**
  String get celebrateWeekGoal;

  /// Onboarding weekly goal step.
  ///
  /// In en, this message translates to:
  /// **'How many days a week do you want to train?'**
  String get goalStepTitle;

  /// Onboarding weekly goal explanation.
  ///
  /// In en, this message translates to:
  /// **'Pick a goal you can keep. Sunday is your rest day, and a Sunday workout counts as a bonus.'**
  String get goalStepBody;

  /// Goal summary.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day a week} other{{count} days a week}}'**
  String goalDaysPerWeek(int count);

  /// Final onboarding celebration.
  ///
  /// In en, this message translates to:
  /// **'You\'re all set, {name}!'**
  String allSetTitle(String name);

  /// Final onboarding message.
  ///
  /// In en, this message translates to:
  /// **'Tick off each workout and watch your streak grow.'**
  String get allSetBody;

  /// Final onboarding button.
  ///
  /// In en, this message translates to:
  /// **'Let\'s go'**
  String get allSetGo;

  /// Me screen title.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get meTitle;

  /// Opens the profile editor.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get meEditProfile;

  /// Settings section heading.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get meTraining;

  /// Weekly goal setting.
  ///
  /// In en, this message translates to:
  /// **'Gym days per week'**
  String get meGymDays;

  /// Weekly goal sheet help.
  ///
  /// In en, this message translates to:
  /// **'Applies from this week. Sunday is your rest day.'**
  String get meGymDaysHelp;

  /// Reminder setting.
  ///
  /// In en, this message translates to:
  /// **'Daily reminder'**
  String get meReminder;

  /// Reminder setting help.
  ///
  /// In en, this message translates to:
  /// **'A gentle note on Monday to Saturday if you haven\'t checked in yet. Off by default.'**
  String get meReminderHelp;

  /// Reminder time setting.
  ///
  /// In en, this message translates to:
  /// **'Reminder time'**
  String get meReminderTime;

  /// Shown when notification permission is refused.
  ///
  /// In en, this message translates to:
  /// **'Notifications are off for Gymlicious. You can turn them on in system settings.'**
  String get meReminderDenied;

  /// Daily reminder notification title.
  ///
  /// In en, this message translates to:
  /// **'Ready for today?'**
  String get reminderTitle;

  /// Daily reminder notification body.
  ///
  /// In en, this message translates to:
  /// **'Tap to check in or plan your workout.'**
  String get reminderBody;

  /// Android notification channel name.
  ///
  /// In en, this message translates to:
  /// **'Daily reminder'**
  String get reminderChannel;

  /// Train shortcut to the exercise library.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get trainExercises;

  /// Train shortcut to history.
  ///
  /// In en, this message translates to:
  /// **'Past workouts'**
  String get trainPastWorkouts;

  /// Train section heading.
  ///
  /// In en, this message translates to:
  /// **'Last workout'**
  String get trainLastWorkout;

  /// Button under the quote that shows another one.
  ///
  /// In en, this message translates to:
  /// **'New quote'**
  String get quoteNew;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
