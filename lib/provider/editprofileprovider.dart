import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final editProfileProvider = ChangeNotifierProvider(
  (ref) => EditProfileProvider(),
);

class EditProfileProvider with ChangeNotifier {
  final picker = ImagePicker();
  String selectedImage = "";

  Future<void> getImageFromGallery() async {
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage = pickedFile.path;
      notifyListeners();
    }
  }
}
