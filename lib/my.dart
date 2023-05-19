// // ignore_for_file: prefer_const_constructors

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:com.example.wheel_of_life/view/colorpannel/createpalette.dart';

// import 'models/sketchmodel.dart';
// import 'dart:io';
// import 'dart:ui';

// import 'package:flutter/rendering.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:ui' as ui;
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart' hide Image;
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:com.example.wheel_of_life/widgets/canvassidedar.dart';
// import 'package:com.example.wheel_of_life/widgets/drawcanvas.dart';

// import '../../models/colorpalletemodel.dart';
// import '../../models/drawingmode.dart';
// import '../../models/sketch.dart';
// import '../../models/sketchmodel.dart';
// import '../../utils/mycolors.dart';
// import '../../widgets/create.dart';

// class DrawingBoard extends StatefulWidget {
//   final SketchModel sketch;

//   const DrawingBoard({Key? key, required this.sketch}) : super(key: key);

//   @override
//   State<DrawingBoard> createState() => _DrawingBoardState();
// }

// class _DrawingBoardState extends State<DrawingBoard> {
//   Future<Uint8List?> getBytes() async {
//     print("test 1 okay");
//     RenderRepaintBoundary boundary =
//         canvaskey.currentContext!.findRenderObject() as RenderRepaintBoundary;
//     print("test 2 okay");
//     ui.Image image = await boundary.toImage();
//     print("test 3 okay");
//     ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
//     print("test 4 okay");
//     Uint8List? pngBytes = byteData?.buffer.asUint8List();
//     print("test 5 okay");
//     return pngBytes;
//   }

//   void saveFile(Uint8List bytes, String extension) async {
//     String fileName =
//         'FlutterLetsDraw-${DateTime.now().toIso8601String()}.$extension';
//     if (kIsWeb) {
//       // Saving files not supported on web
//       return;
//     } else {
//       Directory? appDocDir = await getExternalStorageDirectory();

//       if (appDocDir != null) {
//         String filePath = '${appDocDir.path}/$fileName';

//         await File(filePath).writeAsBytes(bytes);

//         // Refresh media gallery to show the saved file
//         await ImageGallerySaver.saveFile(filePath);
//       }
//     }
//   }

//   bool check = false;
//   void changeTexture() {
//     setState(() {
//       check = !check;
//     });
//   }

//   double drawBoard = 0.09;
//   Color selectedColor = Colors.black;
//   double strokeWidth = 5;
//   List<DrawingPoint?> drawingPoints = [];
//   List colors = [
//     Colors.pink.value,
//     Colors.black87.value,
//     Colors.yellow.value,
//     Colors.red.value,
//     Colors.amberAccent.value,
//     Colors.purple.value,
//     Colors.green.value,
//     Colors.red.value,
//     Colors.amberAccent.value,
//     Colors.purple.value,
//     Colors.green.value,
//   ];
//   final List<String> backgrounds = [
//     'assets/textures/1.jpg',
//     'assets/textures/2.jpg',
//     'assets/textures/3.jpg',
//     'assets/textures/4.jpg',
//     'assets/textures/5.jpg',
//     'assets/textures/6.jpg',
//     'assets/textures/7.jpg',
//     'assets/textures/8.jpg',
//     'assets/textures/9.jpg',
//     'assets/textures/10.jpg',
//     'assets/textures/11.jpg',
//     'assets/textures/2.jpg',
//     'assets/textures/13.jpg',
//   ];
//   int _currentImageIndex = 0;
//   GlobalKey canvaskey = GlobalKey();
//   Color _selectedColor = Colors.blue.withOpacity(0.5);
//   double _opacity = 0.5;

//   void _onColorChanged(Color newColor) {
//     setState(() {
//       selectedColor = newColor.withOpacity(_opacity);
//     });
//   }

//   void _onOpacityChanged(double newOpacity) {
//     setState(() {
//       _opacity = newOpacity;
//       selectedColor = selectedColor.withOpacity(_opacity);
//     });
//   }

//   void _undoDrawing() {
//     drawingPoints.removeLast();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
// // i
//     return Scaffold(
//       backgroundColor: appbg,
//       body: Column(
//         children: [
//           Container(
//             color: appbg,
//             height: height / 19,
//           ),
//           Container(
//             height: 60,
//             color: appbg,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 IconButton(
//                   onPressed: () {},
//                   icon: Icon(
//                     CupertinoIcons.left_chevron,
//                     color: Colors.black,
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     _undoDrawing();
//                   },
//                   icon: Icon(
//                     Icons.undo,
//                     color: Colors.black,
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     changeTexture();
//                   },
//                   icon: Icon(
//                     Icons.check_box_rounded,
//                     color: Colors.black,
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: () {},
//                   icon: Icon(
//                     Icons.redo_sharp,
//                     color: Colors.black,
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: () async {
//                     {
//                       Uint8List? pngBytes = await getBytes();
//                       if (pngBytes != null) saveFile(pngBytes, 'png');
//                     }
//                     Get.snackbar("Image", "Your Image has been saved",
//                         snackPosition: SnackPosition.BOTTOM,
//                         colorText: Colors.black,
//                         backgroundColor: appbg);
//                   },
//                   icon: Icon(
//                     Icons.download,
//                     color: Colors.black,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15),
//             child: RepaintBoundary(
//               key: canvaskey,
//               child: Stack(
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         // increment the current image index and wrap around if necessary
//                         _currentImageIndex =
//                             (_currentImageIndex + 1) % backgrounds.length;
//                       });
//                     },
//                     child: Image.asset(
//                       backgrounds[_currentImageIndex],
//                       height: height / 1.45,
//                       width: width,
//                     ),
//                   ),
//                   Container(
//                     height: height / 1.6,
//                     width: width,
//                     child: Center(
//                       child: Image(
//                         image: AssetImage(widget.sketch.url),
//                       ),
//                     ),
//                     //  child: DrawingCanvas(),
//                   ),
//                   GestureDetector(
//                     onPanStart: (details) {
//                       setState(() {
//                         drawingPoints.add(
//                           DrawingPoint(
//                             details.localPosition,
//                             Paint()
//                               ..color = selectedColor
//                               ..isAntiAlias = true
//                               ..strokeWidth = strokeWidth
//                               ..strokeCap = StrokeCap.round,
//                           ),
//                         );
//                       });
//                     },
//                     onPanUpdate: (details) {
//                       setState(() {
//                         drawingPoints.add(
//                           DrawingPoint(
//                             details.localPosition,
//                             Paint()
//                               ..color = selectedColor
//                               ..isAntiAlias = true
//                               ..strokeWidth = strokeWidth
//                               ..strokeCap = StrokeCap.round,
//                           ),
//                         );
//                       });
//                     },
//                     onPanEnd: (val) {
//                       setState(() {
//                         drawingPoints.add(null);
//                       });
//                     },
//                     child: CustomPaint(
//                       painter: DrawingPainter(drawingPoints),
//                       child: SizedBox(
//                         height: height / 1.5,
//                         width: MediaQuery.of(context).size.width,
//                       ),
//                     ),
//                   ),

//                   // Positioned(
//                   //     top: 40,
//                   //     right: 30,
//                   //     child: Row(
//                   //       children: [
//                   //         Slider(
//                   //             thumbColor: const Color.fromRGBO(178, 145, 186, 1),
//                   //             activeColor: const Color.fromRGBO(178, 145, 186, 1),
//                   //             min: 0,
//                   //             max: 40,
//                   //             value: strokeWidth,
//                   //             onChanged: (val) => setState(() => strokeWidth = val)),
//                   //         ElevatedButton.icon(
//                   //           style: ElevatedButton.styleFrom(
//                   //               primary: const Color.fromRGBO(178, 145, 186, 1)),
//                   //           onPressed: () => setState(() => drawingPoints = []),
//                   //           icon: const Icon(Icons.clear),
//                   //           label: const Text("Clear Board"),
//                   //         )
//                   //       ],
//                   //     ))
//                 ],
//               ),
//             ),
//           ),
//           // Container(
//           //   height: 100,
//           //   child: ListView.builder(
//           //     scrollDirection: Axis.horizontal,
//           //     itemCount: backgrounds.length,
//           //     itemBuilder: (context, index) {
//           //       return ListTile(
//           //         onTap: () {
//           //           setState(() {
//           //             _currentImageIndex = index;
//           //           });
//           //         },
//           //         leading: Image.asset(
//           //           backgrounds[index],
//           //           height: 50,
//           //           width: 50,
//           //           fit: BoxFit.cover,
//           //         ),
//           //         title: Text('Image ${index + 1}'),
//           //         selected: _currentImageIndex == index,
//           //         selectedTileColor: Colors.grey,
//           //       );
//           //     },
//           //   ),
//           // ),
//           check
//               ? Container(
//                   color: appbg,
//                   height: height / 6,
//                   child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: backgrounds.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         return GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               _currentImageIndex = index;
//                             });
//                           },
//                           child: Container(
//                             margin: EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               border: Border.all(width: 1),
//                               borderRadius: BorderRadius.circular(5),
//                               image: DecorationImage(
//                                 image: AssetImage(backgrounds[index]),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                             width: 100,
//                             height: 120,
//                           ),
//                         );
//                       }))
//               : Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         Container(
//                           height: 28,
//                           width: MediaQuery.of(context).size.width - 120,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             gradient: LinearGradient(
//                               colors: [
//                                 selectedColor.withOpacity(0.2),
//                                 selectedColor.withOpacity(_opacity),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Container(
//                           height: 30,
//                           width: 30,
//                           decoration: BoxDecoration(
//                             color: selectedColor.withOpacity(_opacity),
//                             border: Border.all(width: 1.5),
//                             borderRadius:
//                                 const BorderRadius.all(Radius.circular(20)),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Container(
//                       width: 400,
//                       child: Slider(
//                         value: _opacity,
//                         min: 0,
//                         max: 1,
//                         activeColor: selectedColor,
//                         onChanged: _onOpacityChanged,
//                       ),
//                     ),
//                     Container(
//                       color: appbg,
//                       height: height / 16,
//                       child:
//                           ListView(scrollDirection: Axis.horizontal, children: [
//                         Column(
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceAround,
//                               children: [
//                                 InkWell(
//                                   onTap: () async {
//                                     // MyColorPallet result = await Navigator.push(
//                                     //   context,
//                                     //   MaterialPageRoute(
//                                     //       builder: (context) =>
//                                     //           const PalletScreen()),
//                                     // );
//                                     // setState(() {
//                                     //   colors = result.mycolors;
//                                     // });

//                                     // print(result.pallete_nme);
//                                    // print(result.mycolors);
//                                   },
//                                   child: Image(
//                                       height: 40,
//                                       image: AssetImage(
//                                           "assets/art/colorpicker.png")),
//                                 ),
//                                 Container(
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceAround,
//                                     children: List.generate(
//                                       colors.length,
//                                       (index) =>
//                                           _buildColorChoose(colors[index]),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ]),
//                     ),
//                   ],
//                 ),
//         ],
//       ),
//     );
//   }

//   Widget _buildColorChoose(int color) {
//     bool isSelected = selectedColor == color;
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedColor = Color(color);
//         });
//       },
//       child: Container(
//         height: isSelected ? 47 : 40,
//         width: isSelected ? 47 : 40,
//         decoration: BoxDecoration(
//           color: Color(color),
//           shape: BoxShape.circle,
//           border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
//         ),
//       ),
//     );
//   }
// }

// class DrawingPainter extends CustomPainter {
//   final List<DrawingPoint?> drawingPoints;

//   DrawingPainter(this.drawingPoints);
//   @override
//   void paint(Canvas canvas, Size size) {
//     for (int i = 0; i < drawingPoints.length - 1; i++) {
//       DrawingPoint? current = drawingPoints[i];
//       DrawingPoint? next = drawingPoints[i + 1];
//       if (current != null && next != null) {
//         canvas.drawLine(current.offset, next.offset, current.paint);
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }

// class DrawingPoint {
//   Offset offset;
//   Paint paint;

//   DrawingPoint(this.offset, this.paint);
// }
