// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pdf_timer.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PDFItemModelAdapter extends TypeAdapter<PDFItemModel> {
  @override
  final typeId = 0;

  @override
  PDFItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PDFItemModel(
      pdf_id: (fields[0] as num).toInt(),
      pdf_milliseconds: (fields[1] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, PDFItemModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.pdf_id)
      ..writeByte(1)
      ..write(obj.pdf_milliseconds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PDFItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
