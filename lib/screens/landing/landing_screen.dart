import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../app/app_router.dart';
import '../../widgets/action_button.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key, required this.userName});
  final String userName;

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  // Check if running on iOS Simulator
  bool get _isSimulator {
    if (Platform.isIOS) {
      // iOS Simulator detection
      return !kIsWeb &&
          Platform.environment.containsKey('SIMULATOR_DEVICE_NAME');
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final sZ = MediaQuery.sizeOf(context);
    final isNarrow = sZ.width < 400;

    return Scaffold(
      backgroundColor: Colors.transparent, // ✅ makes scaffold transparent to show background),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 90),
              Text(
                'Welcome ${widget.userName}!',
                style:
                    (isNarrow
                            ? Theme.of(context).textTheme.headlineMedium
                            : Theme.of(context).textTheme.headlineLarge)
                        ?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: isNarrow ? 26 : sZ.height * 0.052,
                          letterSpacing: isNarrow ? -0.5 : 0,
                        ),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 15),
                        Text(
                          'What do you wanna do today?',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.black87,
                            fontSize: 22,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ActionButton(
                          label: 'Upload Photo',
                          icon: Icons.photo_camera,
                          onTap: _showPickSourceSheet,
                        ),
                        const SizedBox(height: 14),
                        ActionButton(
                          label: 'See Progress',
                          icon: Icons.description_outlined,
                          onTap: () => context.push(AppRoutes.progress),
                        ),
                        const SizedBox(height: 14),
                        ActionButton(
                          label: 'Get Inspired',
                          icon: Icons.auto_awesome_outlined,
                          onTap: () => context.push(AppRoutes.inspired),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: sZ.width * 0.3,
                    height: sZ.height * 0.55,
                    child: const Image(
                      image: AssetImage('assets/images/brush_mascot.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPickSourceSheet() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white, // ✅ makes it white

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Camera'),
                    subtitle: _isSimulator
                        ? const Text(
                            'Not available on Simulator. Use a physical device.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange,
                            ),
                          )
                        : null,
                    enabled: !_isSimulator,
                    onTap: _isSimulator
                        ? null
                        : () async {
                            Navigator.pop(sheetContext);
                            await _pickImageAndGoToDetails(ImageSource.camera);
                          },
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_library_outlined),
                    title: const Text('Gallery'),
                    onTap: () async {
                      Navigator.pop(sheetContext);
                      await _pickImageAndGoToDetails(ImageSource.gallery);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.close),
                    title: const Text('Cancel'),
                    onTap: () => Navigator.pop(sheetContext),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      isScrollControlled: true,
    );
  }

  Future<void> _pickImageAndGoToDetails(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: source);
      if (picked == null) {
        // User cancelled
        if (source == ImageSource.camera && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Camera not available. iOS Simulator does not support camera. Please test on a physical device.',
              ),
              duration: Duration(seconds: 5),
            ),
          );
        }
        return;
      }

      final now = DateTime.now();
      final appDir = await getApplicationDocumentsDirectory();

      final imagesDir = Directory(p.join(appDir.path, 'drawings'));
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      final fileName = '${now.millisecondsSinceEpoch}.jpg';
      final savedPath = p.join(imagesDir.path, fileName);
      final savedFile = await File(picked.path).copy(savedPath);

      // DB insert skipped: enable once the generated DB types (e.g. DrawingsCompanion)
      // are available/exported from your database.dart.
      debugPrint('DB insert skipped for image path: ${savedFile.path}');
      debugPrint('Saved image path: ${savedFile.path}');

      if (!mounted) return;

      debugPrint('Copied image to app storage: ${savedFile.path}');

      // Navigate to Upload Details page (NO DB insert here)
      context.push(AppRoutes.uploadDetails, extra: savedFile.path);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            source == ImageSource.camera
                ? 'Photo selected from Camera'
                : 'Photo selected from Gallery',
          ),
        ),
      );
    } catch (e, st) {
      debugPrint('Pick/Copy failed: $e\n$st');
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _addSampleImageAndGo() async {
    try {
      final now = DateTime.now();
      final byteData = await rootBundle.load('assets/images/brush_mascot.png');
      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory(p.join(appDir.path, 'drawings'));
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }
      final fileName = 'sample_${now.millisecondsSinceEpoch}.png';
      final savedPath = p.join(imagesDir.path, fileName);
      final file = File(savedPath);
      await file.writeAsBytes(
        byteData.buffer.asUint8List(
          byteData.offsetInBytes,
          byteData.lengthInBytes,
        ),
      );

      // DB insert skipped: enable once the generated DB types (e.g. DrawingsCompanion)
      // are available/exported from your database.dart.
      debugPrint('DB insert skipped for sample image path: ${file.path}');
      debugPrint('Saved sample image path: ${file.path}');

      if (!mounted) return;

      // Navigate to Upload Details page
      context.push(AppRoutes.uploadDetails, extra: file.path);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Sample image saved')));
    } catch (e, st) {
      debugPrint('Sample image failed: $e\n$st');
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
}
