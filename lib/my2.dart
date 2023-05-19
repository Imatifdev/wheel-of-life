// import 'package:flutter/material.dart';

// import 'models/packagemodel.dart';

// class MyPac extends StatefulWidget {
//   const MyPac({super.key});

//   @override
//   State<MyPac> createState() => _MyPacState();
// }

// class _MyPacState extends State<MyPac> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: GridView.count(
//       crossAxisCount: 2,
//       children: packages.map((package) {
//         return GestureDetector(
//           onTap: () {
//             // Navigate to the image selection screen with the selected package
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => ImageSelectionScreen(package: package),
//               ),
//             );
//           },
//           child: Card(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(package.name),
//                 Text("\$${package.price}"),
//                 Text("${package.maxImages} images"),
//               ],
//             ),
//           ),
//         );
//       }).toList(),
//     ));
//   }
// }

// class ImageSelectionScreen extends StatefulWidget {
//   final ImagePackage package;

//   ImageSelectionScreen({required this.package});

//   @override
//   _ImageSelectionScreenState createState() => _ImageSelectionScreenState();
// }

// class _ImageSelectionScreenState extends State<ImageSelectionScreen> {
//   List<String> selectedImages = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.package.name),
//       ),
//       body: GridView.builder(
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 3,
//           childAspectRatio: 1,
//         ),
//         itemCount: selectedImages.length,
//         itemBuilder: (BuildContext context, int index) {
//           return GestureDetector(
//             onTap: () {
//               if (selectedImages.length >= widget.package.maxImages) {
//                 // Show an error message if the user has selected the maximum number of images
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text(
//                         "You have already selected the maximum number of images."),
//                   ),
//                 );
//               } else {
//                 // Add or remove the image from the selection
//                 setState(() {
//                   if (selectedImages.contains(selectedImages[index])) {
//                     selectedImages.remove(selectedImages[index]);
//                   } else {
//                     selectedImages.add(selectedImages[index]);
//                   }
//                 });
//               }
//             },
//             child: Stack(
//               children: [
//                 Image.asset(images[index]),
//                 if (selectedImages.contains(images[index]))
//                   Positioned(
//                     top: 0,
//                     right: 0,
//                     child: Icon(Icons.check_circle),
//                   ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class ImagePackage {
  final String name;
  final int price;
  final int maxSelectableImages;

  ImagePackage(
      {required this.name,
      required this.price,
      required this.maxSelectableImages});
}

class ImagePackageScreen extends StatefulWidget {
  const ImagePackageScreen({Key? key}) : super(key: key);

  @override
  _ImagePackageScreenState createState() => _ImagePackageScreenState();
}

class _ImagePackageScreenState extends State<ImagePackageScreen> {
  List<ImagePackage> _imagePackages = [
    ImagePackage(name: 'Package 1', price: 5, maxSelectableImages: 2),
    ImagePackage(name: 'Package 2', price: 10, maxSelectableImages: 4),
    ImagePackage(name: 'Package 3', price: 15, maxSelectableImages: 6),
    ImagePackage(name: 'Package 4', price: 20, maxSelectableImages: 8),
    ImagePackage(name: 'Package 5', price: 25, maxSelectableImages: 10),
  ];

  int _selectedPackageIndex = -1;

  void _onSelectPackage(int index) {
    setState(() {
      _selectedPackageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select an image package'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemCount: _imagePackages.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () => _onSelectPackage(index),
            child: Container(
              decoration: BoxDecoration(
                border: _selectedPackageIndex == index
                    ? Border.all(color: Colors.blue, width: 2)
                    : null,
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _imagePackages[index].name,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '\$${_imagePackages[index].price}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Select up to ${_imagePackages[index].maxSelectableImages} images',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
