import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final picker = ImagePicker();
  XFile? file = await picker.pickImage(source: source);
  if (file == null) {
    return;
  }
  return await file.readAsBytes();
}
