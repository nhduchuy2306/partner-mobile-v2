class ProductItem {
  final int? id;
  final String name;
  final String description;
  final double price;
  final String imagePath;

  ProductItem({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
  });
}

var demoItems = [
  ProductItem(
      id: 1,
      name: "Razer Headset",
      description: "Color: Pink",
      price: 4.99,
      imagePath: "assets/images/products/product_1.png"),
  ProductItem(
      id: 2,
      name: "Game Pad",
      description: "Color: Pink",
      price: 4.99,
      imagePath: "assets/images/products/product_2.png"),
  ProductItem(
      id: 3,
      name: "Keyboard",
      description: "Color: Pink",
      price: 4.99,
      imagePath: "assets/images/products/product_3.png"),
  ProductItem(
      id: 4,
      name: "Mouse",
      description: "Color: Pink",
      price: 4.99,
      imagePath: "assets/images/products/product_4.png"),
  ProductItem(
      id: 5,
      name: "Screen",
      description: "Color: Pink",
      price: 4.99,
      imagePath: "assets/images/products/product_5.png"),
  ProductItem(
      id: 6,
      name: "Usb Hub",
      description: "Color: Pink",
      price: 4.99,
      imagePath: "assets/images/products/product_6.png"),
];

var exclusiveOffers = [demoItems[0], demoItems[1]];
var bestSelling = [demoItems[2], demoItems[3]];
var others = [demoItems[4], demoItems[5]];
