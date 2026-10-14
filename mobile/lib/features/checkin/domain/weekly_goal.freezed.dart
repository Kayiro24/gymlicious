// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weekly_goal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GoalPeriod {

 CalendarDate get effectiveFrom; int get daysPerWeek;
/// Create a copy of GoalPeriod
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GoalPeriodCopyWith<GoalPeriod> get copyWith => _$GoalPeriodCopyWithImpl<GoalPeriod>(this as GoalPeriod, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as GoalPeriod;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoalPeriod&&(identical(other.effectiveFrom, _this.effectiveFrom) || other.effectiveFrom == _this.effectiveFrom)&&(identical(other.daysPerWeek, _this.daysPerWeek) || other.daysPerWeek == _this.daysPerWeek));
}


@override
int get hashCode {
  final _this = this as GoalPeriod;
  return Object.hash(runtimeType,_this.effectiveFrom,_this.daysPerWeek);
}

@override
String toString() {
  final _this = this as GoalPeriod;
  return 'GoalPeriod(effectiveFrom: ${_this.effectiveFrom}, daysPerWeek: ${_this.daysPerWeek})';
}


}

/// @nodoc
abstract mixin class $GoalPeriodCopyWith<$Res>  {
  factory $GoalPeriodCopyWith(GoalPeriod value, $Res Function(GoalPeriod) _then) = _$GoalPeriodCopyWithImpl;
@useResult
$Res call({
 CalendarDate effectiveFrom, int daysPerWeek
});




}
/// @nodoc
class _$GoalPeriodCopyWithImpl<$Res>
    implements $GoalPeriodCopyWith<$Res> {
  _$GoalPeriodCopyWithImpl(this._self, this._then);

  final GoalPeriod _self;
  final $Res Function(GoalPeriod) _then;

/// Create a copy of GoalPeriod
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? effectiveFrom = null,Object? daysPerWeek = null,}) {
  return _then(GoalPeriod(
effectiveFrom: null == effectiveFrom ? _self.effectiveFrom : effectiveFrom // ignore: cast_nullable_to_non_nullable
as CalendarDate,daysPerWeek: null == daysPerWeek ? _self.daysPerWeek : daysPerWeek // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [GoalPeriod].
extension GoalPeriodPatterns on GoalPeriod {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GoalPeriod value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GoalPeriod() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GoalPeriod value)  $default,){
final _that = this;
switch (_that) {
case _GoalPeriod():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GoalPeriod value)?  $default,){
final _that = this;
switch (_that) {
case _GoalPeriod() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CalendarDate effectiveFrom,  int daysPerWeek)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GoalPeriod() when $default != null:
return $default(_that.effectiveFrom,_that.daysPerWeek);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CalendarDate effectiveFrom,  int daysPerWeek)  $default,) {final _that = this;
switch (_that) {
case _GoalPeriod():
return $default(_that.effectiveFrom,_that.daysPerWeek);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CalendarDate effectiveFrom,  int daysPerWeek)?  $default,) {final _that = this;
switch (_that) {
case _GoalPeriod() when $default != null:
return $default(_that.effectiveFrom,_that.daysPerWeek);case _:
  return null;

}
}

}

/// @nodoc


class _GoalPeriod implements GoalPeriod {
  const _GoalPeriod({required this.effectiveFrom, required this.daysPerWeek});
  

@override final  CalendarDate effectiveFrom;
@override final  int daysPerWeek;

/// Create a copy of GoalPeriod
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GoalPeriodCopyWith<_GoalPeriod> get copyWith => __$GoalPeriodCopyWithImpl<_GoalPeriod>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GoalPeriod&&(identical(other.effectiveFrom, effectiveFrom) || other.effectiveFrom == effectiveFrom)&&(identical(other.daysPerWeek, daysPerWeek) || other.daysPerWeek == daysPerWeek));
}


@override
int get hashCode {
    return Object.hash(runtimeType,effectiveFrom,daysPerWeek);
}

@override
String toString() {
    return 'GoalPeriod(effectiveFrom: $effectiveFrom, daysPerWeek: $daysPerWeek)';
}


}

/// @nodoc
abstract mixin class _$GoalPeriodCopyWith<$Res> implements $GoalPeriodCopyWith<$Res> {
  factory _$GoalPeriodCopyWith(_GoalPeriod value, $Res Function(_GoalPeriod) _then) = __$GoalPeriodCopyWithImpl;
@override @useResult
$Res call({
 CalendarDate effectiveFrom, int daysPerWeek
});




}
/// @nodoc
class __$GoalPeriodCopyWithImpl<$Res>
    implements _$GoalPeriodCopyWith<$Res> {
  __$GoalPeriodCopyWithImpl(this._self, this._then);

  final _GoalPeriod _self;
  final $Res Function(_GoalPeriod) _then;

/// Create a copy of GoalPeriod
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? effectiveFrom = null,Object? daysPerWeek = null,}) {
  return _then(_GoalPeriod(
effectiveFrom: null == effectiveFrom ? _self.effectiveFrom : effectiveFrom // ignore: cast_nullable_to_non_nullable
as CalendarDate,daysPerWeek: null == daysPerWeek ? _self.daysPerWeek : daysPerWeek // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$WeeklyGoalHistory {

 List<GoalPeriod> get periods;
/// Create a copy of WeeklyGoalHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeeklyGoalHistoryCopyWith<WeeklyGoalHistory> get copyWith => _$WeeklyGoalHistoryCopyWithImpl<WeeklyGoalHistory>(this as WeeklyGoalHistory, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as WeeklyGoalHistory;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeeklyGoalHistory&&const DeepCollectionEquality().equals(other.periods, _this.periods));
}


@override
int get hashCode {
  final _this = this as WeeklyGoalHistory;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.periods));
}

@override
String toString() {
  final _this = this as WeeklyGoalHistory;
  return 'WeeklyGoalHistory(periods: ${_this.periods})';
}


}

/// @nodoc
abstract mixin class $WeeklyGoalHistoryCopyWith<$Res>  {
  factory $WeeklyGoalHistoryCopyWith(WeeklyGoalHistory value, $Res Function(WeeklyGoalHistory) _then) = _$WeeklyGoalHistoryCopyWithImpl;
@useResult
$Res call({
 List<GoalPeriod> periods
});




}
/// @nodoc
class _$WeeklyGoalHistoryCopyWithImpl<$Res>
    implements $WeeklyGoalHistoryCopyWith<$Res> {
  _$WeeklyGoalHistoryCopyWithImpl(this._self, this._then);

  final WeeklyGoalHistory _self;
  final $Res Function(WeeklyGoalHistory) _then;

/// Create a copy of WeeklyGoalHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? periods = null,}) {
  return _then(WeeklyGoalHistory(
periods: null == periods ? _self.periods : periods // ignore: cast_nullable_to_non_nullable
as List<GoalPeriod>,
  ));
}

}


/// Adds pattern-matching-related methods to [WeeklyGoalHistory].
extension WeeklyGoalHistoryPatterns on WeeklyGoalHistory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeeklyGoalHistory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeeklyGoalHistory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeeklyGoalHistory value)  $default,){
final _that = this;
switch (_that) {
case _WeeklyGoalHistory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeeklyGoalHistory value)?  $default,){
final _that = this;
switch (_that) {
case _WeeklyGoalHistory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<GoalPeriod> periods)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeeklyGoalHistory() when $default != null:
return $default(_that.periods);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<GoalPeriod> periods)  $default,) {final _that = this;
switch (_that) {
case _WeeklyGoalHistory():
return $default(_that.periods);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<GoalPeriod> periods)?  $default,) {final _that = this;
switch (_that) {
case _WeeklyGoalHistory() when $default != null:
return $default(_that.periods);case _:
  return null;

}
}

}

/// @nodoc


class _WeeklyGoalHistory extends WeeklyGoalHistory {
  const _WeeklyGoalHistory({ List<GoalPeriod> periods = const <GoalPeriod>[]}): _periods = periods,super._();
  

 final  List<GoalPeriod> _periods;
@override@JsonKey() List<GoalPeriod> get periods {
  if (_periods is EqualUnmodifiableListView) return _periods;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_periods);
}


/// Create a copy of WeeklyGoalHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeeklyGoalHistoryCopyWith<_WeeklyGoalHistory> get copyWith => __$WeeklyGoalHistoryCopyWithImpl<_WeeklyGoalHistory>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeeklyGoalHistory&&const DeepCollectionEquality().equals(other.periods, _periods));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_periods));
}

@override
String toString() {
    return 'WeeklyGoalHistory(periods: $periods)';
}


}

/// @nodoc
abstract mixin class _$WeeklyGoalHistoryCopyWith<$Res> implements $WeeklyGoalHistoryCopyWith<$Res> {
  factory _$WeeklyGoalHistoryCopyWith(_WeeklyGoalHistory value, $Res Function(_WeeklyGoalHistory) _then) = __$WeeklyGoalHistoryCopyWithImpl;
@override @useResult
$Res call({
 List<GoalPeriod> periods
});




}
/// @nodoc
class __$WeeklyGoalHistoryCopyWithImpl<$Res>
    implements _$WeeklyGoalHistoryCopyWith<$Res> {
  __$WeeklyGoalHistoryCopyWithImpl(this._self, this._then);

  final _WeeklyGoalHistory _self;
  final $Res Function(_WeeklyGoalHistory) _then;

/// Create a copy of WeeklyGoalHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? periods = null,}) {
  return _then(_WeeklyGoalHistory(
periods: null == periods ? _self._periods : periods // ignore: cast_nullable_to_non_nullable
as List<GoalPeriod>,
  ));
}


}

// dart format on
