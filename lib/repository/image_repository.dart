import 'dart:io';

import 'package:assignment_4/model/Event.dart';
import 'package:assignment_4/uri_extension.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as Path;

class ImageRepository {
  static final ImageRepository _singleton = ImageRepository._();

  ImageRepository._() {
    db = FirebaseStorage.instance;
    storageRef = db.ref('assignment_2');
  }

  factory ImageRepository() {
    return _singleton;
  }

  late final FirebaseStorage db;
  late final Reference storageRef;

  Future<String?> persist(XFile file) async {
    String id = const Uuid().v1();
    String extension = Path.extension(file.path);

    Reference imgRef = storageRef.child(id + extension);

    try {
      await imgRef.putFile(File(file.path));
    } on FirebaseException catch (e) {
      return null;
    }

    return await imgRef.getDownloadURL();
  }

  Future<XFile?> fetch(String uri) async {
    Reference imgRef = db.refFromURL(uri);

    String id = const Uuid().v1();

    Directory imgDir = await getApplicationDocumentsDirectory();
    String imgPath = Path.join(imgDir.path, id);
    File imgFile = File(imgPath);

    TaskSnapshot downloadTask = await imgRef.writeToFile(imgFile);

    return XFile(imgFile.path);
  }
}
