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
      file_name: fields[2] as String?,
      pdf_original_name: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PDFItemModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.pdf_id)
      ..writeByte(1)
      ..write(obj.pdf_milliseconds)
      ..writeByte(2)
      ..write(obj.file_name)
      ..writeByte(3)
      ..write(obj.pdf_original_name);
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
