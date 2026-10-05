import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/api/api_client.dart';

class PdfShareService {
  PdfShareService(this.api);
  final ApiClient api;
  Future<void> share(String id, String number) async {
    var bytes = await api.bytes('/certificaciones/$id/pdf');
    var dir = await getTemporaryDirectory();
    var file = File('${dir.path}/FiberTrack_$number.pdf');
    await file.writeAsBytes(bytes, flush: true);
    await SharePlus.instance.share(ShareParams(
        files: [XFile(file.path, mimeType: 'application/pdf')],
        text: 'Certificación $number de FiberTrack'));
  }
}
