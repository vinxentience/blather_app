import 'dart:io';
import 'dart:math';

import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as Img;
import 'package:path_provider/path_provider.dart';

class Utils {
  static String getUsername(String email) {
    return "${email.split('@')[0]}";
  }

  static String getInitials(String name) {
    List<String> nameSplit = name.split(" ");
    String firstNameInitial = nameSplit[0][0];
    String lastNameInitial = nameSplit[1][0];
    return firstNameInitial + lastNameInitial;
  }

  static Future<File> pickImage({required ImageSource source}) async {
    XFile? selectedImage = (await ImagePicker().pickImage(source: source));
    //return selectedImage;
    return compressedImage(selectedImage!);
  }

  static Future<File> compressedImage(XFile imageToCompress) async {
    final tmpDir = await getTemporaryDirectory();
    final path = tmpDir.path;

    int rand = Random().nextInt(1000);
    Img.Image? image = Img.decodeImage(await imageToCompress.readAsBytes());
    Img.copyResize(image!, width: 500, height: 500);
    return new File('$path/img_$rand.jpg')
      ..writeAsBytesSync(Img.encodeJpg(image, quality: 85));
  }
}
