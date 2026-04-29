```
https://pub.dev/packages/image_picker
```

Here’s a clear step-by-step guide + full example showing how to use the image_picker plugin in Flutter to pick images from both gallery and camera.

---

### 🔧 Setup

1. In `pubspec.yaml`, add the dependency:

   ```yaml
   dependencies:
     image_picker: ^1.2.0
   ```

   (Check the latest version on pub.dev.) ([Dart packages][1])
2. **iOS**: In `ios/Runner/Info.plist` add usage description keys:

   ````xml
   <key>NSPhotoLibraryUsageDescription</key>
   <string>App needs access to photo library</string>
   <key>NSCameraUsageDescription</key>
   <string>App needs access to camera</string>
   <key>NSMicrophoneUsageDescription</key>
   <string>App needs access to microphone if recording video</string>
   ``` :contentReference[oaicite:2]{index=2}  
   ````
3. **Android**: For recent versions, usually no extra config is required for gallery/camera open. But if you use older Android SDK behaviour or fallback code, check docs. ([Dart packages][1])

---

### 🧩 Example Code

Here’s a minimal example you can adapt:

```dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerExample extends StatefulWidget {
  const ImagePickerExample({Key? key}) : super(key: key);

  @override
  State<ImagePickerExample> createState() => _ImagePickerExampleState();
}

class _ImagePickerExampleState extends State<ImagePickerExample> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  String? _error;

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      if (picked != null) {
        setState(() {
          _imageFile = File(picked.path);
          _error = null;
        });
      } else {
        setState(() {
          _error = 'No image selected.';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error picking image: $e';
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      if (picked != null) {
        setState(() {
          _imageFile = File(picked.path);
          _error = null;
        });
      } else {
        setState(() {
          _error = 'No image captured.';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error capturing image: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Picker Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _imageFile != null
                ? Image.file(
                    _imageFile!,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  )
                : const Text('No image selected.'),
            if (_error != null) ...[
              const SizedBox(height: 10),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImageFromGallery,
              child: const Text('Pick Image from Gallery'),
            ),
            ElevatedButton(
              onPressed: _pickImageFromCamera,
              child: const Text('Capture Image from Camera'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

### 🧠 Explanation & Tips

* We use `XFile? picked = await _picker.pickImage(...)`. The new API (since ~0.8.x) uses `XFile`, replacing older `PickedFile`. ([Dart packages][1])
* You can pass optional arguments like `maxWidth`, `maxHeight`, `imageQuality` to reduce file size.
* After picking, you convert `picked.path` to a `File` if you need to manipulate file on local device storage.
* Handle **null** result: when user cancels the picker, you’ll get `picked == null`.
* For Android, if your activity gets killed when picking (low memory), you should handle lost data via `ImagePicker.retrieveLostData()` (see docs). ([Dart packages][1])
* For multiple image selection: use `pickMultiImage(...)`. Example and guide available. ([GeeksforGeeks][2])

---

### 🎯 Use-case Fit

Since you’re working on the e-commerce / mobile app side (as I know from your other work), here’s how you might integrate:

* Let user upload a **product image**: use gallery picker.
* Let user capture a **live photo** of the product: use camera picker.
* After picking, you can show thumbnail, allow cropping or resizing, then upload to backend.
* Consider permissions: for camera access, you need to ensure runtime permission (on Android). The plugin handles some of it but you still need to test on real device.
* On web, the plugin behaves differently (uses browser file picker) – test accordingly.

---

If you like, I can **generate a full Flutter screen** that integrates the image picker *plus* uploading the selected image to your backend API in your e-commerce setup (with error handling, cropping, etc.). Would you like that?

[1]: https://pub.dev/packages/image_picker?utm_source=chatgpt.com "image_picker | Flutter package - Pub.dev"
[2]: https://www.geeksforgeeks.org/how-to-select-multiple-images-from-image_picker-in-flutter/?utm_source=chatgpt.com "How to Select Multiple Images From image_picker in Flutter?"
