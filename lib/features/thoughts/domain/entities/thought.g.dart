// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thought.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ThoughtAdapter extends TypeAdapter<Thought> {
  @override
  final int typeId = 1;

  @override
  Thought read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Thought(
      id: fields[0] as String,
      content: fields[1] as String,
      dateCreated: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Thought obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.dateCreated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThoughtAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
