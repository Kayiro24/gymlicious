// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'split.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SplitDay {

 String get id; String get name; bool get isRest; List<String> get exerciseIds;
/// Create a copy of SplitDay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SplitDayCopyWith<SplitDay> get copyWith => _$SplitDayCopyWithImpl<SplitDay>(this as SplitDay, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SplitDay;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SplitDay&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.isRest, _this.isRest) || other.isRest == _this.isRest)&&const DeepCollectionEquality().equals(other.exerciseIds, _this.exerciseIds));
}


@override
int get hashCode {
  final _this = this as SplitDay;
  return Object.hash(runtimeType,_this.id,_this.name,_this.isRest,const DeepCollectionEquality().hash(_this.exerciseIds));
}

@override
String toString() {
  final _this = this as SplitDay;
  return 'SplitDay(id: ${_this.id}, name: ${_this.name}, isRest: ${_this.isRest}, exerciseIds: ${_this.exerciseIds})';
}


}

/// @nodoc
abstract mixin class $SplitDayCopyWith<$Res>  {
  factory $SplitDayCopyWith(SplitDay value, $Res Function(SplitDay) _then) = _$SplitDayCopyWithImpl;
@useResult
$Res call({
 String id, String name, bool isRest, List<String> exerciseIds
});




}
/// @nodoc
class _$SplitDayCopyWithImpl<$Res>
    implements $SplitDayCopyWith<$Res> {
  _$SplitDayCopyWithImpl(this._self, this._then);

  final SplitDay _self;
  final $Res Function(SplitDay) _then;

/// Create a copy of SplitDay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? isRest = null,Object? exerciseIds = null,}) {
  return _then(SplitDay(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isRest: null == isRest ? _self.isRest : isRest // ignore: cast_nullable_to_non_nullable
as bool,exerciseIds: null == exerciseIds ? _self.exerciseIds : exerciseIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [SplitDay].
extension SplitDayPatterns on SplitDay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SplitDay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SplitDay() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SplitDay value)  $default,){
final _that = this;
switch (_that) {
case _SplitDay():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SplitDay value)?  $default,){
final _that = this;
switch (_that) {
case _SplitDay() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  bool isRest,  List<String> exerciseIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SplitDay() when $default != null:
return $default(_that.id,_that.name,_that.isRest,_that.exerciseIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  bool isRest,  List<String> exerciseIds)  $default,) {final _that = this;
switch (_that) {
case _SplitDay():
return $default(_that.id,_that.name,_that.isRest,_that.exerciseIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  bool isRest,  List<String> exerciseIds)?  $default,) {final _that = this;
switch (_that) {
case _SplitDay() when $default != null:
return $default(_that.id,_that.name,_that.isRest,_that.exerciseIds);case _:
  return null;

}
}

}

/// @nodoc


class _SplitDay implements SplitDay {
  const _SplitDay({required this.id, required this.name, this.isRest = false,  List<String> exerciseIds = const <String>[]}): _exerciseIds = exerciseIds;
  

@override final  String id;
@override final  String name;
@override@JsonKey() final  bool isRest;
 final  List<String> _exerciseIds;
@override@JsonKey() List<String> get exerciseIds {
  if (_exerciseIds is EqualUnmodifiableListView) return _exerciseIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exerciseIds);
}


/// Create a copy of SplitDay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SplitDayCopyWith<_SplitDay> get copyWith => __$SplitDayCopyWithImpl<_SplitDay>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SplitDay&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.isRest, isRest) || other.isRest == isRest)&&const DeepCollectionEquality().equals(other.exerciseIds, _exerciseIds));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,isRest,const DeepCollectionEquality().hash(_exerciseIds));
}

@override
String toString() {
    return 'SplitDay(id: $id, name: $name, isRest: $isRest, exerciseIds: $exerciseIds)';
}


}

/// @nodoc
abstract mixin class _$SplitDayCopyWith<$Res> implements $SplitDayCopyWith<$Res> {
  factory _$SplitDayCopyWith(_SplitDay value, $Res Function(_SplitDay) _then) = __$SplitDayCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, bool isRest, List<String> exerciseIds
});




}
/// @nodoc
class __$SplitDayCopyWithImpl<$Res>
    implements _$SplitDayCopyWith<$Res> {
  __$SplitDayCopyWithImpl(this._self, this._then);

  final _SplitDay _self;
  final $Res Function(_SplitDay) _then;

/// Create a copy of SplitDay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? isRest = null,Object? exerciseIds = null,}) {
  return _then(_SplitDay(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isRest: null == isRest ? _self.isRest : isRest // ignore: cast_nullable_to_non_nullable
as bool,exerciseIds: null == exerciseIds ? _self._exerciseIds : exerciseIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc
mixin _$WorkoutSplit {

 String get id; String get name; bool get isPreset; List<SplitDay> get days;
/// Create a copy of WorkoutSplit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutSplitCopyWith<WorkoutSplit> get copyWith => _$WorkoutSplitCopyWithImpl<WorkoutSplit>(this as WorkoutSplit, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as WorkoutSplit;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkoutSplit&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.isPreset, _this.isPreset) || other.isPreset == _this.isPreset)&&const DeepCollectionEquality().equals(other.days, _this.days));
}


@override
int get hashCode {
  final _this = this as WorkoutSplit;
  return Object.hash(runtimeType,_this.id,_this.name,_this.isPreset,const DeepCollectionEquality().hash(_this.days));
}

@override
String toString() {
  final _this = this as WorkoutSplit;
  return 'WorkoutSplit(id: ${_this.id}, name: ${_this.name}, isPreset: ${_this.isPreset}, days: ${_this.days})';
}


}

/// @nodoc
abstract mixin class $WorkoutSplitCopyWith<$Res>  {
  factory $WorkoutSplitCopyWith(WorkoutSplit value, $Res Function(WorkoutSplit) _then) = _$WorkoutSplitCopyWithImpl;
@useResult
$Res call({
 String id, String name, bool isPreset, List<SplitDay> days
});




}
/// @nodoc
class _$WorkoutSplitCopyWithImpl<$Res>
    implements $WorkoutSplitCopyWith<$Res> {
  _$WorkoutSplitCopyWithImpl(this._self, this._then);

  final WorkoutSplit _self;
  final $Res Function(WorkoutSplit) _then;

/// Create a copy of WorkoutSplit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? isPreset = null,Object? days = null,}) {
  return _then(WorkoutSplit(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isPreset: null == isPreset ? _self.isPreset : isPreset // ignore: cast_nullable_to_non_nullable
as bool,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as List<SplitDay>,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkoutSplit].
extension WorkoutSplitPatterns on WorkoutSplit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkoutSplit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkoutSplit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkoutSplit value)  $default,){
final _that = this;
switch (_that) {
case _WorkoutSplit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkoutSplit value)?  $default,){
final _that = this;
switch (_that) {
case _WorkoutSplit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  bool isPreset,  List<SplitDay> days)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkoutSplit() when $default != null:
return $default(_that.id,_that.name,_that.isPreset,_that.days);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  bool isPreset,  List<SplitDay> days)  $default,) {final _that = this;
switch (_that) {
case _WorkoutSplit():
return $default(_that.id,_that.name,_that.isPreset,_that.days);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  bool isPreset,  List<SplitDay> days)?  $default,) {final _that = this;
switch (_that) {
case _WorkoutSplit() when $default != null:
return $default(_that.id,_that.name,_that.isPreset,_that.days);case _:
  return null;

}
}

}

/// @nodoc


class _WorkoutSplit extends WorkoutSplit {
  const _WorkoutSplit({required this.id, required this.name, this.isPreset = false,  List<SplitDay> days = const <SplitDay>[]}): _days = days,super._();
  

@override final  String id;
@override final  String name;
@override@JsonKey() final  bool isPreset;
 final  List<SplitDay> _days;
@override@JsonKey() List<SplitDay> get days {
  if (_days is EqualUnmodifiableListView) return _days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_days);
}


/// Create a copy of WorkoutSplit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkoutSplitCopyWith<_WorkoutSplit> get copyWith => __$WorkoutSplitCopyWithImpl<_WorkoutSplit>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkoutSplit&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.isPreset, isPreset) || other.isPreset == isPreset)&&const DeepCollectionEquality().equals(other.days, _days));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,isPreset,const DeepCollectionEquality().hash(_days));
}

@override
String toString() {
    return 'WorkoutSplit(id: $id, name: $name, isPreset: $isPreset, days: $days)';
}


}

/// @nodoc
abstract mixin class _$WorkoutSplitCopyWith<$Res> implements $WorkoutSplitCopyWith<$Res> {
  factory _$WorkoutSplitCopyWith(_WorkoutSplit value, $Res Function(_WorkoutSplit) _then) = __$WorkoutSplitCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, bool isPreset, List<SplitDay> days
});




}
/// @nodoc
class __$WorkoutSplitCopyWithImpl<$Res>
    implements _$WorkoutSplitCopyWith<$Res> {
  __$WorkoutSplitCopyWithImpl(this._self, this._then);

  final _WorkoutSplit _self;
  final $Res Function(_WorkoutSplit) _then;

/// Create a copy of WorkoutSplit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? isPreset = null,Object? days = null,}) {
  return _then(_WorkoutSplit(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isPreset: null == isPreset ? _self.isPreset : isPreset // ignore: cast_nullable_to_non_nullable
as bool,days: null == days ? _self._days : days // ignore: cast_nullable_to_non_nullable
as List<SplitDay>,
  ));
}


}

// dart format on
