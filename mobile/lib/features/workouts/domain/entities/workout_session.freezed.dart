// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SessionEntry {

 String get exerciseId; String get exerciseName; List<WorkoutSet> get sets; String get note;
/// Create a copy of SessionEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionEntryCopyWith<SessionEntry> get copyWith => _$SessionEntryCopyWithImpl<SessionEntry>(this as SessionEntry, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SessionEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionEntry&&(identical(other.exerciseId, _this.exerciseId) || other.exerciseId == _this.exerciseId)&&(identical(other.exerciseName, _this.exerciseName) || other.exerciseName == _this.exerciseName)&&const DeepCollectionEquality().equals(other.sets, _this.sets)&&(identical(other.note, _this.note) || other.note == _this.note));
}


@override
int get hashCode {
  final _this = this as SessionEntry;
  return Object.hash(runtimeType,_this.exerciseId,_this.exerciseName,const DeepCollectionEquality().hash(_this.sets),_this.note);
}

@override
String toString() {
  final _this = this as SessionEntry;
  return 'SessionEntry(exerciseId: ${_this.exerciseId}, exerciseName: ${_this.exerciseName}, sets: ${_this.sets}, note: ${_this.note})';
}


}

/// @nodoc
abstract mixin class $SessionEntryCopyWith<$Res>  {
  factory $SessionEntryCopyWith(SessionEntry value, $Res Function(SessionEntry) _then) = _$SessionEntryCopyWithImpl;
@useResult
$Res call({
 String exerciseId, String exerciseName, List<WorkoutSet> sets, String note
});




}
/// @nodoc
class _$SessionEntryCopyWithImpl<$Res>
    implements $SessionEntryCopyWith<$Res> {
  _$SessionEntryCopyWithImpl(this._self, this._then);

  final SessionEntry _self;
  final $Res Function(SessionEntry) _then;

/// Create a copy of SessionEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? exerciseId = null,Object? exerciseName = null,Object? sets = null,Object? note = null,}) {
  return _then(SessionEntry(
exerciseId: null == exerciseId ? _self.exerciseId : exerciseId // ignore: cast_nullable_to_non_nullable
as String,exerciseName: null == exerciseName ? _self.exerciseName : exerciseName // ignore: cast_nullable_to_non_nullable
as String,sets: null == sets ? _self.sets : sets // ignore: cast_nullable_to_non_nullable
as List<WorkoutSet>,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionEntry].
extension SessionEntryPatterns on SessionEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionEntry value)  $default,){
final _that = this;
switch (_that) {
case _SessionEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionEntry value)?  $default,){
final _that = this;
switch (_that) {
case _SessionEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String exerciseId,  String exerciseName,  List<WorkoutSet> sets,  String note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionEntry() when $default != null:
return $default(_that.exerciseId,_that.exerciseName,_that.sets,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String exerciseId,  String exerciseName,  List<WorkoutSet> sets,  String note)  $default,) {final _that = this;
switch (_that) {
case _SessionEntry():
return $default(_that.exerciseId,_that.exerciseName,_that.sets,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String exerciseId,  String exerciseName,  List<WorkoutSet> sets,  String note)?  $default,) {final _that = this;
switch (_that) {
case _SessionEntry() when $default != null:
return $default(_that.exerciseId,_that.exerciseName,_that.sets,_that.note);case _:
  return null;

}
}

}

/// @nodoc


class _SessionEntry extends SessionEntry {
  const _SessionEntry({required this.exerciseId, required this.exerciseName,  List<WorkoutSet> sets = const <WorkoutSet>[], this.note = ''}): _sets = sets,super._();
  

@override final  String exerciseId;
@override final  String exerciseName;
 final  List<WorkoutSet> _sets;
@override@JsonKey() List<WorkoutSet> get sets {
  if (_sets is EqualUnmodifiableListView) return _sets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sets);
}

@override@JsonKey() final  String note;

/// Create a copy of SessionEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionEntryCopyWith<_SessionEntry> get copyWith => __$SessionEntryCopyWithImpl<_SessionEntry>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionEntry&&(identical(other.exerciseId, exerciseId) || other.exerciseId == exerciseId)&&(identical(other.exerciseName, exerciseName) || other.exerciseName == exerciseName)&&const DeepCollectionEquality().equals(other.sets, _sets)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode {
    return Object.hash(runtimeType,exerciseId,exerciseName,const DeepCollectionEquality().hash(_sets),note);
}

@override
String toString() {
    return 'SessionEntry(exerciseId: $exerciseId, exerciseName: $exerciseName, sets: $sets, note: $note)';
}


}

/// @nodoc
abstract mixin class _$SessionEntryCopyWith<$Res> implements $SessionEntryCopyWith<$Res> {
  factory _$SessionEntryCopyWith(_SessionEntry value, $Res Function(_SessionEntry) _then) = __$SessionEntryCopyWithImpl;
@override @useResult
$Res call({
 String exerciseId, String exerciseName, List<WorkoutSet> sets, String note
});




}
/// @nodoc
class __$SessionEntryCopyWithImpl<$Res>
    implements _$SessionEntryCopyWith<$Res> {
  __$SessionEntryCopyWithImpl(this._self, this._then);

  final _SessionEntry _self;
  final $Res Function(_SessionEntry) _then;

/// Create a copy of SessionEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? exerciseId = null,Object? exerciseName = null,Object? sets = null,Object? note = null,}) {
  return _then(_SessionEntry(
exerciseId: null == exerciseId ? _self.exerciseId : exerciseId // ignore: cast_nullable_to_non_nullable
as String,exerciseName: null == exerciseName ? _self.exerciseName : exerciseName // ignore: cast_nullable_to_non_nullable
as String,sets: null == sets ? _self._sets : sets // ignore: cast_nullable_to_non_nullable
as List<WorkoutSet>,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$WorkoutSession {

 String get id; DateTime get startedAt; DateTime? get endedAt; String? get splitId; String? get dayId; String? get dayName; List<SessionEntry> get entries; String get note;
/// Create a copy of WorkoutSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutSessionCopyWith<WorkoutSession> get copyWith => _$WorkoutSessionCopyWithImpl<WorkoutSession>(this as WorkoutSession, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as WorkoutSession;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkoutSession&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt)&&(identical(other.endedAt, _this.endedAt) || other.endedAt == _this.endedAt)&&(identical(other.splitId, _this.splitId) || other.splitId == _this.splitId)&&(identical(other.dayId, _this.dayId) || other.dayId == _this.dayId)&&(identical(other.dayName, _this.dayName) || other.dayName == _this.dayName)&&const DeepCollectionEquality().equals(other.entries, _this.entries)&&(identical(other.note, _this.note) || other.note == _this.note));
}


@override
int get hashCode {
  final _this = this as WorkoutSession;
  return Object.hash(runtimeType,_this.id,_this.startedAt,_this.endedAt,_this.splitId,_this.dayId,_this.dayName,const DeepCollectionEquality().hash(_this.entries),_this.note);
}

@override
String toString() {
  final _this = this as WorkoutSession;
  return 'WorkoutSession(id: ${_this.id}, startedAt: ${_this.startedAt}, endedAt: ${_this.endedAt}, splitId: ${_this.splitId}, dayId: ${_this.dayId}, dayName: ${_this.dayName}, entries: ${_this.entries}, note: ${_this.note})';
}


}

/// @nodoc
abstract mixin class $WorkoutSessionCopyWith<$Res>  {
  factory $WorkoutSessionCopyWith(WorkoutSession value, $Res Function(WorkoutSession) _then) = _$WorkoutSessionCopyWithImpl;
@useResult
$Res call({
 String id, DateTime startedAt, DateTime? endedAt, String? splitId, String? dayId, String? dayName, List<SessionEntry> entries, String note
});




}
/// @nodoc
class _$WorkoutSessionCopyWithImpl<$Res>
    implements $WorkoutSessionCopyWith<$Res> {
  _$WorkoutSessionCopyWithImpl(this._self, this._then);

  final WorkoutSession _self;
  final $Res Function(WorkoutSession) _then;

/// Create a copy of WorkoutSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? startedAt = null,Object? endedAt = freezed,Object? splitId = freezed,Object? dayId = freezed,Object? dayName = freezed,Object? entries = null,Object? note = null,}) {
  return _then(WorkoutSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,splitId: freezed == splitId ? _self.splitId : splitId // ignore: cast_nullable_to_non_nullable
as String?,dayId: freezed == dayId ? _self.dayId : dayId // ignore: cast_nullable_to_non_nullable
as String?,dayName: freezed == dayName ? _self.dayName : dayName // ignore: cast_nullable_to_non_nullable
as String?,entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<SessionEntry>,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkoutSession].
extension WorkoutSessionPatterns on WorkoutSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkoutSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkoutSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkoutSession value)  $default,){
final _that = this;
switch (_that) {
case _WorkoutSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkoutSession value)?  $default,){
final _that = this;
switch (_that) {
case _WorkoutSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime startedAt,  DateTime? endedAt,  String? splitId,  String? dayId,  String? dayName,  List<SessionEntry> entries,  String note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkoutSession() when $default != null:
return $default(_that.id,_that.startedAt,_that.endedAt,_that.splitId,_that.dayId,_that.dayName,_that.entries,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime startedAt,  DateTime? endedAt,  String? splitId,  String? dayId,  String? dayName,  List<SessionEntry> entries,  String note)  $default,) {final _that = this;
switch (_that) {
case _WorkoutSession():
return $default(_that.id,_that.startedAt,_that.endedAt,_that.splitId,_that.dayId,_that.dayName,_that.entries,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime startedAt,  DateTime? endedAt,  String? splitId,  String? dayId,  String? dayName,  List<SessionEntry> entries,  String note)?  $default,) {final _that = this;
switch (_that) {
case _WorkoutSession() when $default != null:
return $default(_that.id,_that.startedAt,_that.endedAt,_that.splitId,_that.dayId,_that.dayName,_that.entries,_that.note);case _:
  return null;

}
}

}

/// @nodoc


class _WorkoutSession extends WorkoutSession {
  const _WorkoutSession({required this.id, required this.startedAt, this.endedAt, this.splitId, this.dayId, this.dayName,  List<SessionEntry> entries = const <SessionEntry>[], this.note = ''}): _entries = entries,super._();
  

@override final  String id;
@override final  DateTime startedAt;
@override final  DateTime? endedAt;
@override final  String? splitId;
@override final  String? dayId;
@override final  String? dayName;
 final  List<SessionEntry> _entries;
@override@JsonKey() List<SessionEntry> get entries {
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entries);
}

@override@JsonKey() final  String note;

/// Create a copy of WorkoutSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkoutSessionCopyWith<_WorkoutSession> get copyWith => __$WorkoutSessionCopyWithImpl<_WorkoutSession>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkoutSession&&(identical(other.id, id) || other.id == id)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.splitId, splitId) || other.splitId == splitId)&&(identical(other.dayId, dayId) || other.dayId == dayId)&&(identical(other.dayName, dayName) || other.dayName == dayName)&&const DeepCollectionEquality().equals(other.entries, _entries)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,startedAt,endedAt,splitId,dayId,dayName,const DeepCollectionEquality().hash(_entries),note);
}

@override
String toString() {
    return 'WorkoutSession(id: $id, startedAt: $startedAt, endedAt: $endedAt, splitId: $splitId, dayId: $dayId, dayName: $dayName, entries: $entries, note: $note)';
}


}

/// @nodoc
abstract mixin class _$WorkoutSessionCopyWith<$Res> implements $WorkoutSessionCopyWith<$Res> {
  factory _$WorkoutSessionCopyWith(_WorkoutSession value, $Res Function(_WorkoutSession) _then) = __$WorkoutSessionCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime startedAt, DateTime? endedAt, String? splitId, String? dayId, String? dayName, List<SessionEntry> entries, String note
});




}
/// @nodoc
class __$WorkoutSessionCopyWithImpl<$Res>
    implements _$WorkoutSessionCopyWith<$Res> {
  __$WorkoutSessionCopyWithImpl(this._self, this._then);

  final _WorkoutSession _self;
  final $Res Function(_WorkoutSession) _then;

/// Create a copy of WorkoutSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? startedAt = null,Object? endedAt = freezed,Object? splitId = freezed,Object? dayId = freezed,Object? dayName = freezed,Object? entries = null,Object? note = null,}) {
  return _then(_WorkoutSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,splitId: freezed == splitId ? _self.splitId : splitId // ignore: cast_nullable_to_non_nullable
as String?,dayId: freezed == dayId ? _self.dayId : dayId // ignore: cast_nullable_to_non_nullable
as String?,dayName: freezed == dayName ? _self.dayName : dayName // ignore: cast_nullable_to_non_nullable
as String?,entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<SessionEntry>,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
