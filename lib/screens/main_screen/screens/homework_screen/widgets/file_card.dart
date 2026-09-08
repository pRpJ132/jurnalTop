import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:my_app/network/api_client.dart';
import 'package:ultimate_flutter_icons/flutter_icons.dart';

class FileCard extends StatelessWidget {
  final String url;

  const FileCard({super.key, required this.url});

  String get fileName => url.split('/').last;

  Future<Directory> _getDir() async {
    final baseDir = await getApplicationDocumentsDirectory();
    final dir = Directory('${baseDir.path}/it_top_files');

    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    return dir;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: .min,
      children: [
        GestureDetector(
          onTap: () => _downloadAndOpen(context),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: CupertinoColors.activeBlue.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: FIcon(
              HI.HiOutlineDocumentDownload,
              color: CupertinoColors.activeBlue,
              size: 33,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _downloadAndOpen(BuildContext context) async {
    try {
      final dir = await _getDir();

      final existing = dir
          .listSync()
          .whereType<File>()
          .where((f) => path.basenameWithoutExtension(f.path) == fileName)
          .firstOrNull;

      if (existing != null) {
        await OpenFilex.open(existing.path);
        return;
      }

      final response = await ApiClient.get(url, customUrl: true);

      final nameFromHeader = _fileNameFromHeaders(response.headers);

      final bytes = response.bodyBytes;

      final baseName = nameFromHeader;

      final file = File('${dir.path}/$baseName');
      await file.writeAsBytes(bytes);
      await OpenFilex.open(file.path);

    } catch (e) {
      print("Download error: $e");
    }
  }

  String? _fileNameFromHeaders(Map<String, String> headers) {
    final disposition = headers['content-disposition'];
    if (disposition != null) {
      final match = RegExp(r'filename="?([^";\n]+)"?').firstMatch(disposition);
      final name = match?.group(1)?.trim();
      if (name != null) return name;
    }

    return headers['x-amz-meta-client_name'];
  }
}