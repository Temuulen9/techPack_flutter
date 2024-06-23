import 'package:flutter/material.dart';

class FoodCard extends StatelessWidget {
  const FoodCard({super.key, required this.imagePath, required this.title, required this.desc});

  final String imagePath;
  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.red),
          width: MediaQuery.of(context).size.width * 0.4,
          height: 110,
          child: Image.asset(
            imagePath,
            fit: BoxFit.fill,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(desc),
      ],
    );
  }
}

List<Map<String, String>> foodCards = [
  {"title": "McDonald - Karatasura", "desc": "1.2km - 15-20 minutes", "image": "assets/images/mcdonalds.png"},
  {"title": "Fore Coffee - Paragon", "desc": "1.2km - 15-20 minutes", "image": "assets/images/forecoffee.png"},
];
