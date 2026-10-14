// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'streak_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WeekResult {

 CalendarDate get monday; int get done; int get goal; bool get isComplete;
/// Create a copy of WeekResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeekResultCopyWith<WeekResult> get copyWith => _$WeekResultCopyWithImpl<WeekResult>(this as WeekResult, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as WeekResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeekResult&&(identical(other.monday, _this.monday) || other.monday == _this.monday)&&(identical(other.done, _this.done) || other.done == _this.done)&&(identical(other.goal, _this.goal) || other.goal == _this.goal)&&(identical(other.isComplete, _this.isComplete) || other.isComplete == _this.isComplete));
}


@override
int get hashCode {
  final _this = this as WeekResult;
  return Object.hash(runtimeType,_this.monday,_this.done,_this.goal,_this.isComplete);
}

@override
String toString() {
  final _this = this as WeekResult;
  return 'WeekResult(monday: ${_this.monday}, done: ${_this.done}, goal: ${_this.goal}, isComplete: ${_this.isComplete})';
}


}

/// @nodoc
abstract mixin class $WeekResultCopyWith<$Res>  {
  factory $WeekResultCopyWith(WeekResult value, $Res Function(WeekResult) _then) = _$WeekResultCopyWithImpl;
@useResult
$Res call({
 CalendarDate monday, int done, int goal, bool isComplete
});




}
/// @nodoc
class _$WeekResultCopyWithImpl<$Res>
    implements $WeekResultCopyWith<$Res> {
  _$WeekResultCopyWithImpl(this._self, this._then);

  final WeekResult _self;
  final $Res Function(WeekResult) _then;

/// Create a copy of WeekResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? monday = null,Object? done = null,Object? goal = null,Object? isComplete = null,}) {
  return _then(WeekResult(
monday: null == monday ? _self.monday : monday // ignore: cast_nullable_to_non_nullable
as CalendarDate,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as int,goal: null == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as int,isComplete: null == isComplete ? _self.isComplete : isComplete // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [WeekResult].
extension WeekResultPatterns on WeekResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeekResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeekResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeekResult value)  $default,){
final _that = this;
switch (_that) {
case _WeekResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeekResult value)?  $default,){
final _that = this;
switch (_that) {
case _WeekResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CalendarDate monday,  int done,  int goal,  bool isComplete)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeekResult() when $default != null:
return $default(_that.monday,_that.done,_that.goal,_that.isComplete);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CalendarDate monday,  int done,  int goal,  bool isComplete)  $default,) {final _that = this;
switch (_that) {
case _WeekResult():
return $default(_that.monday,_that.done,_that.goal,_that.isComplete);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CalendarDate monday,  int done,  int goal,  bool isComplete)?  $default,) {final _that = this;
switch (_that) {
case _WeekResult() when $default != null:
return $default(_that.monday,_that.done,_that.goal,_that.isComplete);case _:
  return null;

}
}

}

/// @nodoc


class _WeekResult extends WeekResult {
  const _WeekResult({required this.monday, required this.done, required this.goal, required this.isComplete}): super._();
  

@override final  CalendarDate monday;
@override final  int done;
@override final  int goal;
@override final  bool isComplete;

/// Create a copy of WeekResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeekResultCopyWith<_WeekResult> get copyWith => __$WeekResultCopyWithImpl<_WeekResult>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeekResult&&(identical(other.monday, monday) || other.monday == monday)&&(identical(other.done, done) || other.done == done)&&(identical(other.goal, goal) || other.goal == goal)&&(identical(other.isComplete, isComplete) || other.isComplete == isComplete));
}


@override
int get hashCode {
    return Object.hash(runtimeType,monday,done,goal,isComplete);
}

@override
String toString() {
    return 'WeekResult(monday: $monday, done: $done, goal: $goal, isComplete: $isComplete)';
}


}

/// @nodoc
abstract mixin class _$WeekResultCopyWith<$Res> implements $WeekResultCopyWith<$Res> {
  factory _$WeekResultCopyWith(_WeekResult value, $Res Function(_WeekResult) _then) = __$WeekResultCopyWithImpl;
@override @useResult
$Res call({
 CalendarDate monday, int done, int goal, bool isComplete
});




}
/// @nodoc
class __$WeekResultCopyWithImpl<$Res>
    implements _$WeekResultCopyWith<$Res> {
  __$WeekResultCopyWithImpl(this._self, this._then);

  final _WeekResult _self;
  final $Res Function(_WeekResult) _then;

/// Create a copy of WeekResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? monday = null,Object? done = null,Object? goal = null,Object? isComplete = null,}) {
  return _then(_WeekResult(
monday: null == monday ? _self.monday : monday // ignore: cast_nullable_to_non_nullable
as CalendarDate,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as int,goal: null == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as int,isComplete: null == isComplete ? _self.isComplete : isComplete // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$CurrentWeek {

 CalendarDate get monday; int get done; int get goal;/// Remaining days, Sunday included, plus today if it isn't done yet.
 int get openDays; WeekStatus get status;/// The goal became unreachable earlier this week.
 bool get isLost;
/// Create a copy of CurrentWeek
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CurrentWeekCopyWith<CurrentWeek> get copyWith => _$CurrentWeekCopyWithImpl<CurrentWeek>(this as CurrentWeek, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CurrentWeek;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CurrentWeek&&(identical(other.monday, _this.monday) || other.monday == _this.monday)&&(identical(other.done, _this.done) || other.done == _this.done)&&(identical(other.goal, _this.goal) || other.goal == _this.goal)&&(identical(other.openDays, _this.openDays) || other.openDays == _this.openDays)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.isLost, _this.isLost) || other.isLost == _this.isLost));
}


@override
int get hashCode {
  final _this = this as CurrentWeek;
  return Object.hash(runtimeType,_this.monday,_this.done,_this.goal,_this.openDays,_this.status,_this.isLost);
}

@override
String toString() {
  final _this = this as CurrentWeek;
  return 'CurrentWeek(monday: ${_this.monday}, done: ${_this.done}, goal: ${_this.goal}, openDays: ${_this.openDays}, status: ${_this.status}, isLost: ${_this.isLost})';
}


}

/// @nodoc
abstract mixin class $CurrentWeekCopyWith<$Res>  {
  factory $CurrentWeekCopyWith(CurrentWeek value, $Res Function(CurrentWeek) _then) = _$CurrentWeekCopyWithImpl;
@useResult
$Res call({
 CalendarDate monday, int done, int goal, int openDays, WeekStatus status, bool isLost
});




}
/// @nodoc
class _$CurrentWeekCopyWithImpl<$Res>
    implements $CurrentWeekCopyWith<$Res> {
  _$CurrentWeekCopyWithImpl(this._self, this._then);

  final CurrentWeek _self;
  final $Res Function(CurrentWeek) _then;

/// Create a copy of CurrentWeek
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? monday = null,Object? done = null,Object? goal = null,Object? openDays = null,Object? status = null,Object? isLost = null,}) {
  return _then(CurrentWeek(
monday: null == monday ? _self.monday : monday // ignore: cast_nullable_to_non_nullable
as CalendarDate,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as int,goal: null == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as int,openDays: null == openDays ? _self.openDays : openDays // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WeekStatus,isLost: null == isLost ? _self.isLost : isLost // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CurrentWeek].
extension CurrentWeekPatterns on CurrentWeek {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CurrentWeek value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CurrentWeek() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CurrentWeek value)  $default,){
final _that = this;
switch (_that) {
case _CurrentWeek():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CurrentWeek value)?  $default,){
final _that = this;
switch (_that) {
case _CurrentWeek() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CalendarDate monday,  int done,  int goal,  int openDays,  WeekStatus status,  bool isLost)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CurrentWeek() when $default != null:
return $default(_that.monday,_that.done,_that.goal,_that.openDays,_that.status,_that.isLost);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CalendarDate monday,  int done,  int goal,  int openDays,  WeekStatus status,  bool isLost)  $default,) {final _that = this;
switch (_that) {
case _CurrentWeek():
return $default(_that.monday,_that.done,_that.goal,_that.openDays,_that.status,_that.isLost);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CalendarDate monday,  int done,  int goal,  int openDays,  WeekStatus status,  bool isLost)?  $default,) {final _that = this;
switch (_that) {
case _CurrentWeek() when $default != null:
return $default(_that.monday,_that.done,_that.goal,_that.openDays,_that.status,_that.isLost);case _:
  return null;

}
}

}

/// @nodoc


class _CurrentWeek extends CurrentWeek {
  const _CurrentWeek({required this.monday, required this.done, required this.goal, required this.openDays, required this.status, this.isLost = false}): super._();
  

@override final  CalendarDate monday;
@override final  int done;
@override final  int goal;
/// Remaining days, Sunday included, plus today if it isn't done yet.
@override final  int openDays;
@override final  WeekStatus status;
/// The goal became unreachable earlier this week.
@override@JsonKey() final  bool isLost;

/// Create a copy of CurrentWeek
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CurrentWeekCopyWith<_CurrentWeek> get copyWith => __$CurrentWeekCopyWithImpl<_CurrentWeek>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CurrentWeek&&(identical(other.monday, monday) || other.monday == monday)&&(identical(other.done, done) || other.done == done)&&(identical(other.goal, goal) || other.goal == goal)&&(identical(other.openDays, openDays) || other.openDays == openDays)&&(identical(other.status, status) || other.status == status)&&(identical(other.isLost, isLost) || other.isLost == isLost));
}


@override
int get hashCode {
    return Object.hash(runtimeType,monday,done,goal,openDays,status,isLost);
}

@override
String toString() {
    return 'CurrentWeek(monday: $monday, done: $done, goal: $goal, openDays: $openDays, status: $status, isLost: $isLost)';
}


}

/// @nodoc
abstract mixin class _$CurrentWeekCopyWith<$Res> implements $CurrentWeekCopyWith<$Res> {
  factory _$CurrentWeekCopyWith(_CurrentWeek value, $Res Function(_CurrentWeek) _then) = __$CurrentWeekCopyWithImpl;
@override @useResult
$Res call({
 CalendarDate monday, int done, int goal, int openDays, WeekStatus status, bool isLost
});




}
/// @nodoc
class __$CurrentWeekCopyWithImpl<$Res>
    implements _$CurrentWeekCopyWith<$Res> {
  __$CurrentWeekCopyWithImpl(this._self, this._then);

  final _CurrentWeek _self;
  final $Res Function(_CurrentWeek) _then;

/// Create a copy of CurrentWeek
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? monday = null,Object? done = null,Object? goal = null,Object? openDays = null,Object? status = null,Object? isLost = null,}) {
  return _then(_CurrentWeek(
monday: null == monday ? _self.monday : monday // ignore: cast_nullable_to_non_nullable
as CalendarDate,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as int,goal: null == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as int,openDays: null == openDays ? _self.openDays : openDays // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WeekStatus,isLost: null == isLost ? _self.isLost : isLost // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$StreakSnapshot {

 int get currentDays; int get bestDays; int get weeksOnTrack; int get totalWorkouts; CurrentWeek get currentWeek;/// Oldest first, from the week of the first workout to this week.
 List<WeekResult> get weeks;
/// Create a copy of StreakSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StreakSnapshotCopyWith<StreakSnapshot> get copyWith => _$StreakSnapshotCopyWithImpl<StreakSnapshot>(this as StreakSnapshot, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as StreakSnapshot;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StreakSnapshot&&(identical(other.currentDays, _this.currentDays) || other.currentDays == _this.currentDays)&&(identical(other.bestDays, _this.bestDays) || other.bestDays == _this.bestDays)&&(identical(other.weeksOnTrack, _this.weeksOnTrack) || other.weeksOnTrack == _this.weeksOnTrack)&&(identical(other.totalWorkouts, _this.totalWorkouts) || other.totalWorkouts == _this.totalWorkouts)&&(identical(other.currentWeek, _this.currentWeek) || other.currentWeek == _this.currentWeek)&&const DeepCollectionEquality().equals(other.weeks, _this.weeks));
}


@override
int get hashCode {
  final _this = this as StreakSnapshot;
  return Object.hash(runtimeType,_this.currentDays,_this.bestDays,_this.weeksOnTrack,_this.totalWorkouts,_this.currentWeek,const DeepCollectionEquality().hash(_this.weeks));
}

@override
String toString() {
  final _this = this as StreakSnapshot;
  return 'StreakSnapshot(currentDays: ${_this.currentDays}, bestDays: ${_this.bestDays}, weeksOnTrack: ${_this.weeksOnTrack}, totalWorkouts: ${_this.totalWorkouts}, currentWeek: ${_this.currentWeek}, weeks: ${_this.weeks})';
}


}

/// @nodoc
abstract mixin class $StreakSnapshotCopyWith<$Res>  {
  factory $StreakSnapshotCopyWith(StreakSnapshot value, $Res Function(StreakSnapshot) _then) = _$StreakSnapshotCopyWithImpl;
@useResult
$Res call({
 int currentDays, int bestDays, int weeksOnTrack, int totalWorkouts, CurrentWeek currentWeek, List<WeekResult> weeks
});


$CurrentWeekCopyWith<$Res> get currentWeek;

}
/// @nodoc
class _$StreakSnapshotCopyWithImpl<$Res>
    implements $StreakSnapshotCopyWith<$Res> {
  _$StreakSnapshotCopyWithImpl(this._self, this._then);

  final StreakSnapshot _self;
  final $Res Function(StreakSnapshot) _then;

/// Create a copy of StreakSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentDays = null,Object? bestDays = null,Object? weeksOnTrack = null,Object? totalWorkouts = null,Object? currentWeek = null,Object? weeks = null,}) {
  return _then(StreakSnapshot(
currentDays: null == currentDays ? _self.currentDays : currentDays // ignore: cast_nullable_to_non_nullable
as int,bestDays: null == bestDays ? _self.bestDays : bestDays // ignore: cast_nullable_to_non_nullable
as int,weeksOnTrack: null == weeksOnTrack ? _self.weeksOnTrack : weeksOnTrack // ignore: cast_nullable_to_non_nullable
as int,totalWorkouts: null == totalWorkouts ? _self.totalWorkouts : totalWorkouts // ignore: cast_nullable_to_non_nullable
as int,currentWeek: null == currentWeek ? _self.currentWeek : currentWeek // ignore: cast_nullable_to_non_nullable
as CurrentWeek,weeks: null == weeks ? _self.weeks : weeks // ignore: cast_nullable_to_non_nullable
as List<WeekResult>,
  ));
}
/// Create a copy of StreakSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CurrentWeekCopyWith<$Res> get currentWeek {
  
  return $CurrentWeekCopyWith<$Res>(_self.currentWeek, (value) {
    return _then(_self.copyWith(currentWeek: value));
  });
}
}


/// Adds pattern-matching-related methods to [StreakSnapshot].
extension StreakSnapshotPatterns on StreakSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StreakSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StreakSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StreakSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _StreakSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StreakSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _StreakSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int currentDays,  int bestDays,  int weeksOnTrack,  int totalWorkouts,  CurrentWeek currentWeek,  List<WeekResult> weeks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StreakSnapshot() when $default != null:
return $default(_that.currentDays,_that.bestDays,_that.weeksOnTrack,_that.totalWorkouts,_that.currentWeek,_that.weeks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int currentDays,  int bestDays,  int weeksOnTrack,  int totalWorkouts,  CurrentWeek currentWeek,  List<WeekResult> weeks)  $default,) {final _that = this;
switch (_that) {
case _StreakSnapshot():
return $default(_that.currentDays,_that.bestDays,_that.weeksOnTrack,_that.totalWorkouts,_that.currentWeek,_that.weeks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int currentDays,  int bestDays,  int weeksOnTrack,  int totalWorkouts,  CurrentWeek currentWeek,  List<WeekResult> weeks)?  $default,) {final _that = this;
switch (_that) {
case _StreakSnapshot() when $default != null:
return $default(_that.currentDays,_that.bestDays,_that.weeksOnTrack,_that.totalWorkouts,_that.currentWeek,_that.weeks);case _:
  return null;

}
}

}

/// @nodoc


class _StreakSnapshot implements StreakSnapshot {
  const _StreakSnapshot({required this.currentDays, required this.bestDays, required this.weeksOnTrack, required this.totalWorkouts, required this.currentWeek,  List<WeekResult> weeks = const <WeekResult>[]}): _weeks = weeks;
  

@override final  int currentDays;
@override final  int bestDays;
@override final  int weeksOnTrack;
@override final  int totalWorkouts;
@override final  CurrentWeek currentWeek;
/// Oldest first, from the week of the first workout to this week.
 final  List<WeekResult> _weeks;
/// Oldest first, from the week of the first workout to this week.
@override@JsonKey() List<WeekResult> get weeks {
  if (_weeks is EqualUnmodifiableListView) return _weeks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weeks);
}


/// Create a copy of StreakSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StreakSnapshotCopyWith<_StreakSnapshot> get copyWith => __$StreakSnapshotCopyWithImpl<_StreakSnapshot>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StreakSnapshot&&(identical(other.currentDays, currentDays) || other.currentDays == currentDays)&&(identical(other.bestDays, bestDays) || other.bestDays == bestDays)&&(identical(other.weeksOnTrack, weeksOnTrack) || other.weeksOnTrack == weeksOnTrack)&&(identical(other.totalWorkouts, totalWorkouts) || other.totalWorkouts == totalWorkouts)&&(identical(other.currentWeek, currentWeek) || other.currentWeek == currentWeek)&&const DeepCollectionEquality().equals(other.weeks, _weeks));
}


@override
int get hashCode {
    return Object.hash(runtimeType,currentDays,bestDays,weeksOnTrack,totalWorkouts,currentWeek,const DeepCollectionEquality().hash(_weeks));
}

@override
String toString() {
    return 'StreakSnapshot(currentDays: $currentDays, bestDays: $bestDays, weeksOnTrack: $weeksOnTrack, totalWorkouts: $totalWorkouts, currentWeek: $currentWeek, weeks: $weeks)';
}


}

/// @nodoc
abstract mixin class _$StreakSnapshotCopyWith<$Res> implements $StreakSnapshotCopyWith<$Res> {
  factory _$StreakSnapshotCopyWith(_StreakSnapshot value, $Res Function(_StreakSnapshot) _then) = __$StreakSnapshotCopyWithImpl;
@override @useResult
$Res call({
 int currentDays, int bestDays, int weeksOnTrack, int totalWorkouts, CurrentWeek currentWeek, List<WeekResult> weeks
});


@override $CurrentWeekCopyWith<$Res> get currentWeek;

}
/// @nodoc
class __$StreakSnapshotCopyWithImpl<$Res>
    implements _$StreakSnapshotCopyWith<$Res> {
  __$StreakSnapshotCopyWithImpl(this._self, this._then);

  final _StreakSnapshot _self;
  final $Res Function(_StreakSnapshot) _then;

/// Create a copy of StreakSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentDays = null,Object? bestDays = null,Object? weeksOnTrack = null,Object? totalWorkouts = null,Object? currentWeek = null,Object? weeks = null,}) {
  return _then(_StreakSnapshot(
currentDays: null == currentDays ? _self.currentDays : currentDays // ignore: cast_nullable_to_non_nullable
as int,bestDays: null == bestDays ? _self.bestDays : bestDays // ignore: cast_nullable_to_non_nullable
as int,weeksOnTrack: null == weeksOnTrack ? _self.weeksOnTrack : weeksOnTrack // ignore: cast_nullable_to_non_nullable
as int,totalWorkouts: null == totalWorkouts ? _self.totalWorkouts : totalWorkouts // ignore: cast_nullable_to_non_nullable
as int,currentWeek: null == currentWeek ? _self.currentWeek : currentWeek // ignore: cast_nullable_to_non_nullable
as CurrentWeek,weeks: null == weeks ? _self._weeks : weeks // ignore: cast_nullable_to_non_nullable
as List<WeekResult>,
  ));
}

/// Create a copy of StreakSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CurrentWeekCopyWith<$Res> get currentWeek {
  
  return $CurrentWeekCopyWith<$Res>(_self.currentWeek, (value) {
    return _then(_self.copyWith(currentWeek: value));
  });
}
}

// dart format on
