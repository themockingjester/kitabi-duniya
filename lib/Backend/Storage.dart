import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  final pathForDirectUploadImage = "books/main/";
  final pathForIncomingBookImageUpload = "books/incoming/";
  final _storage = FirebaseStorage.instance;
  final _auth = FirebaseAuth.instance;

  Future<String> uploadImageDirectly(
      String address, String imagePath, String extension) async {
    File img = File(imagePath);
    if (_auth.currentUser!.uid != null) {
      TaskSnapshot snapshot = await _storage
          .ref()
          .child('$pathForDirectUploadImage')
          .child(address)
          .child('${imagePath.hashCode}$extension')
          .putFile(img);
      if (snapshot.state == TaskState.success) {
        return 'done';
      } else if (snapshot.state == TaskState.canceled) {
        return 'canceled';
      } else if (snapshot.state == TaskState.error) {
        return 'error occurred';
      } else {
        return 'something bad happened!';
      }
    } else {
      return "you haven't have permission!";
    }
  }

  String? coverPathForDirectUpload(
      String address, String imagePath, String extension) {
    if (_auth.currentUser!.uid != null) {
      return '$pathForDirectUploadImage/$address/${imagePath.hashCode}.$extension';
    } else {
      return null;
    }
  }

  String? coverPathForIncomingImageUpload(
      String address, String imagePath, String extension) {
    String uid = _auth.currentUser!.uid;
    if (uid != null) {
      return '$pathForIncomingBookImageUpload/$uid/$address/${imagePath.hashCode}.$extension';
    } else {
      return null;
    }
  }

  Future<String> uploadIncomingImage(
      String address, String imagePath, String extension) async {
    File img = File(imagePath);
    String uid = _auth.currentUser!.uid;
    if (uid != null) {
      TaskSnapshot snapshot = await _storage
          .ref()
          .child('$pathForIncomingBookImageUpload')
          .child(uid)
          .child(address)
          .child('${imagePath.hashCode}$extension')
          .putFile(img);
      if (snapshot.state == TaskState.success) {
        return 'done';
      } else if (snapshot.state == TaskState.canceled) {
        return 'canceled';
      } else if (snapshot.state == TaskState.error) {
        return 'error occurred';
      } else {
        return 'something bad happened!';
      }
    } else {
      return "you haven't have permission!";
    }
  }
}
