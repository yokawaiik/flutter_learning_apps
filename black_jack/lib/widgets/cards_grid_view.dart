import 'package:flutter/material.dart';

class CardsGridView extends StatelessWidget {
  final List<Image> cards;

  const CardsGridView({
    required this.cards,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: GridView.builder(
        itemCount: cards.length,
        // physics: const NeverScrollableScrollPhysics(),
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3),
        itemBuilder: (context, index) {
          return Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 8),
            child: cards[index],
          );
        },
      ),
    );
  }
}