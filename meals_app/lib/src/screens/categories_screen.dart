import 'package:flutter/material.dart';
import 'package:meals_app/src/data/dummy_data.dart';
import 'package:meals_app/src/widgets/category_item.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  static const String routeName = "CategoriesScreen";

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(12),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 3 / 2,
      ),
      children: DUMMY_CATEGORIES
          .map(
            (category) => CategoryItem(
              id: category.id,
              title: category.title,
              color: category.color,
            ),
          )
          .toList(),
    );
  }
}
