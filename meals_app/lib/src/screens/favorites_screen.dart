import 'package:flutter/material.dart';
import 'package:meals_app/src/models/meal.dart';
import 'package:meals_app/src/widgets/meal_item.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Meal>? favoriteMeals;

  const FavoritesScreen({this.favoriteMeals});

  @override
  Widget build(BuildContext context) {
    if (favoriteMeals!.isEmpty) {
      return Center(
        child: Text("Nothing..."),
      );
    }

    return ListView.builder(
      itemCount: favoriteMeals!.length,
      itemBuilder: (BuildContext context, int index) {
        return MealItem(
          id: favoriteMeals![index].id,
          title: favoriteMeals![index].title,
          imageUrl: favoriteMeals![index].imageUrl,
          duration: favoriteMeals![index].duration,
          complexity: favoriteMeals![index].complexity,
          affordability: favoriteMeals![index].affordability,
        );
      },
    );
  }
}
