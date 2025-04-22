import 'package:beauty_master/generated/l10n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AppImagePicker extends StatefulWidget {
  static Future<Uint8List?> pickImage(BuildContext context) async {
    if (kIsWeb) {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      return image?.readAsBytes();
    }
    return showModalBottomSheet(context: context, useSafeArea: true, builder: (context) => const AppImagePicker());
  }

  const AppImagePicker({super.key});

  @override
  State<AppImagePicker> createState() => _AppImagePickerState();
}

class _AppImagePickerState extends State<AppImagePicker> with TickerProviderStateMixin {
  final picker = ImagePicker();
  late final AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
    super.initState();
  }

  void pickImage(BuildContext context, ImageSource source) async {
    final file = await picker.pickImage(source: source);
    final image = await file?.readAsBytes();
    if (context.mounted) {
      Navigator.of(context).pop(image);
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        BottomSheet(
          animationController: animationController,
          onClosing: () => Navigator.pop(context),
          builder:
              (context) => SafeArea(
            top: false,
            child: ClipPath(
              clipper: ShapeBorderClipper(
                shape:
                Theme.of(context).bottomSheetTheme.shape ??
                    const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28)),
                    ),
              ),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.camera_alt_rounded),
                      title: Text(S.of(context).camera),
                      onTap: () => pickImage(context, ImageSource.camera),
                    ),
                    ListTile(
                      leading: const Icon(Icons.photo_library_rounded),
                      title: Text(S.of(context).gallery),
                      onTap: () => pickImage(context, ImageSource.gallery),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
