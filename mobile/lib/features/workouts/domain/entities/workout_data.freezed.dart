// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WorkoutData {

 List<Exercise> get exercises; List<WorkoutSplit> get splits; List<WorkoutSession> get sessions; WorkoutSession? get activeSession;
/// Create a copy of WorkoutData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutDataCopyWith<WorkoutData> get copyWith => _$WorkoutDataCopyWithImpl<WorkoutData>(this as WorkoutData, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as WorkoutData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkoutData&&const DeepCollectionEquality().equals(other.exercises, _this.exercises)&&const DeepCollectionEquality().equals(other.splits, _this.splits)&&const DeepCollectionEquality().equals(other.sessions, _this.sessions)&&(identical(other.activeSession, _this.activeSession) || other.activeSession == _this.activeSession));
}


@override
int get hashCode {
  final _this = this as WorkoutData;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.exercises),const DeepCollectionEquality().hash(_this.splits),const DeepCollectionEquality().hash(_this.sessions),_this.activeSession);
}

@override
String toString() {
  final _this = this as WorkoutData;
  return 'WorkoutData(exercises: ${_this.exercises}, splits: ${_this.splits}, sessions: ${_this.sessions}, activeSession: ${_this.activeSession})';
}


}

/// @nodoc
abstract mixin class $WorkoutDataCopyWith<$Res>  {
  factory $WorkoutDataCopyWith(WorkoutData value, $Res Function(WorkoutData) _then) = _$WorkoutDataCopyWithImpl;
@useResult
$Res call({
 List<Exercise> exercises, List<WorkoutSplit> splits, List<WorkoutSession> sessions, WorkoutSession? activeSession
});


$WorkoutSessionCopyWith<$Res>? get activeSession;

}
/// @nodoc
class _$WorkoutDataCopyWithImpl<$Res>
    implements $WorkoutDataCopyWith<$Res> {
  _$WorkoutDataCopyWithImpl(this._self, this._then);

  final WorkoutData _self;
  final $Res Function(WorkoutData) _then;

/// Create a copy of WorkoutData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? exercises = null,Object? splits = null,Object? sessions = null,Object? activeSession = freezed,}) {
  return _then(WorkoutData(
exercises: null == exercises ? _self.exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<Exercise>,splits: null == splits ? _self.splits : splits // ignore: cast_nullable_to_non_nullable
as List<WorkoutSplit>,sessions: null == sessions ? _self.sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<WorkoutSession>,activeSession: freezed == activeSession ? _self.activeSession : activeSession // ignore: cast_nullable_to_non_nullable
as WorkoutSession?,
  ));
}
/// Create a copy of WorkoutData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkoutSessionCopyWith<$Res>? get activeSession {
    if (_self.activeSession == null) {
    return null;
  }

  return $WorkoutSessionCopyWith<$Res>(_self.activeSession!, (value) {
    return _then(_self.copyWith(activeSession: value));
  });
}
}


/// Adds pattern-matching-related methods to [WorkoutData].
extension WorkoutDataPatterns on WorkoutData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkoutData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkoutData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkoutData value)  $default,){
final _that = this;
switch (_that) {
case _WorkoutData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkoutData value)?  $default,){
final _that = this;
switch (_that) {
case _WorkoutData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Exercise> exercises,  List<WorkoutSplit> splits,  List<WorkoutSession> sessions,  WorkoutSession? activeSession)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkoutData() when $default != null:
return $default(_that.exercises,_that.splits,_that.sessions,_that.activeSession);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Exercise> exercises,  List<WorkoutSplit> splits,  List<WorkoutSession> sessions,  WorkoutSession? activeSession)  $default,) {final _that = this;
switch (_that) {
case _WorkoutData():
return $default(_that.exercises,_that.splits,_that.sessions,_that.activeSession);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Exercise> exercises,  List<WorkoutSplit> splits,  List<WorkoutSession> sessions,  WorkoutSession? activeSession)?  $default,) {final _that = this;
switch (_that) {
case _WorkoutData() when $default != null:
return $default(_that.exercises,_that.splits,_that.sessions,_that.activeSession);case _:
  return null;

}
}

}

/// @nodoc


class _WorkoutData extends WorkoutData {
  const _WorkoutData({ List<Exercise> exercises = const <Exercise>[],  List<WorkoutSplit> splits = const <WorkoutSplit>[],  List<WorkoutSession> sessions = const <WorkoutSession>[], this.activeSession}): _exercises = exercises,_splits = splits,_sessions = sessions,super._();
  

 final  List<Exercise> _exercises;
@override@JsonKey() List<Exercise> get exercises {
  if (_exercises is EqualUnmodifiableListView) return _exercises;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exercises);
}

 final  List<WorkoutSplit> _splits;
@override@JsonKey() List<WorkoutSplit> get splits {
  if (_splits is EqualUnmodifiableListView) return _splits;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_splits);
}

 final  List<WorkoutSession> _sessions;
@override@JsonKey() List<WorkoutSession> get sessions {
  if (_sessions is EqualUnmodifiableListView) return _sessions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sessions);
}

@override final  WorkoutSession? activeSession;

/// Create a copy of WorkoutData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkoutDataCopyWith<_WorkoutData> get copyWith => __$WorkoutDataCopyWithImpl<_WorkoutData>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkoutData&&const DeepCollectionEquality().equals(other.exercises, _exercises)&&const DeepCollectionEquality().equals(other.splits, _splits)&&const DeepCollectionEquality().equals(other.sessions, _sessions)&&(identical(other.activeSession, activeSession) || other.activeSession == activeSession));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_exercises),const DeepCollectionEquality().hash(_splits),const DeepCollectionEquality().hash(_sessions),activeSession);
}

@override
String toString() {
    return 'WorkoutData(exercises: $exercises, splits: $splits, sessions: $sessions, activeSession: $activeSession)';
}


}

/// @nodoc
abstract mixin class _$WorkoutDataCopyWith<$Res> implements $WorkoutDataCopyWith<$Res> {
  factory _$WorkoutDataCopyWith(_WorkoutData value, $Res Function(_WorkoutData) _then) = __$WorkoutDataCopyWithImpl;
@override @useResult
$Res call({
 List<Exercise> exercises, List<WorkoutSplit> splits, List<WorkoutSession> sessions, WorkoutSession? activeSession
});


@override $WorkoutSessionCopyWith<$Res>? get activeSession;

}
/// @nodoc
class __$WorkoutDataCopyWithImpl<$Res>
    implements _$WorkoutDataCopyWith<$Res> {
  __$WorkoutDataCopyWithImpl(this._self, this._then);

  final _WorkoutData _self;
  final $Res Function(_WorkoutData) _then;

/// Create a copy of WorkoutData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? exercises = null,Object? splits = null,Object? sessions = null,Object? activeSession = freezed,}) {
  return _then(_WorkoutData(
exercises: null == exercises ? _self._exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<Exercise>,splits: null == splits ? _self._splits : splits // ignore: cast_nullable_to_non_nullable
as List<WorkoutSplit>,sessions: null == sessions ? _self._sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<WorkoutSession>,activeSession: freezed == activeSession ? _self.activeSession : activeSession // ignore: cast_nullable_to_non_nullable
as WorkoutSession?,
  ));
}

/// Create a copy of WorkoutData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkoutSessionCopyWith<$Res>? get activeSession {
    if (_self.activeSession == null) {
    return null;
  }

  return $WorkoutSessionCopyWith<$Res>(_self.activeSession!, (value) {
    return _then(_self.copyWith(activeSession: value));
  });
}
}

// dart format on
