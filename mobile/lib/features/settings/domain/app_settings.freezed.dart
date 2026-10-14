// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$YearDotsSettings {

 YearDotsLayout get layout; YearDotsColorPreset get colorPreset; YearDotsTextLine get textLine; int get topMarginPercent; int get padding;
/// Create a copy of YearDotsSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$YearDotsSettingsCopyWith<YearDotsSettings> get copyWith => _$YearDotsSettingsCopyWithImpl<YearDotsSettings>(this as YearDotsSettings, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as YearDotsSettings;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is YearDotsSettings&&(identical(other.layout, _this.layout) || other.layout == _this.layout)&&(identical(other.colorPreset, _this.colorPreset) || other.colorPreset == _this.colorPreset)&&(identical(other.textLine, _this.textLine) || other.textLine == _this.textLine)&&(identical(other.topMarginPercent, _this.topMarginPercent) || other.topMarginPercent == _this.topMarginPercent)&&(identical(other.padding, _this.padding) || other.padding == _this.padding));
}


@override
int get hashCode {
  final _this = this as YearDotsSettings;
  return Object.hash(runtimeType,_this.layout,_this.colorPreset,_this.textLine,_this.topMarginPercent,_this.padding);
}

@override
String toString() {
  final _this = this as YearDotsSettings;
  return 'YearDotsSettings(layout: ${_this.layout}, colorPreset: ${_this.colorPreset}, textLine: ${_this.textLine}, topMarginPercent: ${_this.topMarginPercent}, padding: ${_this.padding})';
}


}

/// @nodoc
abstract mixin class $YearDotsSettingsCopyWith<$Res>  {
  factory $YearDotsSettingsCopyWith(YearDotsSettings value, $Res Function(YearDotsSettings) _then) = _$YearDotsSettingsCopyWithImpl;
@useResult
$Res call({
 YearDotsLayout layout, YearDotsColorPreset colorPreset, YearDotsTextLine textLine, int topMarginPercent, int padding
});




}
/// @nodoc
class _$YearDotsSettingsCopyWithImpl<$Res>
    implements $YearDotsSettingsCopyWith<$Res> {
  _$YearDotsSettingsCopyWithImpl(this._self, this._then);

  final YearDotsSettings _self;
  final $Res Function(YearDotsSettings) _then;

/// Create a copy of YearDotsSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? layout = null,Object? colorPreset = null,Object? textLine = null,Object? topMarginPercent = null,Object? padding = null,}) {
  return _then(YearDotsSettings(
layout: null == layout ? _self.layout : layout // ignore: cast_nullable_to_non_nullable
as YearDotsLayout,colorPreset: null == colorPreset ? _self.colorPreset : colorPreset // ignore: cast_nullable_to_non_nullable
as YearDotsColorPreset,textLine: null == textLine ? _self.textLine : textLine // ignore: cast_nullable_to_non_nullable
as YearDotsTextLine,topMarginPercent: null == topMarginPercent ? _self.topMarginPercent : topMarginPercent // ignore: cast_nullable_to_non_nullable
as int,padding: null == padding ? _self.padding : padding // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [YearDotsSettings].
extension YearDotsSettingsPatterns on YearDotsSettings {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _YearDotsSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _YearDotsSettings() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _YearDotsSettings value)  $default,){
final _that = this;
switch (_that) {
case _YearDotsSettings():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _YearDotsSettings value)?  $default,){
final _that = this;
switch (_that) {
case _YearDotsSettings() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( YearDotsLayout layout,  YearDotsColorPreset colorPreset,  YearDotsTextLine textLine,  int topMarginPercent,  int padding)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _YearDotsSettings() when $default != null:
return $default(_that.layout,_that.colorPreset,_that.textLine,_that.topMarginPercent,_that.padding);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( YearDotsLayout layout,  YearDotsColorPreset colorPreset,  YearDotsTextLine textLine,  int topMarginPercent,  int padding)  $default,) {final _that = this;
switch (_that) {
case _YearDotsSettings():
return $default(_that.layout,_that.colorPreset,_that.textLine,_that.topMarginPercent,_that.padding);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( YearDotsLayout layout,  YearDotsColorPreset colorPreset,  YearDotsTextLine textLine,  int topMarginPercent,  int padding)?  $default,) {final _that = this;
switch (_that) {
case _YearDotsSettings() when $default != null:
return $default(_that.layout,_that.colorPreset,_that.textLine,_that.topMarginPercent,_that.padding);case _:
  return null;

}
}

}

/// @nodoc


class _YearDotsSettings implements YearDotsSettings {
  const _YearDotsSettings({this.layout = YearDotsLayout.continuous, this.colorPreset = YearDotsColorPreset.light, this.textLine = YearDotsTextLine.leftAndPercent, this.topMarginPercent = 22, this.padding = 24});
  

@override@JsonKey() final  YearDotsLayout layout;
@override@JsonKey() final  YearDotsColorPreset colorPreset;
@override@JsonKey() final  YearDotsTextLine textLine;
@override@JsonKey() final  int topMarginPercent;
@override@JsonKey() final  int padding;

/// Create a copy of YearDotsSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$YearDotsSettingsCopyWith<_YearDotsSettings> get copyWith => __$YearDotsSettingsCopyWithImpl<_YearDotsSettings>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _YearDotsSettings&&(identical(other.layout, layout) || other.layout == layout)&&(identical(other.colorPreset, colorPreset) || other.colorPreset == colorPreset)&&(identical(other.textLine, textLine) || other.textLine == textLine)&&(identical(other.topMarginPercent, topMarginPercent) || other.topMarginPercent == topMarginPercent)&&(identical(other.padding, padding) || other.padding == padding));
}


@override
int get hashCode {
    return Object.hash(runtimeType,layout,colorPreset,textLine,topMarginPercent,padding);
}

@override
String toString() {
    return 'YearDotsSettings(layout: $layout, colorPreset: $colorPreset, textLine: $textLine, topMarginPercent: $topMarginPercent, padding: $padding)';
}


}

/// @nodoc
abstract mixin class _$YearDotsSettingsCopyWith<$Res> implements $YearDotsSettingsCopyWith<$Res> {
  factory _$YearDotsSettingsCopyWith(_YearDotsSettings value, $Res Function(_YearDotsSettings) _then) = __$YearDotsSettingsCopyWithImpl;
@override @useResult
$Res call({
 YearDotsLayout layout, YearDotsColorPreset colorPreset, YearDotsTextLine textLine, int topMarginPercent, int padding
});




}
/// @nodoc
class __$YearDotsSettingsCopyWithImpl<$Res>
    implements _$YearDotsSettingsCopyWith<$Res> {
  __$YearDotsSettingsCopyWithImpl(this._self, this._then);

  final _YearDotsSettings _self;
  final $Res Function(_YearDotsSettings) _then;

/// Create a copy of YearDotsSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? layout = null,Object? colorPreset = null,Object? textLine = null,Object? topMarginPercent = null,Object? padding = null,}) {
  return _then(_YearDotsSettings(
layout: null == layout ? _self.layout : layout // ignore: cast_nullable_to_non_nullable
as YearDotsLayout,colorPreset: null == colorPreset ? _self.colorPreset : colorPreset // ignore: cast_nullable_to_non_nullable
as YearDotsColorPreset,textLine: null == textLine ? _self.textLine : textLine // ignore: cast_nullable_to_non_nullable
as YearDotsTextLine,topMarginPercent: null == topMarginPercent ? _self.topMarginPercent : topMarginPercent // ignore: cast_nullable_to_non_nullable
as int,padding: null == padding ? _self.padding : padding // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$AppSettings {

 WeightUnit get weightUnit; HeightUnit get heightUnit; double get weightIncrement; ThemePreference get theme; QuoteMode get quoteMode; bool get isBackupReminderOn; bool get isBackupNotificationOn; DateTime? get lastBackupAt; DateTime? get backupBannerDismissedAt; String? get activeSplitId; YearDotsSettings get yearDots; bool get isCheckInReminderOn; int get checkInReminderMinutes;
/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppSettingsCopyWith<AppSettings> get copyWith => _$AppSettingsCopyWithImpl<AppSettings>(this as AppSettings, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AppSettings;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppSettings&&(identical(other.weightUnit, _this.weightUnit) || other.weightUnit == _this.weightUnit)&&(identical(other.heightUnit, _this.heightUnit) || other.heightUnit == _this.heightUnit)&&(identical(other.weightIncrement, _this.weightIncrement) || other.weightIncrement == _this.weightIncrement)&&(identical(other.theme, _this.theme) || other.theme == _this.theme)&&(identical(other.quoteMode, _this.quoteMode) || other.quoteMode == _this.quoteMode)&&(identical(other.isBackupReminderOn, _this.isBackupReminderOn) || other.isBackupReminderOn == _this.isBackupReminderOn)&&(identical(other.isBackupNotificationOn, _this.isBackupNotificationOn) || other.isBackupNotificationOn == _this.isBackupNotificationOn)&&(identical(other.lastBackupAt, _this.lastBackupAt) || other.lastBackupAt == _this.lastBackupAt)&&(identical(other.backupBannerDismissedAt, _this.backupBannerDismissedAt) || other.backupBannerDismissedAt == _this.backupBannerDismissedAt)&&(identical(other.activeSplitId, _this.activeSplitId) || other.activeSplitId == _this.activeSplitId)&&(identical(other.yearDots, _this.yearDots) || other.yearDots == _this.yearDots)&&(identical(other.isCheckInReminderOn, _this.isCheckInReminderOn) || other.isCheckInReminderOn == _this.isCheckInReminderOn)&&(identical(other.checkInReminderMinutes, _this.checkInReminderMinutes) || other.checkInReminderMinutes == _this.checkInReminderMinutes));
}


@override
int get hashCode {
  final _this = this as AppSettings;
  return Object.hash(runtimeType,_this.weightUnit,_this.heightUnit,_this.weightIncrement,_this.theme,_this.quoteMode,_this.isBackupReminderOn,_this.isBackupNotificationOn,_this.lastBackupAt,_this.backupBannerDismissedAt,_this.activeSplitId,_this.yearDots,_this.isCheckInReminderOn,_this.checkInReminderMinutes);
}

@override
String toString() {
  final _this = this as AppSettings;
  return 'AppSettings(weightUnit: ${_this.weightUnit}, heightUnit: ${_this.heightUnit}, weightIncrement: ${_this.weightIncrement}, theme: ${_this.theme}, quoteMode: ${_this.quoteMode}, isBackupReminderOn: ${_this.isBackupReminderOn}, isBackupNotificationOn: ${_this.isBackupNotificationOn}, lastBackupAt: ${_this.lastBackupAt}, backupBannerDismissedAt: ${_this.backupBannerDismissedAt}, activeSplitId: ${_this.activeSplitId}, yearDots: ${_this.yearDots}, isCheckInReminderOn: ${_this.isCheckInReminderOn}, checkInReminderMinutes: ${_this.checkInReminderMinutes})';
}


}

/// @nodoc
abstract mixin class $AppSettingsCopyWith<$Res>  {
  factory $AppSettingsCopyWith(AppSettings value, $Res Function(AppSettings) _then) = _$AppSettingsCopyWithImpl;
@useResult
$Res call({
 WeightUnit weightUnit, HeightUnit heightUnit, double weightIncrement, ThemePreference theme, QuoteMode quoteMode, bool isBackupReminderOn, bool isBackupNotificationOn, DateTime? lastBackupAt, DateTime? backupBannerDismissedAt, String? activeSplitId, YearDotsSettings yearDots, bool isCheckInReminderOn, int checkInReminderMinutes
});


$YearDotsSettingsCopyWith<$Res> get yearDots;

}
/// @nodoc
class _$AppSettingsCopyWithImpl<$Res>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._self, this._then);

  final AppSettings _self;
  final $Res Function(AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? weightUnit = null,Object? heightUnit = null,Object? weightIncrement = null,Object? theme = null,Object? quoteMode = null,Object? isBackupReminderOn = null,Object? isBackupNotificationOn = null,Object? lastBackupAt = freezed,Object? backupBannerDismissedAt = freezed,Object? activeSplitId = freezed,Object? yearDots = null,Object? isCheckInReminderOn = null,Object? checkInReminderMinutes = null,}) {
  return _then(AppSettings(
weightUnit: null == weightUnit ? _self.weightUnit : weightUnit // ignore: cast_nullable_to_non_nullable
as WeightUnit,heightUnit: null == heightUnit ? _self.heightUnit : heightUnit // ignore: cast_nullable_to_non_nullable
as HeightUnit,weightIncrement: null == weightIncrement ? _self.weightIncrement : weightIncrement // ignore: cast_nullable_to_non_nullable
as double,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as ThemePreference,quoteMode: null == quoteMode ? _self.quoteMode : quoteMode // ignore: cast_nullable_to_non_nullable
as QuoteMode,isBackupReminderOn: null == isBackupReminderOn ? _self.isBackupReminderOn : isBackupReminderOn // ignore: cast_nullable_to_non_nullable
as bool,isBackupNotificationOn: null == isBackupNotificationOn ? _self.isBackupNotificationOn : isBackupNotificationOn // ignore: cast_nullable_to_non_nullable
as bool,lastBackupAt: freezed == lastBackupAt ? _self.lastBackupAt : lastBackupAt // ignore: cast_nullable_to_non_nullable
as DateTime?,backupBannerDismissedAt: freezed == backupBannerDismissedAt ? _self.backupBannerDismissedAt : backupBannerDismissedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,activeSplitId: freezed == activeSplitId ? _self.activeSplitId : activeSplitId // ignore: cast_nullable_to_non_nullable
as String?,yearDots: null == yearDots ? _self.yearDots : yearDots // ignore: cast_nullable_to_non_nullable
as YearDotsSettings,isCheckInReminderOn: null == isCheckInReminderOn ? _self.isCheckInReminderOn : isCheckInReminderOn // ignore: cast_nullable_to_non_nullable
as bool,checkInReminderMinutes: null == checkInReminderMinutes ? _self.checkInReminderMinutes : checkInReminderMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$YearDotsSettingsCopyWith<$Res> get yearDots {
  
  return $YearDotsSettingsCopyWith<$Res>(_self.yearDots, (value) {
    return _then(_self.copyWith(yearDots: value));
  });
}
}


/// Adds pattern-matching-related methods to [AppSettings].
extension AppSettingsPatterns on AppSettings {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppSettings value)  $default,){
final _that = this;
switch (_that) {
case _AppSettings():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppSettings value)?  $default,){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( WeightUnit weightUnit,  HeightUnit heightUnit,  double weightIncrement,  ThemePreference theme,  QuoteMode quoteMode,  bool isBackupReminderOn,  bool isBackupNotificationOn,  DateTime? lastBackupAt,  DateTime? backupBannerDismissedAt,  String? activeSplitId,  YearDotsSettings yearDots,  bool isCheckInReminderOn,  int checkInReminderMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.weightUnit,_that.heightUnit,_that.weightIncrement,_that.theme,_that.quoteMode,_that.isBackupReminderOn,_that.isBackupNotificationOn,_that.lastBackupAt,_that.backupBannerDismissedAt,_that.activeSplitId,_that.yearDots,_that.isCheckInReminderOn,_that.checkInReminderMinutes);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( WeightUnit weightUnit,  HeightUnit heightUnit,  double weightIncrement,  ThemePreference theme,  QuoteMode quoteMode,  bool isBackupReminderOn,  bool isBackupNotificationOn,  DateTime? lastBackupAt,  DateTime? backupBannerDismissedAt,  String? activeSplitId,  YearDotsSettings yearDots,  bool isCheckInReminderOn,  int checkInReminderMinutes)  $default,) {final _that = this;
switch (_that) {
case _AppSettings():
return $default(_that.weightUnit,_that.heightUnit,_that.weightIncrement,_that.theme,_that.quoteMode,_that.isBackupReminderOn,_that.isBackupNotificationOn,_that.lastBackupAt,_that.backupBannerDismissedAt,_that.activeSplitId,_that.yearDots,_that.isCheckInReminderOn,_that.checkInReminderMinutes);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( WeightUnit weightUnit,  HeightUnit heightUnit,  double weightIncrement,  ThemePreference theme,  QuoteMode quoteMode,  bool isBackupReminderOn,  bool isBackupNotificationOn,  DateTime? lastBackupAt,  DateTime? backupBannerDismissedAt,  String? activeSplitId,  YearDotsSettings yearDots,  bool isCheckInReminderOn,  int checkInReminderMinutes)?  $default,) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.weightUnit,_that.heightUnit,_that.weightIncrement,_that.theme,_that.quoteMode,_that.isBackupReminderOn,_that.isBackupNotificationOn,_that.lastBackupAt,_that.backupBannerDismissedAt,_that.activeSplitId,_that.yearDots,_that.isCheckInReminderOn,_that.checkInReminderMinutes);case _:
  return null;

}
}

}

/// @nodoc


class _AppSettings extends AppSettings {
  const _AppSettings({this.weightUnit = WeightUnit.kg, this.heightUnit = HeightUnit.cm, this.weightIncrement = 2.5, this.theme = ThemePreference.system, this.quoteMode = QuoteMode.mix, this.isBackupReminderOn = true, this.isBackupNotificationOn = false, this.lastBackupAt, this.backupBannerDismissedAt, this.activeSplitId, this.yearDots = const YearDotsSettings(), this.isCheckInReminderOn = false, this.checkInReminderMinutes = AppSettings.defaultReminderMinutes}): super._();
  

@override@JsonKey() final  WeightUnit weightUnit;
@override@JsonKey() final  HeightUnit heightUnit;
@override@JsonKey() final  double weightIncrement;
@override@JsonKey() final  ThemePreference theme;
@override@JsonKey() final  QuoteMode quoteMode;
@override@JsonKey() final  bool isBackupReminderOn;
@override@JsonKey() final  bool isBackupNotificationOn;
@override final  DateTime? lastBackupAt;
@override final  DateTime? backupBannerDismissedAt;
@override final  String? activeSplitId;
@override@JsonKey() final  YearDotsSettings yearDots;
@override@JsonKey() final  bool isCheckInReminderOn;
@override@JsonKey() final  int checkInReminderMinutes;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppSettingsCopyWith<_AppSettings> get copyWith => __$AppSettingsCopyWithImpl<_AppSettings>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppSettings&&(identical(other.weightUnit, weightUnit) || other.weightUnit == weightUnit)&&(identical(other.heightUnit, heightUnit) || other.heightUnit == heightUnit)&&(identical(other.weightIncrement, weightIncrement) || other.weightIncrement == weightIncrement)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.quoteMode, quoteMode) || other.quoteMode == quoteMode)&&(identical(other.isBackupReminderOn, isBackupReminderOn) || other.isBackupReminderOn == isBackupReminderOn)&&(identical(other.isBackupNotificationOn, isBackupNotificationOn) || other.isBackupNotificationOn == isBackupNotificationOn)&&(identical(other.lastBackupAt, lastBackupAt) || other.lastBackupAt == lastBackupAt)&&(identical(other.backupBannerDismissedAt, backupBannerDismissedAt) || other.backupBannerDismissedAt == backupBannerDismissedAt)&&(identical(other.activeSplitId, activeSplitId) || other.activeSplitId == activeSplitId)&&(identical(other.yearDots, yearDots) || other.yearDots == yearDots)&&(identical(other.isCheckInReminderOn, isCheckInReminderOn) || other.isCheckInReminderOn == isCheckInReminderOn)&&(identical(other.checkInReminderMinutes, checkInReminderMinutes) || other.checkInReminderMinutes == checkInReminderMinutes));
}


@override
int get hashCode {
    return Object.hash(runtimeType,weightUnit,heightUnit,weightIncrement,theme,quoteMode,isBackupReminderOn,isBackupNotificationOn,lastBackupAt,backupBannerDismissedAt,activeSplitId,yearDots,isCheckInReminderOn,checkInReminderMinutes);
}

@override
String toString() {
    return 'AppSettings(weightUnit: $weightUnit, heightUnit: $heightUnit, weightIncrement: $weightIncrement, theme: $theme, quoteMode: $quoteMode, isBackupReminderOn: $isBackupReminderOn, isBackupNotificationOn: $isBackupNotificationOn, lastBackupAt: $lastBackupAt, backupBannerDismissedAt: $backupBannerDismissedAt, activeSplitId: $activeSplitId, yearDots: $yearDots, isCheckInReminderOn: $isCheckInReminderOn, checkInReminderMinutes: $checkInReminderMinutes)';
}


}

/// @nodoc
abstract mixin class _$AppSettingsCopyWith<$Res> implements $AppSettingsCopyWith<$Res> {
  factory _$AppSettingsCopyWith(_AppSettings value, $Res Function(_AppSettings) _then) = __$AppSettingsCopyWithImpl;
@override @useResult
$Res call({
 WeightUnit weightUnit, HeightUnit heightUnit, double weightIncrement, ThemePreference theme, QuoteMode quoteMode, bool isBackupReminderOn, bool isBackupNotificationOn, DateTime? lastBackupAt, DateTime? backupBannerDismissedAt, String? activeSplitId, YearDotsSettings yearDots, bool isCheckInReminderOn, int checkInReminderMinutes
});


@override $YearDotsSettingsCopyWith<$Res> get yearDots;

}
/// @nodoc
class __$AppSettingsCopyWithImpl<$Res>
    implements _$AppSettingsCopyWith<$Res> {
  __$AppSettingsCopyWithImpl(this._self, this._then);

  final _AppSettings _self;
  final $Res Function(_AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weightUnit = null,Object? heightUnit = null,Object? weightIncrement = null,Object? theme = null,Object? quoteMode = null,Object? isBackupReminderOn = null,Object? isBackupNotificationOn = null,Object? lastBackupAt = freezed,Object? backupBannerDismissedAt = freezed,Object? activeSplitId = freezed,Object? yearDots = null,Object? isCheckInReminderOn = null,Object? checkInReminderMinutes = null,}) {
  return _then(_AppSettings(
weightUnit: null == weightUnit ? _self.weightUnit : weightUnit // ignore: cast_nullable_to_non_nullable
as WeightUnit,heightUnit: null == heightUnit ? _self.heightUnit : heightUnit // ignore: cast_nullable_to_non_nullable
as HeightUnit,weightIncrement: null == weightIncrement ? _self.weightIncrement : weightIncrement // ignore: cast_nullable_to_non_nullable
as double,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as ThemePreference,quoteMode: null == quoteMode ? _self.quoteMode : quoteMode // ignore: cast_nullable_to_non_nullable
as QuoteMode,isBackupReminderOn: null == isBackupReminderOn ? _self.isBackupReminderOn : isBackupReminderOn // ignore: cast_nullable_to_non_nullable
as bool,isBackupNotificationOn: null == isBackupNotificationOn ? _self.isBackupNotificationOn : isBackupNotificationOn // ignore: cast_nullable_to_non_nullable
as bool,lastBackupAt: freezed == lastBackupAt ? _self.lastBackupAt : lastBackupAt // ignore: cast_nullable_to_non_nullable
as DateTime?,backupBannerDismissedAt: freezed == backupBannerDismissedAt ? _self.backupBannerDismissedAt : backupBannerDismissedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,activeSplitId: freezed == activeSplitId ? _self.activeSplitId : activeSplitId // ignore: cast_nullable_to_non_nullable
as String?,yearDots: null == yearDots ? _self.yearDots : yearDots // ignore: cast_nullable_to_non_nullable
as YearDotsSettings,isCheckInReminderOn: null == isCheckInReminderOn ? _self.isCheckInReminderOn : isCheckInReminderOn // ignore: cast_nullable_to_non_nullable
as bool,checkInReminderMinutes: null == checkInReminderMinutes ? _self.checkInReminderMinutes : checkInReminderMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$YearDotsSettingsCopyWith<$Res> get yearDots {
  
  return $YearDotsSettingsCopyWith<$Res>(_self.yearDots, (value) {
    return _then(_self.copyWith(yearDots: value));
  });
}
}

// dart format on
