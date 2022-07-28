import 'package:flutter/material.dart';
import 'package:meals_app/src/data/dummy_data.dart';
import 'package:meals_app/src/models/category_meals_arguments.dart';
import 'package:meals_app/src/models/meal.dart';
import 'package:meals_app/src/widgets/meal_item.dart';

class CategoryMealsScreen extends StatefulWidget {
  static const String routeName = "CategoryMealsScreen";

  late final List<Meal> availableMeals;

  CategoryMealsScreen({required this.availableMeals});

  @override
  State<CategoryMealsScreen> createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
  late final List<Meal>? displayedMeals;
  late final String appBarTitle;

  late bool _lodedInitState = false;

  @override
  void didChangeDependencies() {
    if (!_lodedInitState) {
      final routeArgs =
          ModalRoute.of(context)!.settings.arguments as CategoryMealsArguments;

      appBarTitle = routeArgs.title!;

      displayedMeals = widget.availableMeals.where((meal) {
        return meal.categories.contains(routeArgs.id);
      }).toList();

      _lodedInitState = true;
    }

    super.didChangeDependencies();
  }

  void _removeMeal(String id) {
    setState(() {
      displayedMeals!.removeWhere((meal) => meal.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    final AppBar appBar = AppBar(
      title: Text(appBarTitle),
    );

    return Scaffold(
      appBar: appBar,
      body: Column(
        children: [
          Container(
            height: mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top,
            child: (displayedMeals == null || displayedMeals!.isEmpty)
                ? Center(
                  child: Text("Nothing"),
                )
                : ListView.builder(
                    itemCount: displayedMeals!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return MealItem(
                        id: displayedMeals![index].id,
                        title: displayedMeals![index].title,
                        imageUrl: displayedMeals![index].imageUrl,
                        duration: displayedMeals![index].duration,
                        complexity: displayedMeals![index].complexity,
                        affordability: displayedMeals![index].affordability,
                        // removeMeal: _removeMeal,
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}
