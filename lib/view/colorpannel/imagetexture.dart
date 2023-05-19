// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as image;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:com.example.wheel_of_life/widgets/draingcanvas.dart';

import '../../models/drawingmode.dart';
import '../../models/sketch.dart';
import '../../utils/mycolors.dart';

class ImageTexture extends StatefulWidget {
  @override
  State<ImageTexture> createState() => _ImageTextureState();
}

class _ImageTextureState extends State<ImageTexture> {
  List<Color> _selectedColors = [Colors.red];
  String _selectedBackground = 'assets/art/2.png';
  final List<String> _backgrounds = [
    'assets/art/3.png',
    'assets/art/4.png',
    'assets/art/5.png',
    'assets/art/6.png'
  ];
  void _addColor(Color color) {
    setState(() {
      _selectedColors.add(color);
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: appbg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: height / 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.turn_left,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    onTap:
                    () => Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.undo,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    onTap:
                    () => Navigator.pop(context);
                  },
                  icon: Icon(
                    CupertinoIcons.check_mark_circled,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    onTap:
                    () => Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.redo,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    onTap:
                    () => Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.settings,
                    color: Colors.black,
                    size: 30,
                  ),
                )
              ],
            ),
            SizedBox(
              height: height / 30,
            ),
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(_selectedBackground),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(20)),
              height: height / 1.5,
              width: width - 20,
              child: Center(
                  child: Image(
                      height: 300,
                      width: 300,
                      image: AssetImage('assets/art/20.png'))),
            ),
            // ElevatedButton(
            //   onPressed: () async {
            //     final Color newColor = await showDialog(
            //       context: context,
            //       builder: (context) => AlertDialog(
            //         title: Text('Select a color'),
            //         content: SingleChildScrollView(
            //           child: BlockPicker(
            //             pickerColor: Colors.white,
            //             onColorChanged: (color) {
            //               Navigator.of(context).pop(color);
            //             },
            //           ),
            //         ),
            //       ),
            //     );
            //     if (newColor != null) {
            //       _addColor(newColor);
            //     }
            //   },
            //   child: Text('Select a color'),
            // ),
            // Container(
            //   height: 100,
            //   child: ListView.builder(
            //     scrollDirection: Axis.horizontal,
            //     itemCount: _selectedColors.length,
            //     itemBuilder: (context, index) {
            //       final color = _selectedColors[index];
            //       return CircleAvatar(
            //         backgroundColor: color,
            //       );
            //     },
            //   ),
            // ),
            Container(
                height: 100,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _backgrounds.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedBackground = _backgrounds[index];
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(_backgrounds[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                          width: 100,
                          height: 100,
                        ),
                      );
                    })),
          ],
        ),
      ),
    );
  }
}
