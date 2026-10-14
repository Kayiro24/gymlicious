// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quote_cache.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuoteCache {

 List<Quote> get quotes; Map<String, RateBudget> get budgets; DateTime? get lastBackgroundRefresh;
/// Create a copy of QuoteCache
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuoteCacheCopyWith<QuoteCache> get copyWith => _$QuoteCacheCopyWithImpl<QuoteCache>(this as QuoteCache, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as QuoteCache;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuoteCache&&const DeepCollectionEquality().equals(other.quotes, _this.quotes)&&const DeepCollectionEquality().equals(other.budgets, _this.budgets)&&(identical(other.lastBackgroundRefresh, _this.lastBackgroundRefresh) || other.lastBackgroundRefresh == _this.lastBackgroundRefresh));
}


@override
int get hashCode {
  final _this = this as QuoteCache;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.quotes),const DeepCollectionEquality().hash(_this.budgets),_this.lastBackgroundRefresh);
}

@override
String toString() {
  final _this = this as QuoteCache;
  return 'QuoteCache(quotes: ${_this.quotes}, budgets: ${_this.budgets}, lastBackgroundRefresh: ${_this.lastBackgroundRefresh})';
}


}

/// @nodoc
abstract mixin class $QuoteCacheCopyWith<$Res>  {
  factory $QuoteCacheCopyWith(QuoteCache value, $Res Function(QuoteCache) _then) = _$QuoteCacheCopyWithImpl;
@useResult
$Res call({
 List<Quote> quotes, Map<String, RateBudget> budgets, DateTime? lastBackgroundRefresh
});




}
/// @nodoc
class _$QuoteCacheCopyWithImpl<$Res>
    implements $QuoteCacheCopyWith<$Res> {
  _$QuoteCacheCopyWithImpl(this._self, this._then);

  final QuoteCache _self;
  final $Res Function(QuoteCache) _then;

/// Create a copy of QuoteCache
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? quotes = null,Object? budgets = null,Object? lastBackgroundRefresh = freezed,}) {
  return _then(QuoteCache(
quotes: null == quotes ? _self.quotes : quotes // ignore: cast_nullable_to_non_nullable
as List<Quote>,budgets: null == budgets ? _self.budgets : budgets // ignore: cast_nullable_to_non_nullable
as Map<String, RateBudget>,lastBackgroundRefresh: freezed == lastBackgroundRefresh ? _self.lastBackgroundRefresh : lastBackgroundRefresh // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [QuoteCache].
extension QuoteCachePatterns on QuoteCache {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuoteCache value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuoteCache() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuoteCache value)  $default,){
final _that = this;
switch (_that) {
case _QuoteCache():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuoteCache value)?  $default,){
final _that = this;
switch (_that) {
case _QuoteCache() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Quote> quotes,  Map<String, RateBudget> budgets,  DateTime? lastBackgroundRefresh)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuoteCache() when $default != null:
return $default(_that.quotes,_that.budgets,_that.lastBackgroundRefresh);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Quote> quotes,  Map<String, RateBudget> budgets,  DateTime? lastBackgroundRefresh)  $default,) {final _that = this;
switch (_that) {
case _QuoteCache():
return $default(_that.quotes,_that.budgets,_that.lastBackgroundRefresh);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Quote> quotes,  Map<String, RateBudget> budgets,  DateTime? lastBackgroundRefresh)?  $default,) {final _that = this;
switch (_that) {
case _QuoteCache() when $default != null:
return $default(_that.quotes,_that.budgets,_that.lastBackgroundRefresh);case _:
  return null;

}
}

}

/// @nodoc


class _QuoteCache extends QuoteCache {
  const _QuoteCache({ List<Quote> quotes = const <Quote>[],  Map<String, RateBudget> budgets = const <String, RateBudget>{}, this.lastBackgroundRefresh}): _quotes = quotes,_budgets = budgets,super._();
  

 final  List<Quote> _quotes;
@override@JsonKey() List<Quote> get quotes {
  if (_quotes is EqualUnmodifiableListView) return _quotes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_quotes);
}

 final  Map<String, RateBudget> _budgets;
@override@JsonKey() Map<String, RateBudget> get budgets {
  if (_budgets is EqualUnmodifiableMapView) return _budgets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_budgets);
}

@override final  DateTime? lastBackgroundRefresh;

/// Create a copy of QuoteCache
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuoteCacheCopyWith<_QuoteCache> get copyWith => __$QuoteCacheCopyWithImpl<_QuoteCache>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuoteCache&&const DeepCollectionEquality().equals(other.quotes, _quotes)&&const DeepCollectionEquality().equals(other.budgets, _budgets)&&(identical(other.lastBackgroundRefresh, lastBackgroundRefresh) || other.lastBackgroundRefresh == lastBackgroundRefresh));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_quotes),const DeepCollectionEquality().hash(_budgets),lastBackgroundRefresh);
}

@override
String toString() {
    return 'QuoteCache(quotes: $quotes, budgets: $budgets, lastBackgroundRefresh: $lastBackgroundRefresh)';
}


}

/// @nodoc
abstract mixin class _$QuoteCacheCopyWith<$Res> implements $QuoteCacheCopyWith<$Res> {
  factory _$QuoteCacheCopyWith(_QuoteCache value, $Res Function(_QuoteCache) _then) = __$QuoteCacheCopyWithImpl;
@override @useResult
$Res call({
 List<Quote> quotes, Map<String, RateBudget> budgets, DateTime? lastBackgroundRefresh
});




}
/// @nodoc
class __$QuoteCacheCopyWithImpl<$Res>
    implements _$QuoteCacheCopyWith<$Res> {
  __$QuoteCacheCopyWithImpl(this._self, this._then);

  final _QuoteCache _self;
  final $Res Function(_QuoteCache) _then;

/// Create a copy of QuoteCache
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? quotes = null,Object? budgets = null,Object? lastBackgroundRefresh = freezed,}) {
  return _then(_QuoteCache(
quotes: null == quotes ? _self._quotes : quotes // ignore: cast_nullable_to_non_nullable
as List<Quote>,budgets: null == budgets ? _self._budgets : budgets // ignore: cast_nullable_to_non_nullable
as Map<String, RateBudget>,lastBackgroundRefresh: freezed == lastBackgroundRefresh ? _self.lastBackgroundRefresh : lastBackgroundRefresh // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
