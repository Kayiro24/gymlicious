// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rate_budget.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RateBudget {

 List<DateTime> get recentRequests; DateTime? get blockedUntil; int get consecutiveErrors;
/// Create a copy of RateBudget
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RateBudgetCopyWith<RateBudget> get copyWith => _$RateBudgetCopyWithImpl<RateBudget>(this as RateBudget, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RateBudget;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RateBudget&&const DeepCollectionEquality().equals(other.recentRequests, _this.recentRequests)&&(identical(other.blockedUntil, _this.blockedUntil) || other.blockedUntil == _this.blockedUntil)&&(identical(other.consecutiveErrors, _this.consecutiveErrors) || other.consecutiveErrors == _this.consecutiveErrors));
}


@override
int get hashCode {
  final _this = this as RateBudget;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.recentRequests),_this.blockedUntil,_this.consecutiveErrors);
}

@override
String toString() {
  final _this = this as RateBudget;
  return 'RateBudget(recentRequests: ${_this.recentRequests}, blockedUntil: ${_this.blockedUntil}, consecutiveErrors: ${_this.consecutiveErrors})';
}


}

/// @nodoc
abstract mixin class $RateBudgetCopyWith<$Res>  {
  factory $RateBudgetCopyWith(RateBudget value, $Res Function(RateBudget) _then) = _$RateBudgetCopyWithImpl;
@useResult
$Res call({
 List<DateTime> recentRequests, DateTime? blockedUntil, int consecutiveErrors
});




}
/// @nodoc
class _$RateBudgetCopyWithImpl<$Res>
    implements $RateBudgetCopyWith<$Res> {
  _$RateBudgetCopyWithImpl(this._self, this._then);

  final RateBudget _self;
  final $Res Function(RateBudget) _then;

/// Create a copy of RateBudget
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? recentRequests = null,Object? blockedUntil = freezed,Object? consecutiveErrors = null,}) {
  return _then(RateBudget(
recentRequests: null == recentRequests ? _self.recentRequests : recentRequests // ignore: cast_nullable_to_non_nullable
as List<DateTime>,blockedUntil: freezed == blockedUntil ? _self.blockedUntil : blockedUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,consecutiveErrors: null == consecutiveErrors ? _self.consecutiveErrors : consecutiveErrors // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RateBudget].
extension RateBudgetPatterns on RateBudget {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RateBudget value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RateBudget() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RateBudget value)  $default,){
final _that = this;
switch (_that) {
case _RateBudget():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RateBudget value)?  $default,){
final _that = this;
switch (_that) {
case _RateBudget() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<DateTime> recentRequests,  DateTime? blockedUntil,  int consecutiveErrors)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RateBudget() when $default != null:
return $default(_that.recentRequests,_that.blockedUntil,_that.consecutiveErrors);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<DateTime> recentRequests,  DateTime? blockedUntil,  int consecutiveErrors)  $default,) {final _that = this;
switch (_that) {
case _RateBudget():
return $default(_that.recentRequests,_that.blockedUntil,_that.consecutiveErrors);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<DateTime> recentRequests,  DateTime? blockedUntil,  int consecutiveErrors)?  $default,) {final _that = this;
switch (_that) {
case _RateBudget() when $default != null:
return $default(_that.recentRequests,_that.blockedUntil,_that.consecutiveErrors);case _:
  return null;

}
}

}

/// @nodoc


class _RateBudget extends RateBudget {
  const _RateBudget({ List<DateTime> recentRequests = const <DateTime>[], this.blockedUntil, this.consecutiveErrors = 0}): _recentRequests = recentRequests,super._();
  

 final  List<DateTime> _recentRequests;
@override@JsonKey() List<DateTime> get recentRequests {
  if (_recentRequests is EqualUnmodifiableListView) return _recentRequests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentRequests);
}

@override final  DateTime? blockedUntil;
@override@JsonKey() final  int consecutiveErrors;

/// Create a copy of RateBudget
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RateBudgetCopyWith<_RateBudget> get copyWith => __$RateBudgetCopyWithImpl<_RateBudget>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RateBudget&&const DeepCollectionEquality().equals(other.recentRequests, _recentRequests)&&(identical(other.blockedUntil, blockedUntil) || other.blockedUntil == blockedUntil)&&(identical(other.consecutiveErrors, consecutiveErrors) || other.consecutiveErrors == consecutiveErrors));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_recentRequests),blockedUntil,consecutiveErrors);
}

@override
String toString() {
    return 'RateBudget(recentRequests: $recentRequests, blockedUntil: $blockedUntil, consecutiveErrors: $consecutiveErrors)';
}


}

/// @nodoc
abstract mixin class _$RateBudgetCopyWith<$Res> implements $RateBudgetCopyWith<$Res> {
  factory _$RateBudgetCopyWith(_RateBudget value, $Res Function(_RateBudget) _then) = __$RateBudgetCopyWithImpl;
@override @useResult
$Res call({
 List<DateTime> recentRequests, DateTime? blockedUntil, int consecutiveErrors
});




}
/// @nodoc
class __$RateBudgetCopyWithImpl<$Res>
    implements _$RateBudgetCopyWith<$Res> {
  __$RateBudgetCopyWithImpl(this._self, this._then);

  final _RateBudget _self;
  final $Res Function(_RateBudget) _then;

/// Create a copy of RateBudget
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? recentRequests = null,Object? blockedUntil = freezed,Object? consecutiveErrors = null,}) {
  return _then(_RateBudget(
recentRequests: null == recentRequests ? _self._recentRequests : recentRequests // ignore: cast_nullable_to_non_nullable
as List<DateTime>,blockedUntil: freezed == blockedUntil ? _self.blockedUntil : blockedUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,consecutiveErrors: null == consecutiveErrors ? _self.consecutiveErrors : consecutiveErrors // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
