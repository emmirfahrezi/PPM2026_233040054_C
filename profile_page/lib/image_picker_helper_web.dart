// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';

Future<Uint8List?> pickImageBytes() async {
  final input = html.FileUploadInputElement()..accept = 'image/*';
  input.click();

  await input.onChange.first;
  if (input.files == null || input.files!.isEmpty) {
    return null;
  }

  final file = input.files!.first;
  final reader = html.FileReader();
  final completer = Completer<Uint8List?>();

  reader.onLoadEnd.listen((_) {
    final result = reader.result;
    if (result is ByteBuffer) {
      completer.complete(Uint8List.view(result));
    } else if (result is List<int>) {
      completer.complete(Uint8List.fromList(result));
    } else {
      completer.complete(null);
    }
  });

  reader.onError.listen((_) {
    completer.complete(null);
  });

  reader.readAsArrayBuffer(file);
  return completer.future;
}
