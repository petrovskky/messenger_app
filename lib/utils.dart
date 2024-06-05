import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger_app/lang/locale_keys.g.dart';

class Utils {
  static void showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  static void showImagePicker(
      BuildContext context, Function(File) onImageSelected) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(LocaleKeys.selectImage.tr()),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text(LocaleKeys.gallery.tr()),
                  onTap: () {
                    ImagePicker()
                        .pickImage(source: ImageSource.gallery)
                        .then((file) {
                      if (file != null) {
                        onImageSelected(File(file.path));
                      }
                      Navigator.of(context).pop();
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                GestureDetector(
                  child: Text(LocaleKeys.camera.tr()),
                  onTap: () async {
                    ImagePicker()
                        .pickImage(source: ImageSource.camera)
                        .then((file) {
                      if (file != null) {
                        onImageSelected(File(file.path));
                      }
                      Navigator.of(context).pop();
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
