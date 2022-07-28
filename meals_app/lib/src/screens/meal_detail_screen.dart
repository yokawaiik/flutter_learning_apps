import 'package:flutter/material.dart';
import 'package:meals_app/src/data/dummy_data.dart';

class MealDetailScreen extends StatelessWidget {
  final Function? toggleFavorite;
  final Function? isMealFavorite;

  MealDetailScreen({this.toggleFavorite, this.isMealFavorite});

  static const String routeName = "MealDetailScreen";

  @override
  Widget build(BuildContext context) {
    final mealId = ModalRoute.of(context)!.settings.arguments as String;

    final meal = DUMMY_MEALS.firstWhere((meal) => meal.id == mealId);

    Widget _buildSectionTitle(BuildContext context, String text) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          text,
          style: Theme.of(context).textTheme.headline6,
        ),
      );
    }

    Widget _buildContainer({required Widget child, required double height}) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        height: height,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        width: double.infinity,
        child: child,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(meal.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                meal.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            _buildSectionTitle(context, "Ingredients"),
            _buildContainer(
              height: 200,
              child: ListView.builder(
                // clipBehavior: Clip.antiAlias,
                // shrinkWrap: true,
                itemCount: meal.ingredients.length,
                itemBuilder: (ctx, index) => Card(
                  color: Theme.of(context).primaryColorDark,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Text(meal.ingredients[index]),
                  ),
                ),
              ),
            ),
            _buildSectionTitle(context, "Steps"),
            _buildContainer(
              height: 200,
              child: ListView.builder(
                // clipBehavior: Clip.antiAlias,
                itemCount: meal.steps.length,
                itemBuilder: (ctx, index) => Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        child: Text('# ${index + 1}'),
                      ),
                      title: Text(meal.steps[index]),
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(isMealFavorite!(meal.id) ? Icons.favorite : Icons.favorite_border),
        onPressed: () => toggleFavorite!(meal.id),
          // Navigator.of(context).pop(mealId);
        
      ),
    );
  }
}
