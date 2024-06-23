import 'package:flutter/material.dart';

class FoodItem extends StatelessWidget {
  final String imagePath;
  final String title;

  const FoodItem({
    super.key,
    required this.imagePath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.23,
      height: 100,
      child: Column(
        children: [
          Expanded(
            child: Image.asset(
              imagePath,
            ),
          ),
          Text(title),
        ],
      ),
    );
  }
}

List<Map<String, String>> foodItems1 = [
  {"title": "Offers", "image": "assets/images/offer.png"},
  {"title": "Chicken", "image": "assets/images/chicken.png"},
  {"title": "Rice", "image": "assets/images/rice.png"},
  {"title": "Burger", "image": "assets/images/burger.png"},
];

List<Map<String, String>> foodItems2 = [
  {"title": "Pizza", "image": "assets/images/pizza.png"},
  {"title": "Coffee", "image": "assets/images/coffee.png"},
  {"title": "Boba", "image": "assets/images/boba.png"},
  {"title": "Salad", "image": "assets/images/salad.png"},
];
