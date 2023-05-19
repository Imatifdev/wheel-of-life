class ImagePackage {
  final int id;
  final String name;
  final int price;
  final int maxImages;

  ImagePackage({
    required this.id,
    required this.name,
    required this.price,
    required this.maxImages,
  });
}

class Packages {
  static final List<ImagePackage> packages = [
    ImagePackage(id: 1, name: "Basic", price: 5, maxImages: 2),
    ImagePackage(id: 2, name: "Premium", price: 10, maxImages: 5),
    ImagePackage(id: 3, name: "Pro", price: 20, maxImages: 10),
    ImagePackage(id: 4, name: "Ultimate", price: 50, maxImages: 20),
    ImagePackage(id: 5, name: "Custom", price: 100, maxImages: 50),
  ];
}
