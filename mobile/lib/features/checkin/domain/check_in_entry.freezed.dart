// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'check_in_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CheckInEntry {

 CalendarDate get date; bool? get done; String get note; DayTime? get time; int? get durationMinutes; DateTime? get updatedAt;
/// Create a copy of CheckInEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckInEntryCopyWith<CheckInEntry> get copyWith => _$CheckInEntryCopyWithImpl<CheckInEntry>(this as CheckInEntry, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CheckInEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckInEntry&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.done, _this.done) || other.done == _this.done)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.time, _this.time) || other.time == _this.time)&&(identical(other.durationMinutes, _this.durationMinutes) || other.durationMinutes == _this.durationMinutes)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}


@override
int get hashCode {
  final _this = this as CheckInEntry;
  return Object.hash(runtimeType,_this.date,_this.done,_this.note,_this.time,_this.durationMinutes,_this.updatedAt);
}

@override
String toString() {
  final _this = this as CheckInEntry;
  return 'CheckInEntry(date: ${_this.date}, done: ${_this.done}, note: ${_this.note}, time: ${_this.time}, durationMinutes: ${_this.durationMinutes}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $CheckInEntryCopyWith<$Res>  {
  factory $CheckInEntryCopyWith(CheckInEntry value, $Res Function(CheckInEntry) _then) = _$CheckInEntryCopyWithImpl;
@useResult
$Res call({
 CalendarDate date, bool? done, String note, DayTime? time, int? durationMinutes, DateTime? updatedAt
});




}
/// @nodoc
class _$CheckInEntryCopyWithImpl<$Res>
    implements $CheckInEntryCopyWith<$Res> {
  _$CheckInEntryCopyWithImpl(this._self, this._then);

  final CheckInEntry _self;
  final $Res Function(CheckInEntry) _then;

/// Create a copy of CheckInEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? done = freezed,Object? note = null,Object? time = freezed,Object? durationMinutes = freezed,Object? updatedAt = freezed,}) {
  return _then(CheckInEntry(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as CalendarDate,done: freezed == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool?,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DayTime?,durationMinutes: freezed == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CheckInEntry].
extension CheckInEntryPatterns on CheckInEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CheckInEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CheckInEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CheckInEntry value)  $default,){
final _that = this;
switch (_that) {
case _CheckInEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CheckInEntry value)?  $default,){
final _that = this;
switch (_that) {
case _CheckInEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CalendarDate date,  bool? done,  String note,  DayTime? time,  int? durationMinutes,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CheckInEntry() when $default != null:
return $default(_that.date,_that.done,_that.note,_that.time,_that.durationMinutes,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CalendarDate date,  bool? done,  String note,  DayTime? time,  int? durationMinutes,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _CheckInEntry():
return $default(_that.date,_that.done,_that.note,_that.time,_that.durationMinutes,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CalendarDate date,  bool? done,  String note,  DayTime? time,  int? durationMinutes,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _CheckInEntry() when $default != null:
return $default(_that.date,_that.done,_that.note,_that.time,_that.durationMinutes,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _CheckInEntry extends CheckInEntry {
  const _CheckInEntry({required this.date, this.done, this.note = '', this.time, this.durationMinutes, this.updatedAt}): super._();
  

@override final  CalendarDate date;
@override final  bool? done;
@override@JsonKey() final  String note;
@override final  DayTime? time;
@override final  int? durationMinutes;
@override final  DateTime? updatedAt;

/// Create a copy of CheckInEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CheckInEntryCopyWith<_CheckInEntry> get copyWith => __$CheckInEntryCopyWithImpl<_CheckInEntry>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckInEntry&&(identical(other.date, date) || other.date == date)&&(identical(other.done, done) || other.done == done)&&(identical(other.note, note) || other.note == note)&&(identical(other.time, time) || other.time == time)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,date,done,note,time,durationMinutes,updatedAt);
}

@override
String toString() {
    return 'CheckInEntry(date: $date, done: $done, note: $note, time: $time, durationMinutes: $durationMinutes, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$CheckInEntryCopyWith<$Res> implements $CheckInEntryCopyWith<$Res> {
  factory _$CheckInEntryCopyWith(_CheckInEntry value, $Res Function(_CheckInEntry) _then) = __$CheckInEntryCopyWithImpl;
@override @useResult
$Res call({
 CalendarDate date, bool? done, String note, DayTime? time, int? durationMinutes, DateTime? updatedAt
});




}
/// @nodoc
class __$CheckInEntryCopyWithImpl<$Res>
    implements _$CheckInEntryCopyWith<$Res> {
  __$CheckInEntryCopyWithImpl(this._self, this._then);

  final _CheckInEntry _self;
  final $Res Function(_CheckInEntry) _then;

/// Create a copy of CheckInEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? done = freezed,Object? note = null,Object? time = freezed,Object? durationMinutes = freezed,Object? updatedAt = freezed,}) {
  return _then(_CheckInEntry(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as CalendarDate,done: freezed == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool?,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DayTime?,durationMinutes: freezed == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
