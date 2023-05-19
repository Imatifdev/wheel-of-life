import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:com.example.wheel_of_life/widgets/colorpallete.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher.dart';

import '../models/drawingmode.dart';
import '../models/sketch.dart';

class CanvasSideBar extends HookWidget {
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
  final List colorList;

  const CanvasSideBar(
      {Key? key,
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
      required this.colorList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final undoRedoStack = useState(_UndoRedoStack(
      sketchesNotifier: allSketches,
      currentSketchNotifier: currentSketch,
    ));
    final scrollController = useScrollController();
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 5,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 3,
            offset: const Offset(3, 3),
          ),
        ],
      ),
      child: ListView(
        padding: const EdgeInsets.all(10.0),
        controller: scrollController,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            child: drawingMode.value == DrawingMode.polygon
                ? Row(
                    children: [
                      const Text(
                        'Polygon Sides: ',
                        style: TextStyle(fontSize: 12),
                      ),
                      Slider(
                        value: polygonSides.value.toDouble(),
                        min: 3,
                        max: 8,
                        onChanged: (val) {
                          polygonSides.value = val.toInt();
                        },
                        label: '${polygonSides.value}',
                        divisions: 5,
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
          const SizedBox(height: 10),
          // const Text(
          //   'Colors',
          //   style: TextStyle(fontWeight: FontWeight.bold),
          // ),
          const Divider(),
          ColorPalette(
            selectColor: selectedColor,
            colorList: colorList,
          ),
          // const Text(
          //   'Actions',
          //   style: TextStyle(fontWeight: FontWeight.bold),
          // ),
          // const Divider(),
          // Wrap(
          //   children: [
          //     TextButton(
          //       onPressed: allSketches.value.isNotEmpty
          //           ? () => undoRedoStack.value.undo()
          //           : null,
          //       child: const Text('Undo'),
          //     ),
          //     ValueListenableBuilder<bool>(
          //       valueListenable: undoRedoStack.value._canRedo,
          //       builder: (_, canRedo, __) {
          //         return TextButton(
          //           onPressed:
          //               canRedo ? () => undoRedoStack.value.redo() : null,
          //           child: const Text('Redo'),
          //         );
          //       },
          //     ),
          //     TextButton(
          //       child: const Text('Clear'),
          //       onPressed: () => undoRedoStack.value.clear(),
          //     ),
          //   ],
          // ),
          // const SizedBox(height: 20),
          // const Text(
          //   'Export',
          //   style: TextStyle(fontWeight: FontWeight.bold),
          // ),
          // const Divider(),
          Row(
            children: [
              SizedBox(
                width: 140,
                child: TextButton(
                  child: const Text('Export PNG'),
                  onPressed: () async {
                    // _saveImage();
                    Uint8List? pngBytes = await getBytes();
                    if (pngBytes != null) saveFile(pngBytes, 'png');
                  },
                ),
              ),
              SizedBox(
                width: 140,
                child: TextButton(
                  child: const Text('Export JPEG'),
                  onPressed: () async {
                    Uint8List? pngBytes = await getBytes();
                    if (pngBytes != null) saveFile(pngBytes, 'jpeg');
                  },
                ),
              ),
            ],
          ),
          // // add about me button or follow buttons
        ],
      ),
    );
  }

  // void saveFile(Uint8List bytes, String extension) async {
  //   if (kIsWeb) {
  //     html.AnchorElement()
  //       ..href = '${Uri.dataFromBytes(bytes, mimeType: 'image/$extension')}'
  //       ..download =
  //           'FlutterLetsDraw-${DateTime.now().toIso8601String()}.$extension'
  //       ..style.display = 'none'
  //       ..click();
  //   } else {
  //     await FileSaver.instance.saveFile(
  //       'FlutterLetsDraw-${DateTime.now().toIso8601String()}.$extension',
  //       bytes,
  //       extension,
  //       mimeType: extension == 'png' ? MimeType.PNG : MimeType.JPEG,
  //     );
  //   }
  // }

  //gpt-start
  Future<void> _saveImage() async {
    // Convert the background image to bytes
    Uint8List? backgroundImageBytes = await encodeImageToBytes(
        await loadImage(backgroundImage.value!.toByteData() as Uint8List),
        'png');

    // Convert the drawing image to bytes
    Uint8List? drawingImageBytes = getBytes() as Uint8List?;

    // Combine the background and drawing images
    Uint8List? combinedImageBytes = await encodeImageToBytes(
        mergeImages(await loadImage(backgroundImageBytes!),
            await loadImage(drawingImageBytes!)) as ui.Image,
        "png");

    // Save the combined image to the gallery
    await saveFile2(combinedImageBytes!, 'png');
  }

  Future<void> saveFile2(Uint8List bytes, String extension) async {
    String fileName =
        'FlutterLetsDraw-${DateTime.now().toIso8601String()}.$extension';

    if (Platform.isAndroid) {
      Directory? appDocDir = await getExternalStorageDirectory();

      if (appDocDir != null) {
        String filePath = '${appDocDir.path}/$fileName';

        // Save the combined image bytes to a file
        await File(filePath).writeAsBytes(bytes);

        // Refresh media gallery to show the saved file
        await ImageGallerySaver.saveFile(filePath);
      }
    }
  }

  Future<ui.Image> loadImage(Uint8List bytes) async {
    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }

  Future<ui.Image> loadImageFromMemory(Uint8List bytes) async {
    ui.Codec codec = await ui.instantiateImageCodec(bytes);
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }

  Future<ui.Image> mergeImages(
      ui.Image backgroundImage, ui.Image drawingImage) async {
    ui.PictureRecorder recorder = ui.PictureRecorder();
    ui.Canvas canvas = ui.Canvas(recorder);

    canvas.drawImage(backgroundImage, Offset.zero,
        Paint()..filterQuality = FilterQuality.high);

    canvas.drawImage(
        drawingImage, Offset.zero, Paint()..filterQuality = FilterQuality.high);

    ui.Image combinedImage = await recorder
        .endRecording()
        .toImage(backgroundImage.width, backgroundImage.height);

    return combinedImage;
  }

  Future<Uint8List?> encodeImageToBytes(ui.Image image, String format) async {
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData != null) {
      return byteData.buffer.asUint8List();
    } else {
      return null;
    }
  }
  //gpt-end

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
    print("test 1 okay");
    RenderRepaintBoundary boundary = canvasGlobalKey.currentContext
        ?.findRenderObject() as RenderRepaintBoundary;
    print("test 2 okay");
    ui.Image image = await boundary.toImage();
    print("test 3 okay");
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    print("test 4 okay");
    Uint8List? pngBytes = byteData?.buffer.asUint8List();
    print("test 5 okay");
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
