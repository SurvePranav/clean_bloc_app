import 'dart:developer';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future<File?> pickImage() async {
  try {
    final ImagePicker picker = ImagePicker();
    final xFile = await picker.pickImage(source: ImageSource.gallery);
    log('picking image');
    if (xFile != null) {
      return File(xFile.path);
    }
    return null;
  } catch (e) {
    log(e.toString());
    return null;
  }
}
