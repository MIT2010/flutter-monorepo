// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HomeItemModel {

 String get id; String get title; String get subtitle; String? get imageUrl;
/// Create a copy of HomeItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeItemModelCopyWith<HomeItemModel> get copyWith => _$HomeItemModelCopyWithImpl<HomeItemModel>(this as HomeItemModel, _$identity);

  /// Serializes this HomeItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,subtitle,imageUrl);

@override
String toString() {
  return 'HomeItemModel(id: $id, title: $title, subtitle: $subtitle, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $HomeItemModelCopyWith<$Res>  {
  factory $HomeItemModelCopyWith(HomeItemModel value, $Res Function(HomeItemModel) _then) = _$HomeItemModelCopyWithImpl;
@useResult
$Res call({
 String id, String title, String subtitle, String? imageUrl
});




}
/// @nodoc
class _$HomeItemModelCopyWithImpl<$Res>
    implements $HomeItemModelCopyWith<$Res> {
  _$HomeItemModelCopyWithImpl(this._self, this._then);

  final HomeItemModel _self;
  final $Res Function(HomeItemModel) _then;

/// Create a copy of HomeItemModel
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


/// Adds pattern-matching-related methods to [HomeItemModel].
extension HomeItemModelPatterns on HomeItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeItemModel value)  $default,){
final _that = this;
switch (_that) {
case _HomeItemModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _HomeItemModel() when $default != null:
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
case _HomeItemModel() when $default != null:
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
case _HomeItemModel():
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
case _HomeItemModel() when $default != null:
return $default(_that.id,_that.title,_that.subtitle,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HomeItemModel extends HomeItemModel {
  const _HomeItemModel({required this.id, required this.title, required this.subtitle, this.imageUrl}): super._();
  factory _HomeItemModel.fromJson(Map<String, dynamic> json) => _$HomeItemModelFromJson(json);

@override final  String id;
@override final  String title;
@override final  String subtitle;
@override final  String? imageUrl;

/// Create a copy of HomeItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeItemModelCopyWith<_HomeItemModel> get copyWith => __$HomeItemModelCopyWithImpl<_HomeItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HomeItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,subtitle,imageUrl);

@override
String toString() {
  return 'HomeItemModel(id: $id, title: $title, subtitle: $subtitle, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$HomeItemModelCopyWith<$Res> implements $HomeItemModelCopyWith<$Res> {
  factory _$HomeItemModelCopyWith(_HomeItemModel value, $Res Function(_HomeItemModel) _then) = __$HomeItemModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String subtitle, String? imageUrl
});




}
/// @nodoc
class __$HomeItemModelCopyWithImpl<$Res>
    implements _$HomeItemModelCopyWith<$Res> {
  __$HomeItemModelCopyWithImpl(this._self, this._then);

  final _HomeItemModel _self;
  final $Res Function(_HomeItemModel) _then;

/// Create a copy of HomeItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? subtitle = null,Object? imageUrl = freezed,}) {
  return _then(_HomeItemModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
