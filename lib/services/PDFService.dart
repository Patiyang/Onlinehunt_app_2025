import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hive_ce/hive.dart';
import 'package:online_hunt_news/helpers&Widgets/helper_class.dart';
import 'package:online_hunt_news/models/Hive/pdf_timer.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';


class PDFService {
  final Dio _dio = Dio();

  final Box<PDFItemModel> _box =
      Hive.box<PDFItemModel>(HelperClass.pdfItemBox);

  /// Download a PDF and report progress.
  ///
  /// Returns the saved filename when successful.
  /// Returns null when the download fails.
  Future<String?> downloadPDF({
    required int pdfId,
    required String url,
    Function(double progress)? onProgress,
  }) async {
    try {
      final directory =
          await getApplicationDocumentsDirectory();

      final fileName = 'epaper_$pdfId.pdf';

      final filePath = path.join(
        directory.path,
        fileName,
      );

      await _dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            final progress = received / total;

            onProgress?.call(progress);
          }
        },
      );

      // Save/update Hive only after the download succeeds.
      final existing = _box.get(pdfId);

      if (existing != null) {
        existing.file_name = fileName;

        await existing.save();
      } else {
        await _box.put(
          pdfId,
          PDFItemModel(
            pdf_id: pdfId,
            pdf_milliseconds:
                DateTime.now().millisecondsSinceEpoch,
            file_name: fileName,
          ),
        );
      }

      return fileName;
    } catch (e) {
      print('PDF download failed: $e');

      return null;
    }
  }

  /// Get the full path of a downloaded PDF.
  Future<String?> getPDFPath(
    String? fileName,
  ) async {
    if (fileName == null || fileName.isEmpty) {
      return null;
    }

    final directory =
        await getApplicationDocumentsDirectory();

    final filePath = path.join(
      directory.path,
      fileName,
    );

    final file = File(filePath);

    if (await file.exists()) {
      return filePath;
    }

    return null;
  }

  /// Check whether a PDF actually exists locally.
  Future<bool> isPDFDownloaded(
    int pdfId,
  ) async {
    final item = _box.get(pdfId);

    if (item == null ||
        item.file_name == null ||
        item.file_name!.isEmpty) {
      return false;
    }

    final filePath =
        await getPDFPath(item.file_name);

    return filePath != null;
  }

  /// Get all downloaded PDFs.
  Future<List<PDFItemModel>> getDownloadedPDFs() async {
    final downloaded = <PDFItemModel>[];

    for (final item in _box.values) {
      if (item.file_name == null ||
          item.file_name!.isEmpty) {
        continue;
      }

      final filePath =
          await getPDFPath(item.file_name);

      if (filePath != null) {
        downloaded.add(item);
      }
    }

    return downloaded;
  }

  /// Delete a downloaded PDF.
  Future<bool> deletePDF(
    int pdfId,
  ) async {
    final item = _box.get(pdfId);

    if (item == null ||
        item.file_name == null ||
        item.file_name!.isEmpty) {
      return false;
    }

    final filePath =
        await getPDFPath(item.file_name);

    if (filePath != null) {
      final file = File(filePath);

      if (await file.exists()) {
        await file.delete();
      }
    }

    item.file_name = null;

    await item.save();

    return true;
  }
}