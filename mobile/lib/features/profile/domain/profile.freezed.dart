// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Profile {

 String get name; Gender get gender; double get weightKg; double get heightCm; DateTime get createdAt; DateTime get updatedAt; CalendarDate? get dateOfBirth; int? get age; CalendarDate? get ageSetOn; bool get hasPhoto;
/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileCopyWith<Profile> get copyWith => _$ProfileCopyWithImpl<Profile>(this as Profile, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Profile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Profile&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.gender, _this.gender) || other.gender == _this.gender)&&(identical(other.weightKg, _this.weightKg) || other.weightKg == _this.weightKg)&&(identical(other.heightCm, _this.heightCm) || other.heightCm == _this.heightCm)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.dateOfBirth, _this.dateOfBirth) || other.dateOfBirth == _this.dateOfBirth)&&(identical(other.age, _this.age) || other.age == _this.age)&&(identical(other.ageSetOn, _this.ageSetOn) || other.ageSetOn == _this.ageSetOn)&&(identical(other.hasPhoto, _this.hasPhoto) || other.hasPhoto == _this.hasPhoto));
}


@override
int get hashCode {
  final _this = this as Profile;
  return Object.hash(runtimeType,_this.name,_this.gender,_this.weightKg,_this.heightCm,_this.createdAt,_this.updatedAt,_this.dateOfBirth,_this.age,_this.ageSetOn,_this.hasPhoto);
}

@override
String toString() {
  final _this = this as Profile;
  return 'Profile(name: ${_this.name}, gender: ${_this.gender}, weightKg: ${_this.weightKg}, heightCm: ${_this.heightCm}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, dateOfBirth: ${_this.dateOfBirth}, age: ${_this.age}, ageSetOn: ${_this.ageSetOn}, hasPhoto: ${_this.hasPhoto})';
}


}

/// @nodoc
abstract mixin class $ProfileCopyWith<$Res>  {
  factory $ProfileCopyWith(Profile value, $Res Function(Profile) _then) = _$ProfileCopyWithImpl;
@useResult
$Res call({
 String name, Gender gender, double weightKg, double heightCm, DateTime createdAt, DateTime updatedAt, CalendarDate? dateOfBirth, int? age, CalendarDate? ageSetOn, bool hasPhoto
});




}
/// @nodoc
class _$ProfileCopyWithImpl<$Res>
    implements $ProfileCopyWith<$Res> {
  _$ProfileCopyWithImpl(this._self, this._then);

  final Profile _self;
  final $Res Function(Profile) _then;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? gender = null,Object? weightKg = null,Object? heightCm = null,Object? createdAt = null,Object? updatedAt = null,Object? dateOfBirth = freezed,Object? age = freezed,Object? ageSetOn = freezed,Object? hasPhoto = null,}) {
  return _then(Profile(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender,weightKg: null == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double,heightCm: null == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as CalendarDate?,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,ageSetOn: freezed == ageSetOn ? _self.ageSetOn : ageSetOn // ignore: cast_nullable_to_non_nullable
as CalendarDate?,hasPhoto: null == hasPhoto ? _self.hasPhoto : hasPhoto // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Profile].
extension ProfilePatterns on Profile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Profile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Profile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Profile value)  $default,){
final _that = this;
switch (_that) {
case _Profile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Profile value)?  $default,){
final _that = this;
switch (_that) {
case _Profile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  Gender gender,  double weightKg,  double heightCm,  DateTime createdAt,  DateTime updatedAt,  CalendarDate? dateOfBirth,  int? age,  CalendarDate? ageSetOn,  bool hasPhoto)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Profile() when $default != null:
return $default(_that.name,_that.gender,_that.weightKg,_that.heightCm,_that.createdAt,_that.updatedAt,_that.dateOfBirth,_that.age,_that.ageSetOn,_that.hasPhoto);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  Gender gender,  double weightKg,  double heightCm,  DateTime createdAt,  DateTime updatedAt,  CalendarDate? dateOfBirth,  int? age,  CalendarDate? ageSetOn,  bool hasPhoto)  $default,) {final _that = this;
switch (_that) {
case _Profile():
return $default(_that.name,_that.gender,_that.weightKg,_that.heightCm,_that.createdAt,_that.updatedAt,_that.dateOfBirth,_that.age,_that.ageSetOn,_that.hasPhoto);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  Gender gender,  double weightKg,  double heightCm,  DateTime createdAt,  DateTime updatedAt,  CalendarDate? dateOfBirth,  int? age,  CalendarDate? ageSetOn,  bool hasPhoto)?  $default,) {final _that = this;
switch (_that) {
case _Profile() when $default != null:
return $default(_that.name,_that.gender,_that.weightKg,_that.heightCm,_that.createdAt,_that.updatedAt,_that.dateOfBirth,_that.age,_that.ageSetOn,_that.hasPhoto);case _:
  return null;

}
}

}

/// @nodoc


class _Profile implements Profile {
  const _Profile({required this.name, required this.gender, required this.weightKg, required this.heightCm, required this.createdAt, required this.updatedAt, this.dateOfBirth, this.age, this.ageSetOn, this.hasPhoto = false});
  

@override final  String name;
@override final  Gender gender;
@override final  double weightKg;
@override final  double heightCm;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  CalendarDate? dateOfBirth;
@override final  int? age;
@override final  CalendarDate? ageSetOn;
@override@JsonKey() final  bool hasPhoto;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileCopyWith<_Profile> get copyWith => __$ProfileCopyWithImpl<_Profile>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Profile&&(identical(other.name, name) || other.name == name)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.heightCm, heightCm) || other.heightCm == heightCm)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.age, age) || other.age == age)&&(identical(other.ageSetOn, ageSetOn) || other.ageSetOn == ageSetOn)&&(identical(other.hasPhoto, hasPhoto) || other.hasPhoto == hasPhoto));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,gender,weightKg,heightCm,createdAt,updatedAt,dateOfBirth,age,ageSetOn,hasPhoto);
}

@override
String toString() {
    return 'Profile(name: $name, gender: $gender, weightKg: $weightKg, heightCm: $heightCm, createdAt: $createdAt, updatedAt: $updatedAt, dateOfBirth: $dateOfBirth, age: $age, ageSetOn: $ageSetOn, hasPhoto: $hasPhoto)';
}


}

/// @nodoc
abstract mixin class _$ProfileCopyWith<$Res> implements $ProfileCopyWith<$Res> {
  factory _$ProfileCopyWith(_Profile value, $Res Function(_Profile) _then) = __$ProfileCopyWithImpl;
@override @useResult
$Res call({
 String name, Gender gender, double weightKg, double heightCm, DateTime createdAt, DateTime updatedAt, CalendarDate? dateOfBirth, int? age, CalendarDate? ageSetOn, bool hasPhoto
});




}
/// @nodoc
class __$ProfileCopyWithImpl<$Res>
    implements _$ProfileCopyWith<$Res> {
  __$ProfileCopyWithImpl(this._self, this._then);

  final _Profile _self;
  final $Res Function(_Profile) _then;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? gender = null,Object? weightKg = null,Object? heightCm = null,Object? createdAt = null,Object? updatedAt = null,Object? dateOfBirth = freezed,Object? age = freezed,Object? ageSetOn = freezed,Object? hasPhoto = null,}) {
  return _then(_Profile(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender,weightKg: null == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double,heightCm: null == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as CalendarDate?,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,ageSetOn: freezed == ageSetOn ? _self.ageSetOn : ageSetOn // ignore: cast_nullable_to_non_nullable
as CalendarDate?,hasPhoto: null == hasPhoto ? _self.hasPhoto : hasPhoto // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
