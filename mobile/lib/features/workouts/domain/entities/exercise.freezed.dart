// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Exercise {

 String get id; String get name; MuscleGroup get muscleGroup; Equipment get equipment; bool get isCustom; bool get isArchived; double? get baselineMaxKg; double? get baselineLastKg; CalendarDate? get baselineLastDate; String get notes;
/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseCopyWith<Exercise> get copyWith => _$ExerciseCopyWithImpl<Exercise>(this as Exercise, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Exercise;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Exercise&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.muscleGroup, _this.muscleGroup) || other.muscleGroup == _this.muscleGroup)&&(identical(other.equipment, _this.equipment) || other.equipment == _this.equipment)&&(identical(other.isCustom, _this.isCustom) || other.isCustom == _this.isCustom)&&(identical(other.isArchived, _this.isArchived) || other.isArchived == _this.isArchived)&&(identical(other.baselineMaxKg, _this.baselineMaxKg) || other.baselineMaxKg == _this.baselineMaxKg)&&(identical(other.baselineLastKg, _this.baselineLastKg) || other.baselineLastKg == _this.baselineLastKg)&&(identical(other.baselineLastDate, _this.baselineLastDate) || other.baselineLastDate == _this.baselineLastDate)&&(identical(other.notes, _this.notes) || other.notes == _this.notes));
}


@override
int get hashCode {
  final _this = this as Exercise;
  return Object.hash(runtimeType,_this.id,_this.name,_this.muscleGroup,_this.equipment,_this.isCustom,_this.isArchived,_this.baselineMaxKg,_this.baselineLastKg,_this.baselineLastDate,_this.notes);
}

@override
String toString() {
  final _this = this as Exercise;
  return 'Exercise(id: ${_this.id}, name: ${_this.name}, muscleGroup: ${_this.muscleGroup}, equipment: ${_this.equipment}, isCustom: ${_this.isCustom}, isArchived: ${_this.isArchived}, baselineMaxKg: ${_this.baselineMaxKg}, baselineLastKg: ${_this.baselineLastKg}, baselineLastDate: ${_this.baselineLastDate}, notes: ${_this.notes})';
}


}

/// @nodoc
abstract mixin class $ExerciseCopyWith<$Res>  {
  factory $ExerciseCopyWith(Exercise value, $Res Function(Exercise) _then) = _$ExerciseCopyWithImpl;
@useResult
$Res call({
 String id, String name, MuscleGroup muscleGroup, Equipment equipment, bool isCustom, bool isArchived, double? baselineMaxKg, double? baselineLastKg, CalendarDate? baselineLastDate, String notes
});




}
/// @nodoc
class _$ExerciseCopyWithImpl<$Res>
    implements $ExerciseCopyWith<$Res> {
  _$ExerciseCopyWithImpl(this._self, this._then);

  final Exercise _self;
  final $Res Function(Exercise) _then;

/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? muscleGroup = null,Object? equipment = null,Object? isCustom = null,Object? isArchived = null,Object? baselineMaxKg = freezed,Object? baselineLastKg = freezed,Object? baselineLastDate = freezed,Object? notes = null,}) {
  return _then(Exercise(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,muscleGroup: null == muscleGroup ? _self.muscleGroup : muscleGroup // ignore: cast_nullable_to_non_nullable
as MuscleGroup,equipment: null == equipment ? _self.equipment : equipment // ignore: cast_nullable_to_non_nullable
as Equipment,isCustom: null == isCustom ? _self.isCustom : isCustom // ignore: cast_nullable_to_non_nullable
as bool,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,baselineMaxKg: freezed == baselineMaxKg ? _self.baselineMaxKg : baselineMaxKg // ignore: cast_nullable_to_non_nullable
as double?,baselineLastKg: freezed == baselineLastKg ? _self.baselineLastKg : baselineLastKg // ignore: cast_nullable_to_non_nullable
as double?,baselineLastDate: freezed == baselineLastDate ? _self.baselineLastDate : baselineLastDate // ignore: cast_nullable_to_non_nullable
as CalendarDate?,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Exercise].
extension ExercisePatterns on Exercise {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Exercise value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Exercise() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Exercise value)  $default,){
final _that = this;
switch (_that) {
case _Exercise():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Exercise value)?  $default,){
final _that = this;
switch (_that) {
case _Exercise() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  MuscleGroup muscleGroup,  Equipment equipment,  bool isCustom,  bool isArchived,  double? baselineMaxKg,  double? baselineLastKg,  CalendarDate? baselineLastDate,  String notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Exercise() when $default != null:
return $default(_that.id,_that.name,_that.muscleGroup,_that.equipment,_that.isCustom,_that.isArchived,_that.baselineMaxKg,_that.baselineLastKg,_that.baselineLastDate,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  MuscleGroup muscleGroup,  Equipment equipment,  bool isCustom,  bool isArchived,  double? baselineMaxKg,  double? baselineLastKg,  CalendarDate? baselineLastDate,  String notes)  $default,) {final _that = this;
switch (_that) {
case _Exercise():
return $default(_that.id,_that.name,_that.muscleGroup,_that.equipment,_that.isCustom,_that.isArchived,_that.baselineMaxKg,_that.baselineLastKg,_that.baselineLastDate,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  MuscleGroup muscleGroup,  Equipment equipment,  bool isCustom,  bool isArchived,  double? baselineMaxKg,  double? baselineLastKg,  CalendarDate? baselineLastDate,  String notes)?  $default,) {final _that = this;
switch (_that) {
case _Exercise() when $default != null:
return $default(_that.id,_that.name,_that.muscleGroup,_that.equipment,_that.isCustom,_that.isArchived,_that.baselineMaxKg,_that.baselineLastKg,_that.baselineLastDate,_that.notes);case _:
  return null;

}
}

}

/// @nodoc


class _Exercise extends Exercise {
  const _Exercise({required this.id, required this.name, required this.muscleGroup, required this.equipment, this.isCustom = false, this.isArchived = false, this.baselineMaxKg, this.baselineLastKg, this.baselineLastDate, this.notes = ''}): super._();
  

@override final  String id;
@override final  String name;
@override final  MuscleGroup muscleGroup;
@override final  Equipment equipment;
@override@JsonKey() final  bool isCustom;
@override@JsonKey() final  bool isArchived;
@override final  double? baselineMaxKg;
@override final  double? baselineLastKg;
@override final  CalendarDate? baselineLastDate;
@override@JsonKey() final  String notes;

/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseCopyWith<_Exercise> get copyWith => __$ExerciseCopyWithImpl<_Exercise>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Exercise&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.muscleGroup, muscleGroup) || other.muscleGroup == muscleGroup)&&(identical(other.equipment, equipment) || other.equipment == equipment)&&(identical(other.isCustom, isCustom) || other.isCustom == isCustom)&&(identical(other.isArchived, isArchived) || other.isArchived == isArchived)&&(identical(other.baselineMaxKg, baselineMaxKg) || other.baselineMaxKg == baselineMaxKg)&&(identical(other.baselineLastKg, baselineLastKg) || other.baselineLastKg == baselineLastKg)&&(identical(other.baselineLastDate, baselineLastDate) || other.baselineLastDate == baselineLastDate)&&(identical(other.notes, notes) || other.notes == notes));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,muscleGroup,equipment,isCustom,isArchived,baselineMaxKg,baselineLastKg,baselineLastDate,notes);
}

@override
String toString() {
    return 'Exercise(id: $id, name: $name, muscleGroup: $muscleGroup, equipment: $equipment, isCustom: $isCustom, isArchived: $isArchived, baselineMaxKg: $baselineMaxKg, baselineLastKg: $baselineLastKg, baselineLastDate: $baselineLastDate, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$ExerciseCopyWith<$Res> implements $ExerciseCopyWith<$Res> {
  factory _$ExerciseCopyWith(_Exercise value, $Res Function(_Exercise) _then) = __$ExerciseCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, MuscleGroup muscleGroup, Equipment equipment, bool isCustom, bool isArchived, double? baselineMaxKg, double? baselineLastKg, CalendarDate? baselineLastDate, String notes
});




}
/// @nodoc
class __$ExerciseCopyWithImpl<$Res>
    implements _$ExerciseCopyWith<$Res> {
  __$ExerciseCopyWithImpl(this._self, this._then);

  final _Exercise _self;
  final $Res Function(_Exercise) _then;

/// Create a copy of Exercise
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? muscleGroup = null,Object? equipment = null,Object? isCustom = null,Object? isArchived = null,Object? baselineMaxKg = freezed,Object? baselineLastKg = freezed,Object? baselineLastDate = freezed,Object? notes = null,}) {
  return _then(_Exercise(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,muscleGroup: null == muscleGroup ? _self.muscleGroup : muscleGroup // ignore: cast_nullable_to_non_nullable
as MuscleGroup,equipment: null == equipment ? _self.equipment : equipment // ignore: cast_nullable_to_non_nullable
as Equipment,isCustom: null == isCustom ? _self.isCustom : isCustom // ignore: cast_nullable_to_non_nullable
as bool,isArchived: null == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool,baselineMaxKg: freezed == baselineMaxKg ? _self.baselineMaxKg : baselineMaxKg // ignore: cast_nullable_to_non_nullable
as double?,baselineLastKg: freezed == baselineLastKg ? _self.baselineLastKg : baselineLastKg // ignore: cast_nullable_to_non_nullable
as double?,baselineLastDate: freezed == baselineLastDate ? _self.baselineLastDate : baselineLastDate // ignore: cast_nullable_to_non_nullable
as CalendarDate?,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
