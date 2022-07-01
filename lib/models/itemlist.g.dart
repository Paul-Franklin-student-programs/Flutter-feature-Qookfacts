// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'itemlist.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItemListAdapter extends TypeAdapter<ItemList> {
  @override
  final int typeId = 77;

  @override
  ItemList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItemList(
      name: fields[0] as String,
      url: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ItemList obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
