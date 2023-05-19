// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';

class Screen1 extends StatefulWidget {
  const Screen1({Key? key}) : super(key: key);

  @override
  _Screen1State createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  List<String> _selectedImages = [];
  List<String> _imageList = [
    'assets/art/2.png',
    'assets/art/3.png',
    'assets/art/4.png',
    'assets/art/5.png',
    'assets/art/6.png',
    'assets/art/7.png',
    'assets/art/8.png',
    'assets/art/9.png',
    'assets/art/12.png',
    'assets/art/11.png'
  ];
  int _maxImages = 3;

  void _onImageSelected(String imageUrl) {
    setState(() {
      if (_selectedImages.contains(imageUrl)) {
        _selectedImages.remove(imageUrl);
      } else {
        if (_selectedImages.length < _maxImages) {
          _selectedImages.add(imageUrl);
        } else {
          // Show an error message or other feedback to the user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('You have reached the maximum number of images.'),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Screen 1'),
      ),
      body: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemCount: _imageList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              _onImageSelected(_imageList[index]);
            },
            child: Stack(
              children: [
                Image.asset(_imageList[index]),
                if (_selectedImages.contains(_imageList[index]))
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Screen2(selectedImages: _selectedImages),
            ),
          );
        },
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}

class Screen2 extends StatelessWidget {
  final List<String> selectedImages;

  const Screen2({Key? key, required this.selectedImages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Screen 2'),
      ),
      body: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemCount: selectedImages.length,
        itemBuilder: (BuildContext context, int index) {
          return Image.asset(selectedImages[index]);
        },
      ),
    );
  }
}
