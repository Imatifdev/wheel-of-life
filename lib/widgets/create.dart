// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher.dart';

import '../models/drawingmode.dart';
import '../models/sketch.dart';

import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:image_painter/image_painter.dart';

import '../utils/mycolors.dart';

class MyDrawing extends HookWidget {
  final ValueNotifier<Color> selectedColor;
  final ValueNotifier<double> strokeSize;
  final ValueNotifier<double> eraserSize;
  final ValueNotifier<DrawingMode> drawingMode;
  final ValueNotifier<Sketch?> currentSketch;
  final ValueNotifier<List<Sketch>> allSketches;
  final GlobalKey canvasGlobalKey;
  final ValueNotifier<bool> filled;
  final ValueNotifier<int> polygonSides;
  final ValueNotifier<ui.Image?> backgroundImage;
  GlobalKey _globalKey = GlobalKey();

  MyDrawing({
    Key? key,
    required this.selectedColor,
    required this.strokeSize,
    required this.eraserSize,
    required this.drawingMode,
    required this.currentSketch,
    required this.allSketches,
    required this.canvasGlobalKey,
    required this.filled,
    required this.polygonSides,
    required this.backgroundImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<Uint8List?> getBytes() async {
      print("test 1 okay");
      RenderRepaintBoundary boundary = canvasGlobalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      print("test 2 okay");
      ui.Image image = await boundary.toImage();
      print("test 3 okay");
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      print("test 4 okay");
      Uint8List? pngBytes = byteData?.buffer.asUint8List();
      print("test 5 okay");
      return pngBytes;
    }

    void saveFile(Uint8List bytes, String extension) async {
      String fileName =
          'FlutterLetsDraw-${DateTime.now().toIso8601String()}.$extension';
      if (kIsWeb) {
        // Saving files not supported on web
        return;
      } else {
        Directory? appDocDir = await getExternalStorageDirectory();

        if (appDocDir != null) {
          String filePath = '${appDocDir.path}/$fileName';

          await File(filePath).writeAsBytes(bytes);

          // Refresh media gallery to show the saved file
          await ImageGallerySaver.saveFile(filePath);
        }
      }
    }

    final undoRedoStack = useState(_UndoRedoStack(
      sketchesNotifier: allSketches,
      currentSketchNotifier: currentSketch,
    ));
    final scrollController = useScrollController();
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(10)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: allSketches.value.isNotEmpty
                      ? () => undoRedoStack.value.redo()
                      : null,
                  icon: Icon(Icons.redo)),
              IconButton(
                  onPressed: () async {
                    {
                      Uint8List? pngBytes = await getBytes();
                      if (pngBytes != null) saveFile(pngBytes, 'png');
                    }
                    Get.snackbar("Image", "Your Image has been saved",
                        snackPosition: SnackPosition.BOTTOM,
                        colorText: Colors.black,
                        backgroundColor: appbg);
                  },
                  icon: Icon(Icons.check_circle)),
              IconButton(
                  onPressed: allSketches.value.isNotEmpty
                      ? () => undoRedoStack.value.undo()
                      : null,
                  icon: Icon(Icons.undo)),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> saveDrawing() async {
    try {
      print("object");
      // Find the RenderRepaintBoundary of the widget
      RenderRepaintBoundary boundary = canvasGlobalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;

      // Convert the boundary to an image
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);

      // Convert the image to a byte buffer
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Save the image to the device's gallery
      await ImageGallerySaver.saveImage(pngBytes);
    } catch (e) {
      print("no");

      print(e);
    }
  }

  Future<Uint8List?> _capturePng() async {
    try {
      RenderRepaintBoundary boundary = canvasGlobalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      final result =
          await ImageGallerySaver.saveImage(pngBytes); // Save image to gallery
      print('save');
      return pngBytes;
    } catch (e) {
      print(e);
      return null;
    }
  }
  // void saveImage() async {
  //   final image = await canvasGlobalKey.currentState!;
  //   final directory = (await getApplicationDocumentsDirectory()).path;
  //   await Directory('$directory/sample').create(recursive: true);

  //   final fullPath =
  //       '$directory/sample/${DateTime.now().millisecondsSinceEpoch}.png';
  //   imgFile = File(fullPath);
  //   imgFile.writeAsBytesSync(image as List<int>);
  //   Get.snackbar("Success", "Image Downloaded successfully.",
  //       mainButton: TextButton(
  //           onPressed: () => OpenFile.open("$fullPath"),
  //           child: Text(
  //             "Open",
  //             style: TextStyle(
  //               color: Colors.blue[200],
  //             ),
  //             //           ),, child: child) );
  //             // ScaffoldMessenger.of(context).showSnackBar(
  //             //   SnackBar(
  //             //     backgroundColor: Colors.grey[700],
  //             //     padding: const EdgeInsets.only(left: 10),
  //             //     content: Row(
  //             //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             //       children: [
  //             //         const Text(,
  //             //             style: TextStyle(color: Colors.white)),
  //             //         TextButton(
  //             //           onPressed: () => OpenFile.open("$fullPath"),
  //             //           child: Text(
  //             //             "Open",
  //             //             style: TextStyle(
  //             //               color: Colors.blue[200],
  //             //             ),
  //             //           ),
  //             //         )
  //             //       ],
  //             //     ),
  //             //   ),
  //           )));
  // }

  void saveFile(Uint8List bytes, String extension) async {
    if (Platform.isAndroid) {
      print("web");
      html.AnchorElement()
        ..href = '${Uri.dataFromBytes(bytes, mimeType: 'image/$extension')}'
        ..download =
            'FlutterLetsDraw-${DateTime.now().toIso8601String()}.$extension'
        ..style.display = 'none'
        ..click();
    } else {
      await FileSaver.instance.saveFile(
        'FlutterLetsDraw-${DateTime.now().toIso8601String()}.$extension',
        bytes,
        extension,
        mimeType: extension == 'png' ? MimeType.PNG : MimeType.JPEG,
      );
      print("android");
    }
  }

  Future<ui.Image> get _getImage async {
    final completer = Completer<ui.Image>();
    if (!kIsWeb && !Platform.isAndroid && !Platform.isIOS) {
      final file = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (file != null) {
        final filePath = file.files.single.path;
        final bytes = filePath == null
            ? file.files.first.bytes
            : File(filePath).readAsBytesSync();
        if (bytes != null) {
          completer.complete(decodeImageFromList(bytes));
        } else {
          completer.completeError('No image selected');
        }
      }
    } else {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        final bytes = await image.readAsBytes();
        completer.complete(
          decodeImageFromList(bytes),
        );
      } else {
        completer.completeError('No image selected');
      }
    }

    return completer.future;
  }

  Future<void> _launchUrl(String url) async {
    if (kIsWeb) {
      html.window.open(
        url,
        url,
      );
    } else {
      if (!await launchUrl(Uri.parse(url))) {
        throw 'Could not launch $url';
      }
    }
  }

  Future<Uint8List?> getBytes() async {
    RenderRepaintBoundary boundary = canvasGlobalKey.currentContext
        ?.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List? pngBytes = byteData?.buffer.asUint8List();
    return pngBytes;
  }
}

class _IconBox extends StatelessWidget {
  final IconData? iconData;
  final Widget? child;
  final bool selected;
  final VoidCallback onTap;
  final String? tooltip;

  const _IconBox({
    Key? key,
    this.iconData,
    this.child,
    this.tooltip,
    required this.selected,
    required this.onTap,
  })  : assert(child != null || iconData != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            border: Border.all(
              color: selected ? Colors.grey[900]! : Colors.grey,
              width: 1.5,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: Tooltip(
            message: tooltip,
            preferBelow: false,
            child: child ??
                Icon(
                  iconData,
                  color: selected ? Colors.grey[900] : Colors.grey,
                  size: 20,
                ),
          ),
        ),
      ),
    );
  }
}

///A data structure for undoing and redoing sketches.
class _UndoRedoStack {
  _UndoRedoStack({
    required this.sketchesNotifier,
    required this.currentSketchNotifier,
  }) {
    _sketchCount = sketchesNotifier.value.length;
    sketchesNotifier.addListener(_sketchesCountListener);
  }

  final ValueNotifier<List<Sketch>> sketchesNotifier;
  final ValueNotifier<Sketch?> currentSketchNotifier;

  ///Collection of sketches that can be redone.
  late final List<Sketch> _redoStack = [];

  ///Whether redo operation is possible.
  ValueNotifier<bool> get canRedo => _canRedo;
  late final ValueNotifier<bool> _canRedo = ValueNotifier(false);

  late int _sketchCount;

  void _sketchesCountListener() {
    if (sketchesNotifier.value.length > _sketchCount) {
      //if a new sketch is drawn,
      //history is invalidated so clear redo stack
      _redoStack.clear();
      _canRedo.value = false;
      _sketchCount = sketchesNotifier.value.length;
    }
  }

  void clear() {
    _sketchCount = 0;
    sketchesNotifier.value = [];
    _canRedo.value = false;
    currentSketchNotifier.value = null;
  }

  void undo() {
    final sketches = List<Sketch>.from(sketchesNotifier.value);
    if (sketches.isNotEmpty) {
      _sketchCount--;
      _redoStack.add(sketches.removeLast());
      sketchesNotifier.value = sketches;
      _canRedo.value = true;
      currentSketchNotifier.value = null;
    }
  }

  void redo() {
    if (_redoStack.isEmpty) return;
    final sketch = _redoStack.removeLast();
    _canRedo.value = _redoStack.isNotEmpty;
    _sketchCount++;
    sketchesNotifier.value = [...sketchesNotifier.value, sketch];
  }

  void dispose() {
    sketchesNotifier.removeListener(_sketchesCountListener);
  }
}
