// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileDraft {

 String get name; Gender? get gender; String get weight; String get heightCm; String get heightFeet; String get heightInches; CalendarDate? get dateOfBirth; String get age; bool get usesAge; WeightUnit get weightUnit; HeightUnit get heightUnit;
/// Create a copy of ProfileDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileDraftCopyWith<ProfileDraft> get copyWith => _$ProfileDraftCopyWithImpl<ProfileDraft>(this as ProfileDraft, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProfileDraft;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileDraft&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.gender, _this.gender) || other.gender == _this.gender)&&(identical(other.weight, _this.weight) || other.weight == _this.weight)&&(identical(other.heightCm, _this.heightCm) || other.heightCm == _this.heightCm)&&(identical(other.heightFeet, _this.heightFeet) || other.heightFeet == _this.heightFeet)&&(identical(other.heightInches, _this.heightInches) || other.heightInches == _this.heightInches)&&(identical(other.dateOfBirth, _this.dateOfBirth) || other.dateOfBirth == _this.dateOfBirth)&&(identical(other.age, _this.age) || other.age == _this.age)&&(identical(other.usesAge, _this.usesAge) || other.usesAge == _this.usesAge)&&(identical(other.weightUnit, _this.weightUnit) || other.weightUnit == _this.weightUnit)&&(identical(other.heightUnit, _this.heightUnit) || other.heightUnit == _this.heightUnit));
}


@override
int get hashCode {
  final _this = this as ProfileDraft;
  return Object.hash(runtimeType,_this.name,_this.gender,_this.weight,_this.heightCm,_this.heightFeet,_this.heightInches,_this.dateOfBirth,_this.age,_this.usesAge,_this.weightUnit,_this.heightUnit);
}

@override
String toString() {
  final _this = this as ProfileDraft;
  return 'ProfileDraft(name: ${_this.name}, gender: ${_this.gender}, weight: ${_this.weight}, heightCm: ${_this.heightCm}, heightFeet: ${_this.heightFeet}, heightInches: ${_this.heightInches}, dateOfBirth: ${_this.dateOfBirth}, age: ${_this.age}, usesAge: ${_this.usesAge}, weightUnit: ${_this.weightUnit}, heightUnit: ${_this.heightUnit})';
}


}

/// @nodoc
abstract mixin class $ProfileDraftCopyWith<$Res>  {
  factory $ProfileDraftCopyWith(ProfileDraft value, $Res Function(ProfileDraft) _then) = _$ProfileDraftCopyWithImpl;
@useResult
$Res call({
 String name, Gender? gender, String weight, String heightCm, String heightFeet, String heightInches, CalendarDate? dateOfBirth, String age, bool usesAge, WeightUnit weightUnit, HeightUnit heightUnit
});




}
/// @nodoc
class _$ProfileDraftCopyWithImpl<$Res>
    implements $ProfileDraftCopyWith<$Res> {
  _$ProfileDraftCopyWithImpl(this._self, this._then);

  final ProfileDraft _self;
  final $Res Function(ProfileDraft) _then;

/// Create a copy of ProfileDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? gender = freezed,Object? weight = null,Object? heightCm = null,Object? heightFeet = null,Object? heightInches = null,Object? dateOfBirth = freezed,Object? age = null,Object? usesAge = null,Object? weightUnit = null,Object? heightUnit = null,}) {
  return _then(ProfileDraft(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender?,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as String,heightCm: null == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as String,heightFeet: null == heightFeet ? _self.heightFeet : heightFeet // ignore: cast_nullable_to_non_nullable
as String,heightInches: null == heightInches ? _self.heightInches : heightInches // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as CalendarDate?,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as String,usesAge: null == usesAge ? _self.usesAge : usesAge // ignore: cast_nullable_to_non_nullable
as bool,weightUnit: null == weightUnit ? _self.weightUnit : weightUnit // ignore: cast_nullable_to_non_nullable
as WeightUnit,heightUnit: null == heightUnit ? _self.heightUnit : heightUnit // ignore: cast_nullable_to_non_nullable
as HeightUnit,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileDraft].
extension ProfileDraftPatterns on ProfileDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileDraft value)  $default,){
final _that = this;
switch (_that) {
case _ProfileDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileDraft value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  Gender? gender,  String weight,  String heightCm,  String heightFeet,  String heightInches,  CalendarDate? dateOfBirth,  String age,  bool usesAge,  WeightUnit weightUnit,  HeightUnit heightUnit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileDraft() when $default != null:
return $default(_that.name,_that.gender,_that.weight,_that.heightCm,_that.heightFeet,_that.heightInches,_that.dateOfBirth,_that.age,_that.usesAge,_that.weightUnit,_that.heightUnit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  Gender? gender,  String weight,  String heightCm,  String heightFeet,  String heightInches,  CalendarDate? dateOfBirth,  String age,  bool usesAge,  WeightUnit weightUnit,  HeightUnit heightUnit)  $default,) {final _that = this;
switch (_that) {
case _ProfileDraft():
return $default(_that.name,_that.gender,_that.weight,_that.heightCm,_that.heightFeet,_that.heightInches,_that.dateOfBirth,_that.age,_that.usesAge,_that.weightUnit,_that.heightUnit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  Gender? gender,  String weight,  String heightCm,  String heightFeet,  String heightInches,  CalendarDate? dateOfBirth,  String age,  bool usesAge,  WeightUnit weightUnit,  HeightUnit heightUnit)?  $default,) {final _that = this;
switch (_that) {
case _ProfileDraft() when $default != null:
return $default(_that.name,_that.gender,_that.weight,_that.heightCm,_that.heightFeet,_that.heightInches,_that.dateOfBirth,_that.age,_that.usesAge,_that.weightUnit,_that.heightUnit);case _:
  return null;

}
}

}

/// @nodoc


class _ProfileDraft implements ProfileDraft {
  const _ProfileDraft({this.name = '', this.gender, this.weight = '', this.heightCm = '', this.heightFeet = '', this.heightInches = '', this.dateOfBirth, this.age = '', this.usesAge = false, this.weightUnit = WeightUnit.kg, this.heightUnit = HeightUnit.cm});
  

@override@JsonKey() final  String name;
@override final  Gender? gender;
@override@JsonKey() final  String weight;
@override@JsonKey() final  String heightCm;
@override@JsonKey() final  String heightFeet;
@override@JsonKey() final  String heightInches;
@override final  CalendarDate? dateOfBirth;
@override@JsonKey() final  String age;
@override@JsonKey() final  bool usesAge;
@override@JsonKey() final  WeightUnit weightUnit;
@override@JsonKey() final  HeightUnit heightUnit;

/// Create a copy of ProfileDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileDraftCopyWith<_ProfileDraft> get copyWith => __$ProfileDraftCopyWithImpl<_ProfileDraft>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileDraft&&(identical(other.name, name) || other.name == name)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.heightCm, heightCm) || other.heightCm == heightCm)&&(identical(other.heightFeet, heightFeet) || other.heightFeet == heightFeet)&&(identical(other.heightInches, heightInches) || other.heightInches == heightInches)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.age, age) || other.age == age)&&(identical(other.usesAge, usesAge) || other.usesAge == usesAge)&&(identical(other.weightUnit, weightUnit) || other.weightUnit == weightUnit)&&(identical(other.heightUnit, heightUnit) || other.heightUnit == heightUnit));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,gender,weight,heightCm,heightFeet,heightInches,dateOfBirth,age,usesAge,weightUnit,heightUnit);
}

@override
String toString() {
    return 'ProfileDraft(name: $name, gender: $gender, weight: $weight, heightCm: $heightCm, heightFeet: $heightFeet, heightInches: $heightInches, dateOfBirth: $dateOfBirth, age: $age, usesAge: $usesAge, weightUnit: $weightUnit, heightUnit: $heightUnit)';
}


}

/// @nodoc
abstract mixin class _$ProfileDraftCopyWith<$Res> implements $ProfileDraftCopyWith<$Res> {
  factory _$ProfileDraftCopyWith(_ProfileDraft value, $Res Function(_ProfileDraft) _then) = __$ProfileDraftCopyWithImpl;
@override @useResult
$Res call({
 String name, Gender? gender, String weight, String heightCm, String heightFeet, String heightInches, CalendarDate? dateOfBirth, String age, bool usesAge, WeightUnit weightUnit, HeightUnit heightUnit
});




}
/// @nodoc
class __$ProfileDraftCopyWithImpl<$Res>
    implements _$ProfileDraftCopyWith<$Res> {
  __$ProfileDraftCopyWithImpl(this._self, this._then);

  final _ProfileDraft _self;
  final $Res Function(_ProfileDraft) _then;

/// Create a copy of ProfileDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? gender = freezed,Object? weight = null,Object? heightCm = null,Object? heightFeet = null,Object? heightInches = null,Object? dateOfBirth = freezed,Object? age = null,Object? usesAge = null,Object? weightUnit = null,Object? heightUnit = null,}) {
  return _then(_ProfileDraft(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender?,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as String,heightCm: null == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as String,heightFeet: null == heightFeet ? _self.heightFeet : heightFeet // ignore: cast_nullable_to_non_nullable
as String,heightInches: null == heightInches ? _self.heightInches : heightInches // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as CalendarDate?,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as String,usesAge: null == usesAge ? _self.usesAge : usesAge // ignore: cast_nullable_to_non_nullable
as bool,weightUnit: null == weightUnit ? _self.weightUnit : weightUnit // ignore: cast_nullable_to_non_nullable
as WeightUnit,heightUnit: null == heightUnit ? _self.heightUnit : heightUnit // ignore: cast_nullable_to_non_nullable
as HeightUnit,
  ));
}


}

// dart format on
