import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageProcessing {
  Future<PickedFile?> imagePickFromCamera() async {
    PickedFile? image =
        await ImagePicker().getImage(source: ImageSource.camera);
    return image;
  }

  Future<PickedFile?> imagePickFromGallery() async {
    PickedFile? image =
        await ImagePicker().getImage(source: ImageSource.gallery);
    return image;
  }

  String getImageExtension(File inputImage) {
    if (inputImage.path.endsWith('.png')) {
      return '.png';
    } else if (inputImage.path.endsWith('.jpg')) {
      return '.jpg';
    } else {
      return '.jpeg';
    }
  }

  bool isChoosenImageIsJpgPngOrJpeg(PickedFile image) {
    if (image.path.endsWith('.png') ||
        image.path.endsWith(".jpg") ||
        image.path.endsWith('.jpeg')) {
      return true;
    } else {
      return false;
    }
  }

  Future<File?> imageCompress(File inputImage, String outputImagePath) async {
    File result = await FlutterImageCompress.compressAndGetFile(
      inputImage.path,
      outputImagePath,
      quality: 88,
    ).then((value) {
      return value!;
    });
    return result;
  }

  bool checkImageIsUnderMaximumAlottedSize(PickedFile image) {
    if (File(image.path).lengthSync() < 5300000) {
      return true;
    } else {
      return false;
    }
  }

  Future<File?> imageCrop(PickedFile image) async {
    // ignore: unnecessary_null_comparison
    if (image != null) {
      File? imageAfterCrop = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.orange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          )).then((value) {
        return value;
      });
      return imageAfterCrop;
    } else {
      return null;
    }
  }
}
