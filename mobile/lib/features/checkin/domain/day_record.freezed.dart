// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'day_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DayRecord {

 CalendarDate get date; bool get isDone; bool get hasSession; String get note; DayTime? get time; int? get durationMinutes;
/// Create a copy of DayRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DayRecordCopyWith<DayRecord> get copyWith => _$DayRecordCopyWithImpl<DayRecord>(this as DayRecord, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DayRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DayRecord&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.isDone, _this.isDone) || other.isDone == _this.isDone)&&(identical(other.hasSession, _this.hasSession) || other.hasSession == _this.hasSession)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.time, _this.time) || other.time == _this.time)&&(identical(other.durationMinutes, _this.durationMinutes) || other.durationMinutes == _this.durationMinutes));
}


@override
int get hashCode {
  final _this = this as DayRecord;
  return Object.hash(runtimeType,_this.date,_this.isDone,_this.hasSession,_this.note,_this.time,_this.durationMinutes);
}

@override
String toString() {
  final _this = this as DayRecord;
  return 'DayRecord(date: ${_this.date}, isDone: ${_this.isDone}, hasSession: ${_this.hasSession}, note: ${_this.note}, time: ${_this.time}, durationMinutes: ${_this.durationMinutes})';
}


}

/// @nodoc
abstract mixin class $DayRecordCopyWith<$Res>  {
  factory $DayRecordCopyWith(DayRecord value, $Res Function(DayRecord) _then) = _$DayRecordCopyWithImpl;
@useResult
$Res call({
 CalendarDate date, bool isDone, bool hasSession, String note, DayTime? time, int? durationMinutes
});




}
/// @nodoc
class _$DayRecordCopyWithImpl<$Res>
    implements $DayRecordCopyWith<$Res> {
  _$DayRecordCopyWithImpl(this._self, this._then);

  final DayRecord _self;
  final $Res Function(DayRecord) _then;

/// Create a copy of DayRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? isDone = null,Object? hasSession = null,Object? note = null,Object? time = freezed,Object? durationMinutes = freezed,}) {
  return _then(DayRecord(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as CalendarDate,isDone: null == isDone ? _self.isDone : isDone // ignore: cast_nullable_to_non_nullable
as bool,hasSession: null == hasSession ? _self.hasSession : hasSession // ignore: cast_nullable_to_non_nullable
as bool,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DayTime?,durationMinutes: freezed == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [DayRecord].
extension DayRecordPatterns on DayRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DayRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DayRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DayRecord value)  $default,){
final _that = this;
switch (_that) {
case _DayRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DayRecord value)?  $default,){
final _that = this;
switch (_that) {
case _DayRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CalendarDate date,  bool isDone,  bool hasSession,  String note,  DayTime? time,  int? durationMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DayRecord() when $default != null:
return $default(_that.date,_that.isDone,_that.hasSession,_that.note,_that.time,_that.durationMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CalendarDate date,  bool isDone,  bool hasSession,  String note,  DayTime? time,  int? durationMinutes)  $default,) {final _that = this;
switch (_that) {
case _DayRecord():
return $default(_that.date,_that.isDone,_that.hasSession,_that.note,_that.time,_that.durationMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CalendarDate date,  bool isDone,  bool hasSession,  String note,  DayTime? time,  int? durationMinutes)?  $default,) {final _that = this;
switch (_that) {
case _DayRecord() when $default != null:
return $default(_that.date,_that.isDone,_that.hasSession,_that.note,_that.time,_that.durationMinutes);case _:
  return null;

}
}

}

/// @nodoc


class _DayRecord extends DayRecord {
  const _DayRecord({required this.date, required this.isDone, required this.hasSession, this.note = '', this.time, this.durationMinutes}): super._();
  

@override final  CalendarDate date;
@override final  bool isDone;
@override final  bool hasSession;
@override@JsonKey() final  String note;
@override final  DayTime? time;
@override final  int? durationMinutes;

/// Create a copy of DayRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DayRecordCopyWith<_DayRecord> get copyWith => __$DayRecordCopyWithImpl<_DayRecord>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DayRecord&&(identical(other.date, date) || other.date == date)&&(identical(other.isDone, isDone) || other.isDone == isDone)&&(identical(other.hasSession, hasSession) || other.hasSession == hasSession)&&(identical(other.note, note) || other.note == note)&&(identical(other.time, time) || other.time == time)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes));
}


@override
int get hashCode {
    return Object.hash(runtimeType,date,isDone,hasSession,note,time,durationMinutes);
}

@override
String toString() {
    return 'DayRecord(date: $date, isDone: $isDone, hasSession: $hasSession, note: $note, time: $time, durationMinutes: $durationMinutes)';
}


}

/// @nodoc
abstract mixin class _$DayRecordCopyWith<$Res> implements $DayRecordCopyWith<$Res> {
  factory _$DayRecordCopyWith(_DayRecord value, $Res Function(_DayRecord) _then) = __$DayRecordCopyWithImpl;
@override @useResult
$Res call({
 CalendarDate date, bool isDone, bool hasSession, String note, DayTime? time, int? durationMinutes
});




}
/// @nodoc
class __$DayRecordCopyWithImpl<$Res>
    implements _$DayRecordCopyWith<$Res> {
  __$DayRecordCopyWithImpl(this._self, this._then);

  final _DayRecord _self;
  final $Res Function(_DayRecord) _then;

/// Create a copy of DayRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? isDone = null,Object? hasSession = null,Object? note = null,Object? time = freezed,Object? durationMinutes = freezed,}) {
  return _then(_DayRecord(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as CalendarDate,isDone: null == isDone ? _self.isDone : isDone // ignore: cast_nullable_to_non_nullable
as bool,hasSession: null == hasSession ? _self.hasSession : hasSession // ignore: cast_nullable_to_non_nullable
as bool,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DayTime?,durationMinutes: freezed == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
