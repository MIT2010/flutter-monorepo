// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeItem {

 String get id; String get title; String get subtitle; String? get imageUrl;
/// Create a copy of HomeItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeItemCopyWith<HomeItem> get copyWith => _$HomeItemCopyWithImpl<HomeItem>(this as HomeItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,subtitle,imageUrl);

@override
String toString() {
  return 'HomeItem(id: $id, title: $title, subtitle: $subtitle, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $HomeItemCopyWith<$Res>  {
  factory $HomeItemCopyWith(HomeItem value, $Res Function(HomeItem) _then) = _$HomeItemCopyWithImpl;
@useResult
$Res call({
 String id, String title, String subtitle, String? imageUrl
});




}
/// @nodoc
class _$HomeItemCopyWithImpl<$Res>
    implements $HomeItemCopyWith<$Res> {
  _$HomeItemCopyWithImpl(this._self, this._then);

  final HomeItem _self;
  final $Res Function(HomeItem) _then;

/// Create a copy of HomeItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? subtitle = null,Object? imageUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeItem].
extension HomeItemPatterns on HomeItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeItem value)  $default,){
final _that = this;
switch (_that) {
case _HomeItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeItem value)?  $default,){
final _that = this;
switch (_that) {
case _HomeItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String subtitle,  String? imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeItem() when $default != null:
return $default(_that.id,_that.title,_that.subtitle,_that.imageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String subtitle,  String? imageUrl)  $default,) {final _that = this;
switch (_that) {
case _HomeItem():
return $default(_that.id,_that.title,_that.subtitle,_that.imageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String subtitle,  String? imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _HomeItem() when $default != null:
return $default(_that.id,_that.title,_that.subtitle,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc


class _HomeItem implements HomeItem {
  const _HomeItem({required this.id, required this.title, required this.subtitle, this.imageUrl});
  

@override final  String id;
@override final  String title;
@override final  String subtitle;
@override final  String? imageUrl;

/// Create a copy of HomeItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeItemCopyWith<_HomeItem> get copyWith => __$HomeItemCopyWithImpl<_HomeItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,subtitle,imageUrl);

@override
String toString() {
  return 'HomeItem(id: $id, title: $title, subtitle: $subtitle, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$HomeItemCopyWith<$Res> implements $HomeItemCopyWith<$Res> {
  factory _$HomeItemCopyWith(_HomeItem value, $Res Function(_HomeItem) _then) = __$HomeItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String subtitle, String? imageUrl
});




}
/// @nodoc
class __$HomeItemCopyWithImpl<$Res>
    implements _$HomeItemCopyWith<$Res> {
  __$HomeItemCopyWithImpl(this._self, this._then);

  final _HomeItem _self;
  final $Res Function(_HomeItem) _then;

/// Create a copy of HomeItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? subtitle = null,Object? imageUrl = freezed,}) {
  return _then(_HomeItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
