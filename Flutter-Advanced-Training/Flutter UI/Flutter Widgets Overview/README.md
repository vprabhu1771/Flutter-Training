Flutter widgets are the building blocks of a Flutter app. They are classified into different categories based on their purpose and functionality. Here’s a structured overview of Flutter widgets:

### 1. **Basic Widgets**  
   - `Text` – Displays text with styling options.  
   - `Row` & `Column` – Arrange children horizontally and vertically.  
   - `Container` – A versatile box with padding, margin, decoration, and constraints.  
   - `Stack` – Overlays widgets on top of each other.  
   - `Expanded` & `Flexible` – Adjust child widgets' sizes within `Row` and `Column`.  
   - `SizedBox` – Provides spacing between widgets.  
   - `Padding` – Adds spacing inside a widget.  
   - `Center` – Centers a widget within its parent.  

### 2. **Material Design Widgets**  
   - `Scaffold` – Provides a structure with an AppBar, body, FloatingActionButton, etc.  
   - `AppBar` – A top navigation bar with title and actions.  
   - `ElevatedButton` – A raised button with material design.  
   - `TextButton` – A simple text-based button.  
   - `IconButton` – A button with an icon.  
   - `FloatingActionButton (FAB)` – A round button for quick actions.  
   - `BottomNavigationBar` – Navigation bar at the bottom.  
   - `Drawer` – Sidebar navigation menu.  
   - `Card` – A box with shadow and elevation.  
   - `ListTile` – A row with leading, title, subtitle, and trailing widgets.  

### 3. **Input & Form Widgets**  
   - `TextField` – User input field with options.  
   - `TextFormField` – An advanced version of `TextField` with validation.  
   - `Checkbox` – A toggle checkbox.  
   - `Radio` – A group of mutually exclusive options.  
   - `Switch` – A toggle switch.  
   - `Slider` – A draggable value selector.  
   - `DropdownButton` – A dropdown list of options.  
   - `Form` – Wraps multiple form fields for validation.  

### 4. **Layout Widgets**  
   - `Wrap` – Wraps children to the next line when space is insufficient.  
   - `GridView` – Displays items in a grid format.  
   - `ListView` – Displays a scrollable list.  
   - `SingleChildScrollView` – Enables scrolling for a single child.  
   - `Flexible` & `Expanded` – Control child widget sizes dynamically.  
   - `Align` – Positions a child widget within its parent.  
   - `FractionallySizedBox` – Sets the size relative to its parent.  

### 5. **Scrolling Widgets**  
   - `ListView.builder` – Efficiently creates long lists with lazy loading.  
   - `ListView.separated` – Adds dividers between list items.  
   - `GridView.builder` – Creates grid items dynamically.  
   - `PageView` – Implements page-based navigation.  
   - `CustomScrollView` – A flexible scrolling view.  

### 6. **State Management Widgets**  
   - `StatefulWidget` – A widget that maintains state.  
   - `Provider` – A state management solution.  
   - `ChangeNotifier` – A simple state management class.  
   - `StreamBuilder` – Listens to data streams and updates UI.  
   - `FutureBuilder` – Handles asynchronous operations.  

### 7. **Animation & Motion Widgets**  
   - `AnimatedContainer` – Animates size, color, and other properties.  
   - `Hero` – Creates shared element transitions between screens.  
   - `AnimatedOpacity` – Animates transparency changes.  
   - `TweenAnimationBuilder` – Animates values over time.  
   - `AnimatedList` – Animates list additions and removals.  
   - `Lottie` – Plays Lottie animations.  

### 8. **Networking & Media Widgets**  
   - `Image.network` – Displays an image from a URL.  
   - `VideoPlayer` – Plays videos.  
   - `WebView` – Displays web content inside the app.  
   - `FutureBuilder` – Fetches and displays async data.  
   - `StreamBuilder` – Handles real-time data updates.  

### 9. **Navigation & Routing Widgets**  
   - `Navigator` – Manages screen transitions.  
   - `MaterialPageRoute` – Defines routes with material design transitions.  
   - `Named Routes` – Uses predefined route names for navigation.  
   - `GoRouter` – A declarative routing package.  
   - `BottomNavigationBar` – Implements bottom navigation.  

### 10. **Custom Widgets**  
   - `InheritedWidget` – Passes data down the widget tree efficiently.  
   - `CustomPainter` – Draws custom shapes.  
   - `ClipPath` – Clips a widget into a custom shape.  
   - `RepaintBoundary` – Optimizes repainting performance.  


## 11. **Accessibility & Interaction Widgets**
   - `Tooltip` – Provides a small popup message when hovering over an element.  
   - `Semantics` – Helps accessibility tools describe UI elements.  
   - `FocusableActionDetector` – Detects keyboard and focus events.  
   - `MouseRegion` – Detects mouse movements and hover actions.  
   - `GestureDetector` – Captures touch events like tap, swipe, and long press.  

---

## 12. **Sliver Widgets (Advanced Scrolling)**
   - `CustomScrollView` – Combines different scrolling effects.  
   - `SliverAppBar` – Creates a collapsible app bar.  
   - `SliverList` – A list optimized for scrolling performance.  
   - `SliverGrid` – A scrollable grid layout.  
   - `SliverFillRemaining` – Fills the remaining space in a scroll view.  

---

## 13. **Shapes & Clipping Widgets**
   - `ClipRRect` – Clips a widget into a rounded rectangle.  
   - `ClipOval` – Clips a widget into an oval shape.  
   - `ClipPath` – Clips a widget using a custom path.  
   - `ClipRect` – Clips a widget into a rectangle.  
   - `DecoratedBox` – Adds decoration to a child widget.  

---

## 14. **Theme & Styling Widgets**
   - `Theme` – Defines app-wide theme settings.  
   - `ThemeData` – Holds color schemes, typography, etc.  
   - `DefaultTextStyle` – Sets default text styles.  
   - `MediaQuery` – Retrieves screen size, orientation, and accessibility settings.  
   - `ShaderMask` – Applies custom shader effects to a widget.  

---

## 15. **Drawing & Painting Widgets**
   - `CustomPaint` – Allows drawing on the screen.  
   - `Canvas` – Used within `CustomPainter` for advanced graphics.  
   - `Paint` – Defines the style and color of drawings.  

---

## 16. **Hero & Transition Effects**
   - `Hero` – Creates smooth transitions between pages.  
   - `AnimatedSwitcher` – Animates transitions between widgets.  
   - `PageRouteBuilder` – Customizes screen transition animations.  
   - `FadeTransition` – Fades a widget in and out.  
   - `ScaleTransition` – Scales a widget in or out.  

---

## 17. **Advanced Gesture & Drag Widgets**
   - `Draggable` – Enables drag-and-drop functionality.  
   - `DragTarget` – Specifies where draggable widgets can be dropped.  
   - `Dismissible` – Allows swipe-to-dismiss actions.  
   - `AbsorbPointer` – Disables user interaction with a widget.  
   - `IgnorePointer` – Ignores touch input but allows gestures.  

---

## 18. **Background & Foreground Effects**
   - `BackdropFilter` – Applies a blur effect behind a widget.  
   - `Transform` – Rotates, scales, or translates a widget.  
   - `Opacity` – Adjusts widget transparency.  
   - `Align` – Positions a child widget within a parent.  

---

## 19. **Timer & Progress Indicators**
   - `CircularProgressIndicator` – Displays a circular loading spinner.  
   - `LinearProgressIndicator` – Displays a horizontal loading bar.  
   - `Timer.periodic` – Triggers an event at set intervals.  
   - `CountdownTimer` – Runs a countdown sequence.  

---

## 20. **List & Table View Widgets**
   - `DataTable` – Displays tabular data with sorting.  
   - `Table` – Lays out widgets in rows and columns.  
   - `ReorderableListView` – Enables drag-and-drop reordering.  
   - `PaginatedDataTable` – A pageable table for large data.  
   - `ExpansionTile` – A collapsible list item with expandable content.  

---

## 21. **Adaptive Widgets (Platform-Specific)**
   - `AdaptiveTextButton` – A button that adapts to iOS & Android styles.  
   - `CupertinoButton` – An iOS-style button.  
   - `CupertinoActivityIndicator` – An iOS-style loading spinner.  
   - `CupertinoSlider` – An iOS-style slider.  
   - `Platform.isAndroid` & `Platform.isIOS` – Detects the platform for conditional UI rendering.  

---

## 22. **Popup & Overlay Widgets**
   - `AlertDialog` – Displays an alert box with buttons.  
   - `SimpleDialog` – A lightweight pop-up with options.  
   - `SnackBar` – Displays a temporary message at the bottom.  
   - `BottomSheet` – Slides up from the bottom.  
   - `ModalBarrier` – Blocks interaction with background widgets.  

---

## 23. **Network & API Handling Widgets**
   - `FutureBuilder` – Fetches data asynchronously.  
   - `StreamBuilder` – Listens to real-time updates.  
   - `HttpClient` – Sends HTTP requests.  
   - `WebSocket` – Manages live communication with a server.  

---

## 24. **File & Image Handling Widgets**
   - `ImagePicker` – Selects images from a gallery or camera.  
   - `File` – Handles file operations.  
   - `PhotoView` – Zoomable image viewer.  
   - `CachedNetworkImage` – Loads images with caching support.  

---

## 25. **Custom Widgets & Composition**
   - `StatelessWidget` – A widget that does not change state.  
   - `StatefulWidget` – A widget that maintains internal state.  
   - `InheritedWidget` – Passes data down the widget tree efficiently.  
   - `ValueListenableBuilder` – Listens to value changes and rebuilds UI.  

---

Here are even **more Flutter widgets** categorized for advanced usage:  

---

## 26. **Text & Typography Widgets**  
- `SelectableText` – Allows users to select and copy text.  
- `RichText` – Displays text with multiple styles in a single line.  
- `DefaultTextStyle` – Defines default text styles for a subtree.  
- `AutoSizeText` – Automatically resizes text to fit within a widget.  
- `TextSpan` – Enables inline styling within `RichText`.  

---

## 27. **Gesture & Touch Input Widgets**  
- `LongPressDraggable` – Allows dragging a widget with a long press.  
- `InkWell` – Adds a material ripple effect on tap.  
- `InkResponse` – Similar to `InkWell` but works without material parents.  
- `RawGestureDetector` – Gives full control over gesture recognition.  
- `GestureArena` – Resolves gesture conflicts between multiple widgets.  

---

## 28. **Keyboard & Text Input Widgets**  
- `TextField` – Accepts text input from users.  
- `TextFormField` – A form-friendly version of `TextField`.  
- `RawKeyboardListener` – Listens to raw keyboard events.  
- `EditableText` – The base widget for building custom text inputs.  
- `FocusNode` – Manages focus for text fields and input elements.  

---

## 29. **Layout Helpers & Constraint Widgets**  
- `FractionallySizedBox` – Sizes a widget based on its parent's dimensions.  
- `FittedBox` – Scales its child widget to fit inside it.  
- `IntrinsicWidth` – Sizes a widget based on its content width.  
- `IntrinsicHeight` – Sizes a widget based on its content height.  
- `AspectRatio` – Forces a child widget to maintain a specific aspect ratio.  

---

## 30. **ListView Variants (Performance-Optimized)**  
- `ListView.builder` – Efficient list rendering for large data.  
- `ListView.separated` – Adds separators between list items.  
- `ListView.custom` – Uses a `SliverChildDelegate` for customization.  
- `ReorderableListView` – Allows drag-and-drop list reordering.  
- `ShrinkWrap` – Reduces list height to match content size.  

---

## 31. **GridView Variants**  
- `GridView.count` – Creates a simple grid layout.  
- `GridView.builder` – Efficient grid rendering for dynamic data.  
- `GridView.extent` – Creates a grid with a fixed maximum item size.  
- `StaggeredGridView` (via package) – Supports staggered grid layouts.  
- `MasonryGridView` (via package) – Creates Pinterest-style masonry grids.  

---

## 32. **Navigation & Routing Widgets**  
- `Navigator` – Manages screen transitions and routes.  
- `PageView` – Swipes between pages horizontally.  
- `PageController` – Controls navigation within a `PageView`.  
- `WillPopScope` – Handles back navigation manually.  
- `AnimatedPageRoute` – Creates custom transitions between pages.  

---

## 33. **Timers & Countdown Widgets**  
- `Timer` – Runs a function after a delay.  
- `Timer.periodic` – Runs a function at fixed intervals.  
- `CountDownTimer` – Provides a countdown UI for apps.  
- `Ticker` – Provides frame-based animations.  
- `Stopwatch` – Tracks elapsed time and measures durations.  

---

## 34. **Animation & Motion Widgets**  
- `AnimatedOpacity` – Animates changes in transparency.  
- `AnimatedContainer` – Animates size and color changes.  
- `AnimatedAlign` – Animates position changes inside a parent.  
- `AnimatedPositioned` – Animates movement inside `Stack`.  
- `Lottie` (via package) – Plays complex animations from JSON files.  

---

## 35. **Camera & Barcode Scanning Widgets**  
- `CameraPreview` – Shows a live camera feed.  
- `ImagePicker` – Selects images from the gallery or camera.  
- `BarcodeScanner` – Scans QR codes and barcodes (via package).  
- `FaceDetector` – Detects faces in an image (via Firebase ML Kit).  
- `ObjectDetector` – Recognizes objects in an image (via Firebase ML Kit).  

---

## 36. **Augmented Reality (AR) Widgets**  
- `ARKitSceneView` – Renders AR scenes for iOS.  
- `ARCoreView` – Renders AR scenes for Android.  
- `ARView` (via package) – Cross-platform AR implementation.  
- `RealityKit` – Supports 3D object rendering in AR.  
- `SceneKit` – Integrates 3D models and animations.  

---

## 37. **3D Graphics & WebGL Widgets**  
- `ThreeDModelViewer` – Loads 3D models in Flutter.  
- `FlutterGL` – Uses WebGL for GPU-accelerated rendering.  
- `Rive` – Embeds interactive animations into apps.  
- `Flame` – A lightweight 2D game engine for Flutter.  
- `MeshRenderer` – Renders 3D mesh objects.  

---

## 38. **PDF & Document Viewing Widgets**  
- `PdfViewer` – Displays PDFs inside Flutter apps.  
- `HtmlViewer` – Renders HTML content inside a widget.  
- `DocxViewer` – Opens Word documents (.docx) in a Flutter app.  
- `EpubViewer` – Displays EPUB eBooks.  
- `MarkdownView` – Renders Markdown text with styling.  

---

## 39. **Video & Audio Streaming Widgets**  
- `VideoPlayer` – Plays video files and network streams.  
- `Chewie` – Adds playback controls to the `VideoPlayer` widget.  
- `AudioPlayer` – Plays sound files and network audio.  
- `JustAudio` – Handles audio playback with advanced features.  
- `WebRTC` – Supports live video streaming and video calls.  

---

## 40. **Chat & Messaging UI Widgets**  
- `ChatBubble` – Creates styled chat bubbles.  
- `TypingIndicator` – Shows a typing animation.  
- `ChatListView` – Displays messages in a chat interface.  
- `VoiceMessage` – Sends and plays voice messages.  
- `EmojiPicker` – Allows users to select emojis.  

---

## 41. **Security & Authentication Widgets**  
- `PinCodeField` – Displays a PIN input field.  
- `BiometricAuth` – Integrates fingerprint and face unlock.  
- `AuthButton` – Provides social login buttons (Google, Facebook, etc.).  
- `ReCaptcha` – Implements Google reCAPTCHA for bot protection.  
- `OneTimePassword` – Handles OTP input and validation.  

---

## 42. **State Management Widgets**  
- `Provider` – A dependency injection and state management solution.  
- `Riverpod` – An improved version of `Provider` for global state management.  
- `GetX` – A lightweight and efficient state management solution.  
- `Bloc` – Implements business logic component (BLoC) pattern.  
- `MobX` – Uses reactive state management.  

---

## 43. **Offline Storage Widgets**  
- `Hive` – A fast NoSQL database for Flutter.  
- `SharedPreferences` – Stores small key-value data.  
- `Drift` – A powerful SQLite wrapper for Flutter.  
- `ObjectBox` – A high-performance NoSQL database.  
- `Isar` – A super-fast embedded database.  

---

## 44. **Background Services & Notifications**  
- `FlutterLocalNotifications` – Displays push notifications locally.  
- `AwesomeNotifications` – Provides rich push notification customization.  
- `Workmanager` – Runs background tasks.  
- `ForegroundService` – Runs tasks in the foreground.  
- `OneSignal` – Handles push notifications across platforms.  

---

## 45. **Widgets for Wearable & IoT Devices**  
- `WearOS` – Widgets optimized for smartwatches.  
- `SmartBand` – Connects to fitness bands and smart devices.  
- `BluetoothSerial` – Communicates with Bluetooth devices.  
- `MQTTClient` – Connects to IoT devices using MQTT protocol.  
- `USBSerial` – Connects to USB serial devices.  

---

This list covers nearly **everything in Flutter!** Do you need help implementing any of these in your project? 🚀