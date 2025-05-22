// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_listing_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteListingAdapter extends TypeAdapter<FavoriteListing> {
  @override
  final int typeId = 0;

  @override
  FavoriteListing read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteListing(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      category: fields[3] as String,
      location: fields[4] as String,
      images: (fields[5] as List).cast<String>(),
      estimatedValue: fields[6] as double,
      savedAt: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteListing obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.location)
      ..writeByte(5)
      ..write(obj.images)
      ..writeByte(6)
      ..write(obj.estimatedValue)
      ..writeByte(7)
      ..write(obj.savedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteListingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
