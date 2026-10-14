// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'check_in_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CheckInLog {

 Map<CalendarDate, CheckInEntry> get entries; WeeklyGoalHistory get goals;
/// Create a copy of CheckInLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckInLogCopyWith<CheckInLog> get copyWith => _$CheckInLogCopyWithImpl<CheckInLog>(this as CheckInLog, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CheckInLog;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckInLog&&const DeepCollectionEquality().equals(other.entries, _this.entries)&&(identical(other.goals, _this.goals) || other.goals == _this.goals));
}


@override
int get hashCode {
  final _this = this as CheckInLog;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.entries),_this.goals);
}

@override
String toString() {
  final _this = this as CheckInLog;
  return 'CheckInLog(entries: ${_this.entries}, goals: ${_this.goals})';
}


}

/// @nodoc
abstract mixin class $CheckInLogCopyWith<$Res>  {
  factory $CheckInLogCopyWith(CheckInLog value, $Res Function(CheckInLog) _then) = _$CheckInLogCopyWithImpl;
@useResult
$Res call({
 Map<CalendarDate, CheckInEntry> entries, WeeklyGoalHistory goals
});


$WeeklyGoalHistoryCopyWith<$Res> get goals;

}
/// @nodoc
class _$CheckInLogCopyWithImpl<$Res>
    implements $CheckInLogCopyWith<$Res> {
  _$CheckInLogCopyWithImpl(this._self, this._then);

  final CheckInLog _self;
  final $Res Function(CheckInLog) _then;

/// Create a copy of CheckInLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entries = null,Object? goals = null,}) {
  return _then(CheckInLog(
entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as Map<CalendarDate, CheckInEntry>,goals: null == goals ? _self.goals : goals // ignore: cast_nullable_to_non_nullable
as WeeklyGoalHistory,
  ));
}
/// Create a copy of CheckInLog
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeeklyGoalHistoryCopyWith<$Res> get goals {
  
  return $WeeklyGoalHistoryCopyWith<$Res>(_self.goals, (value) {
    return _then(_self.copyWith(goals: value));
  });
}
}


/// Adds pattern-matching-related methods to [CheckInLog].
extension CheckInLogPatterns on CheckInLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CheckInLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CheckInLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CheckInLog value)  $default,){
final _that = this;
switch (_that) {
case _CheckInLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CheckInLog value)?  $default,){
final _that = this;
switch (_that) {
case _CheckInLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<CalendarDate, CheckInEntry> entries,  WeeklyGoalHistory goals)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CheckInLog() when $default != null:
return $default(_that.entries,_that.goals);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<CalendarDate, CheckInEntry> entries,  WeeklyGoalHistory goals)  $default,) {final _that = this;
switch (_that) {
case _CheckInLog():
return $default(_that.entries,_that.goals);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<CalendarDate, CheckInEntry> entries,  WeeklyGoalHistory goals)?  $default,) {final _that = this;
switch (_that) {
case _CheckInLog() when $default != null:
return $default(_that.entries,_that.goals);case _:
  return null;

}
}

}

/// @nodoc


class _CheckInLog extends CheckInLog {
  const _CheckInLog({ Map<CalendarDate, CheckInEntry> entries = const <CalendarDate, CheckInEntry>{}, this.goals = const WeeklyGoalHistory()}): _entries = entries,super._();
  

 final  Map<CalendarDate, CheckInEntry> _entries;
@override@JsonKey() Map<CalendarDate, CheckInEntry> get entries {
  if (_entries is EqualUnmodifiableMapView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_entries);
}

@override@JsonKey() final  WeeklyGoalHistory goals;

/// Create a copy of CheckInLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CheckInLogCopyWith<_CheckInLog> get copyWith => __$CheckInLogCopyWithImpl<_CheckInLog>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckInLog&&const DeepCollectionEquality().equals(other.entries, _entries)&&(identical(other.goals, goals) || other.goals == goals));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_entries),goals);
}

@override
String toString() {
    return 'CheckInLog(entries: $entries, goals: $goals)';
}


}

/// @nodoc
abstract mixin class _$CheckInLogCopyWith<$Res> implements $CheckInLogCopyWith<$Res> {
  factory _$CheckInLogCopyWith(_CheckInLog value, $Res Function(_CheckInLog) _then) = __$CheckInLogCopyWithImpl;
@override @useResult
$Res call({
 Map<CalendarDate, CheckInEntry> entries, WeeklyGoalHistory goals
});


@override $WeeklyGoalHistoryCopyWith<$Res> get goals;

}
/// @nodoc
class __$CheckInLogCopyWithImpl<$Res>
    implements _$CheckInLogCopyWith<$Res> {
  __$CheckInLogCopyWithImpl(this._self, this._then);

  final _CheckInLog _self;
  final $Res Function(_CheckInLog) _then;

/// Create a copy of CheckInLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entries = null,Object? goals = null,}) {
  return _then(_CheckInLog(
entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as Map<CalendarDate, CheckInEntry>,goals: null == goals ? _self.goals : goals // ignore: cast_nullable_to_non_nullable
as WeeklyGoalHistory,
  ));
}

/// Create a copy of CheckInLog
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeeklyGoalHistoryCopyWith<$Res> get goals {
  
  return $WeeklyGoalHistoryCopyWith<$Res>(_self.goals, (value) {
    return _then(_self.copyWith(goals: value));
  });
}
}

// dart format on
