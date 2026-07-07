// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_item_model.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class HomeItemModelAdapter extends TypeAdapter<HomeItemModel> {
  @override
  final typeId = 0;

  @override
  HomeItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HomeItemModel(
      id: fields[0] as String,
      title: fields[1] as String,
      subtitle: fields[2] as String,
      imageUrl: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HomeItemModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.subtitle)
      ..writeByte(3)
      ..write(obj.imageUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HomeItemModel _$HomeItemModelFromJson(Map<String, dynamic> json) =>
    _HomeItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$HomeItemModelToJson(_HomeItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'imageUrl': instance.imageUrl,
    };
