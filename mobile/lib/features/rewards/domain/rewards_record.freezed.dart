// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rewards_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EarnedBadge {

 String get id; CalendarDate get earnedAt;
/// Create a copy of EarnedBadge
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EarnedBadgeCopyWith<EarnedBadge> get copyWith => _$EarnedBadgeCopyWithImpl<EarnedBadge>(this as EarnedBadge, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as EarnedBadge;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EarnedBadge&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.earnedAt, _this.earnedAt) || other.earnedAt == _this.earnedAt));
}


@override
int get hashCode {
  final _this = this as EarnedBadge;
  return Object.hash(runtimeType,_this.id,_this.earnedAt);
}

@override
String toString() {
  final _this = this as EarnedBadge;
  return 'EarnedBadge(id: ${_this.id}, earnedAt: ${_this.earnedAt})';
}


}

/// @nodoc
abstract mixin class $EarnedBadgeCopyWith<$Res>  {
  factory $EarnedBadgeCopyWith(EarnedBadge value, $Res Function(EarnedBadge) _then) = _$EarnedBadgeCopyWithImpl;
@useResult
$Res call({
 String id, CalendarDate earnedAt
});




}
/// @nodoc
class _$EarnedBadgeCopyWithImpl<$Res>
    implements $EarnedBadgeCopyWith<$Res> {
  _$EarnedBadgeCopyWithImpl(this._self, this._then);

  final EarnedBadge _self;
  final $Res Function(EarnedBadge) _then;

/// Create a copy of EarnedBadge
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? earnedAt = null,}) {
  return _then(EarnedBadge(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,earnedAt: null == earnedAt ? _self.earnedAt : earnedAt // ignore: cast_nullable_to_non_nullable
as CalendarDate,
  ));
}

}


/// Adds pattern-matching-related methods to [EarnedBadge].
extension EarnedBadgePatterns on EarnedBadge {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EarnedBadge value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EarnedBadge() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EarnedBadge value)  $default,){
final _that = this;
switch (_that) {
case _EarnedBadge():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EarnedBadge value)?  $default,){
final _that = this;
switch (_that) {
case _EarnedBadge() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  CalendarDate earnedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EarnedBadge() when $default != null:
return $default(_that.id,_that.earnedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  CalendarDate earnedAt)  $default,) {final _that = this;
switch (_that) {
case _EarnedBadge():
return $default(_that.id,_that.earnedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  CalendarDate earnedAt)?  $default,) {final _that = this;
switch (_that) {
case _EarnedBadge() when $default != null:
return $default(_that.id,_that.earnedAt);case _:
  return null;

}
}

}

/// @nodoc


class _EarnedBadge implements EarnedBadge {
  const _EarnedBadge({required this.id, required this.earnedAt});
  

@override final  String id;
@override final  CalendarDate earnedAt;

/// Create a copy of EarnedBadge
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EarnedBadgeCopyWith<_EarnedBadge> get copyWith => __$EarnedBadgeCopyWithImpl<_EarnedBadge>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EarnedBadge&&(identical(other.id, id) || other.id == id)&&(identical(other.earnedAt, earnedAt) || other.earnedAt == earnedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,earnedAt);
}

@override
String toString() {
    return 'EarnedBadge(id: $id, earnedAt: $earnedAt)';
}


}

/// @nodoc
abstract mixin class _$EarnedBadgeCopyWith<$Res> implements $EarnedBadgeCopyWith<$Res> {
  factory _$EarnedBadgeCopyWith(_EarnedBadge value, $Res Function(_EarnedBadge) _then) = __$EarnedBadgeCopyWithImpl;
@override @useResult
$Res call({
 String id, CalendarDate earnedAt
});




}
/// @nodoc
class __$EarnedBadgeCopyWithImpl<$Res>
    implements _$EarnedBadgeCopyWith<$Res> {
  __$EarnedBadgeCopyWithImpl(this._self, this._then);

  final _EarnedBadge _self;
  final $Res Function(_EarnedBadge) _then;

/// Create a copy of EarnedBadge
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? earnedAt = null,}) {
  return _then(_EarnedBadge(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,earnedAt: null == earnedAt ? _self.earnedAt : earnedAt // ignore: cast_nullable_to_non_nullable
as CalendarDate,
  ));
}


}

/// @nodoc
mixin _$RewardsRecord {

 List<EarnedBadge> get earnedBadges;/// Null until the first evaluation, which records silently.
 int? get lastCelebratedLevel;
/// Create a copy of RewardsRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RewardsRecordCopyWith<RewardsRecord> get copyWith => _$RewardsRecordCopyWithImpl<RewardsRecord>(this as RewardsRecord, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RewardsRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RewardsRecord&&const DeepCollectionEquality().equals(other.earnedBadges, _this.earnedBadges)&&(identical(other.lastCelebratedLevel, _this.lastCelebratedLevel) || other.lastCelebratedLevel == _this.lastCelebratedLevel));
}


@override
int get hashCode {
  final _this = this as RewardsRecord;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.earnedBadges),_this.lastCelebratedLevel);
}

@override
String toString() {
  final _this = this as RewardsRecord;
  return 'RewardsRecord(earnedBadges: ${_this.earnedBadges}, lastCelebratedLevel: ${_this.lastCelebratedLevel})';
}


}

/// @nodoc
abstract mixin class $RewardsRecordCopyWith<$Res>  {
  factory $RewardsRecordCopyWith(RewardsRecord value, $Res Function(RewardsRecord) _then) = _$RewardsRecordCopyWithImpl;
@useResult
$Res call({
 List<EarnedBadge> earnedBadges, int? lastCelebratedLevel
});




}
/// @nodoc
class _$RewardsRecordCopyWithImpl<$Res>
    implements $RewardsRecordCopyWith<$Res> {
  _$RewardsRecordCopyWithImpl(this._self, this._then);

  final RewardsRecord _self;
  final $Res Function(RewardsRecord) _then;

/// Create a copy of RewardsRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? earnedBadges = null,Object? lastCelebratedLevel = freezed,}) {
  return _then(RewardsRecord(
earnedBadges: null == earnedBadges ? _self.earnedBadges : earnedBadges // ignore: cast_nullable_to_non_nullable
as List<EarnedBadge>,lastCelebratedLevel: freezed == lastCelebratedLevel ? _self.lastCelebratedLevel : lastCelebratedLevel // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [RewardsRecord].
extension RewardsRecordPatterns on RewardsRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RewardsRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RewardsRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RewardsRecord value)  $default,){
final _that = this;
switch (_that) {
case _RewardsRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RewardsRecord value)?  $default,){
final _that = this;
switch (_that) {
case _RewardsRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<EarnedBadge> earnedBadges,  int? lastCelebratedLevel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RewardsRecord() when $default != null:
return $default(_that.earnedBadges,_that.lastCelebratedLevel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<EarnedBadge> earnedBadges,  int? lastCelebratedLevel)  $default,) {final _that = this;
switch (_that) {
case _RewardsRecord():
return $default(_that.earnedBadges,_that.lastCelebratedLevel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<EarnedBadge> earnedBadges,  int? lastCelebratedLevel)?  $default,) {final _that = this;
switch (_that) {
case _RewardsRecord() when $default != null:
return $default(_that.earnedBadges,_that.lastCelebratedLevel);case _:
  return null;

}
}

}

/// @nodoc


class _RewardsRecord extends RewardsRecord {
  const _RewardsRecord({ List<EarnedBadge> earnedBadges = const <EarnedBadge>[], this.lastCelebratedLevel}): _earnedBadges = earnedBadges,super._();
  

 final  List<EarnedBadge> _earnedBadges;
@override@JsonKey() List<EarnedBadge> get earnedBadges {
  if (_earnedBadges is EqualUnmodifiableListView) return _earnedBadges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_earnedBadges);
}

/// Null until the first evaluation, which records silently.
@override final  int? lastCelebratedLevel;

/// Create a copy of RewardsRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RewardsRecordCopyWith<_RewardsRecord> get copyWith => __$RewardsRecordCopyWithImpl<_RewardsRecord>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RewardsRecord&&const DeepCollectionEquality().equals(other.earnedBadges, _earnedBadges)&&(identical(other.lastCelebratedLevel, lastCelebratedLevel) || other.lastCelebratedLevel == lastCelebratedLevel));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_earnedBadges),lastCelebratedLevel);
}

@override
String toString() {
    return 'RewardsRecord(earnedBadges: $earnedBadges, lastCelebratedLevel: $lastCelebratedLevel)';
}


}

/// @nodoc
abstract mixin class _$RewardsRecordCopyWith<$Res> implements $RewardsRecordCopyWith<$Res> {
  factory _$RewardsRecordCopyWith(_RewardsRecord value, $Res Function(_RewardsRecord) _then) = __$RewardsRecordCopyWithImpl;
@override @useResult
$Res call({
 List<EarnedBadge> earnedBadges, int? lastCelebratedLevel
});




}
/// @nodoc
class __$RewardsRecordCopyWithImpl<$Res>
    implements _$RewardsRecordCopyWith<$Res> {
  __$RewardsRecordCopyWithImpl(this._self, this._then);

  final _RewardsRecord _self;
  final $Res Function(_RewardsRecord) _then;

/// Create a copy of RewardsRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? earnedBadges = null,Object? lastCelebratedLevel = freezed,}) {
  return _then(_RewardsRecord(
earnedBadges: null == earnedBadges ? _self._earnedBadges : earnedBadges // ignore: cast_nullable_to_non_nullable
as List<EarnedBadge>,lastCelebratedLevel: freezed == lastCelebratedLevel ? _self.lastCelebratedLevel : lastCelebratedLevel // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
