// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExerciseStats {

 double? get maxKg; CalendarDate? get maxDate; double? get lastKg; CalendarDate? get lastDate;
/// Create a copy of ExerciseStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseStatsCopyWith<ExerciseStats> get copyWith => _$ExerciseStatsCopyWithImpl<ExerciseStats>(this as ExerciseStats, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ExerciseStats;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExerciseStats&&(identical(other.maxKg, _this.maxKg) || other.maxKg == _this.maxKg)&&(identical(other.maxDate, _this.maxDate) || other.maxDate == _this.maxDate)&&(identical(other.lastKg, _this.lastKg) || other.lastKg == _this.lastKg)&&(identical(other.lastDate, _this.lastDate) || other.lastDate == _this.lastDate));
}


@override
int get hashCode {
  final _this = this as ExerciseStats;
  return Object.hash(runtimeType,_this.maxKg,_this.maxDate,_this.lastKg,_this.lastDate);
}

@override
String toString() {
  final _this = this as ExerciseStats;
  return 'ExerciseStats(maxKg: ${_this.maxKg}, maxDate: ${_this.maxDate}, lastKg: ${_this.lastKg}, lastDate: ${_this.lastDate})';
}


}

/// @nodoc
abstract mixin class $ExerciseStatsCopyWith<$Res>  {
  factory $ExerciseStatsCopyWith(ExerciseStats value, $Res Function(ExerciseStats) _then) = _$ExerciseStatsCopyWithImpl;
@useResult
$Res call({
 double? maxKg, CalendarDate? maxDate, double? lastKg, CalendarDate? lastDate
});




}
/// @nodoc
class _$ExerciseStatsCopyWithImpl<$Res>
    implements $ExerciseStatsCopyWith<$Res> {
  _$ExerciseStatsCopyWithImpl(this._self, this._then);

  final ExerciseStats _self;
  final $Res Function(ExerciseStats) _then;

/// Create a copy of ExerciseStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? maxKg = freezed,Object? maxDate = freezed,Object? lastKg = freezed,Object? lastDate = freezed,}) {
  return _then(ExerciseStats(
maxKg: freezed == maxKg ? _self.maxKg : maxKg // ignore: cast_nullable_to_non_nullable
as double?,maxDate: freezed == maxDate ? _self.maxDate : maxDate // ignore: cast_nullable_to_non_nullable
as CalendarDate?,lastKg: freezed == lastKg ? _self.lastKg : lastKg // ignore: cast_nullable_to_non_nullable
as double?,lastDate: freezed == lastDate ? _self.lastDate : lastDate // ignore: cast_nullable_to_non_nullable
as CalendarDate?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExerciseStats].
extension ExerciseStatsPatterns on ExerciseStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExerciseStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExerciseStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExerciseStats value)  $default,){
final _that = this;
switch (_that) {
case _ExerciseStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExerciseStats value)?  $default,){
final _that = this;
switch (_that) {
case _ExerciseStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double? maxKg,  CalendarDate? maxDate,  double? lastKg,  CalendarDate? lastDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExerciseStats() when $default != null:
return $default(_that.maxKg,_that.maxDate,_that.lastKg,_that.lastDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double? maxKg,  CalendarDate? maxDate,  double? lastKg,  CalendarDate? lastDate)  $default,) {final _that = this;
switch (_that) {
case _ExerciseStats():
return $default(_that.maxKg,_that.maxDate,_that.lastKg,_that.lastDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double? maxKg,  CalendarDate? maxDate,  double? lastKg,  CalendarDate? lastDate)?  $default,) {final _that = this;
switch (_that) {
case _ExerciseStats() when $default != null:
return $default(_that.maxKg,_that.maxDate,_that.lastKg,_that.lastDate);case _:
  return null;

}
}

}

/// @nodoc


class _ExerciseStats implements ExerciseStats {
  const _ExerciseStats({this.maxKg, this.maxDate, this.lastKg, this.lastDate});
  

@override final  double? maxKg;
@override final  CalendarDate? maxDate;
@override final  double? lastKg;
@override final  CalendarDate? lastDate;

/// Create a copy of ExerciseStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseStatsCopyWith<_ExerciseStats> get copyWith => __$ExerciseStatsCopyWithImpl<_ExerciseStats>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExerciseStats&&(identical(other.maxKg, maxKg) || other.maxKg == maxKg)&&(identical(other.maxDate, maxDate) || other.maxDate == maxDate)&&(identical(other.lastKg, lastKg) || other.lastKg == lastKg)&&(identical(other.lastDate, lastDate) || other.lastDate == lastDate));
}


@override
int get hashCode {
    return Object.hash(runtimeType,maxKg,maxDate,lastKg,lastDate);
}

@override
String toString() {
    return 'ExerciseStats(maxKg: $maxKg, maxDate: $maxDate, lastKg: $lastKg, lastDate: $lastDate)';
}


}

/// @nodoc
abstract mixin class _$ExerciseStatsCopyWith<$Res> implements $ExerciseStatsCopyWith<$Res> {
  factory _$ExerciseStatsCopyWith(_ExerciseStats value, $Res Function(_ExerciseStats) _then) = __$ExerciseStatsCopyWithImpl;
@override @useResult
$Res call({
 double? maxKg, CalendarDate? maxDate, double? lastKg, CalendarDate? lastDate
});




}
/// @nodoc
class __$ExerciseStatsCopyWithImpl<$Res>
    implements _$ExerciseStatsCopyWith<$Res> {
  __$ExerciseStatsCopyWithImpl(this._self, this._then);

  final _ExerciseStats _self;
  final $Res Function(_ExerciseStats) _then;

/// Create a copy of ExerciseStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? maxKg = freezed,Object? maxDate = freezed,Object? lastKg = freezed,Object? lastDate = freezed,}) {
  return _then(_ExerciseStats(
maxKg: freezed == maxKg ? _self.maxKg : maxKg // ignore: cast_nullable_to_non_nullable
as double?,maxDate: freezed == maxDate ? _self.maxDate : maxDate // ignore: cast_nullable_to_non_nullable
as CalendarDate?,lastKg: freezed == lastKg ? _self.lastKg : lastKg // ignore: cast_nullable_to_non_nullable
as double?,lastDate: freezed == lastDate ? _self.lastDate : lastDate // ignore: cast_nullable_to_non_nullable
as CalendarDate?,
  ));
}


}

// dart format on
