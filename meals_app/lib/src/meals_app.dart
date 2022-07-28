import 'package:flutter/material.dart';
import 'package:meals_app/src/data/dummy_data.dart';
import 'package:meals_app/src/models/meal.dart';
import 'package:meals_app/src/screens/categories_screen.dart';
import 'package:meals_app/src/screens/category_meals_screen.dart';
import 'package:meals_app/src/screens/filter_screen.dart';
import 'package:meals_app/src/screens/meal_detail_screen.dart';
import 'package:meals_app/src/screens/tabs_screen.dart';

class MealsApp extends StatefulWidget {
  @override
  State<MealsApp> createState() => _MealsAppState();
}

class _MealsAppState extends State<MealsApp> {
  Map<String, bool> _filters = {
    'gluten': false,
    'lactose': false,
    'vegan': false,
    'vegetarian': false,
  };

  List<Meal> _availableMeals = DUMMY_MEALS;

  List<Meal> _favoriteMeals = [];

  void _setFilters(Map<String, bool> filterData) {
    print(filterData);

    setState(() {
      _filters = filterData;

      _availableMeals = DUMMY_MEALS.where((meal) {
        if (_filters['gluten']! && !meal.isGlutenFree) return false;

        if (_filters['lactose']! && !meal.isLactoseFree) return false;

        if (_filters['vegan']! && !meal.isVegan) return false;

        if (_filters['vegetarian']! && !meal.isVegetarian) return false;

        return true;
      }).toList();
    });
  }

  void _toggleFavorite(String mealId) {
    final existingIndex =
        _favoriteMeals.indexWhere((meal) => meal.id == mealId);
    // meal finds
    setState(() {
      if (existingIndex >= 0) {
        _favoriteMeals.removeAt(existingIndex);
      } else {
        _favoriteMeals.add(DUMMY_MEALS.firstWhere((meal) => meal.id == mealId));
      }
    });
  }

  bool _isMealFavorite(String id) {
    return _favoriteMeals.any((meal) => meal.id == id);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "DeliMeals",
      theme: ThemeData(
        primarySwatch: Colors.lime,
        canvasColor: Color.fromRGBO(255, 253, 229, 1),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyText1: TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              bodyText2: TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              headline6: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'RobotoCondensed',
              ),
            ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.lime,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black26,
          // selectedItemColor: Colors.purple,
          // unselectedItemColor: Colors.purple[200],
        ),
      ),
      home: TabsScreen(
        favoriteMeals: _favoriteMeals,
      ),
      routes: {
        TabsScreen.routeName: (context) =>
            TabsScreen(favoriteMeals: _favoriteMeals),
        CategoriesScreen.routeName: (context) => CategoriesScreen(),
        CategoryMealsScreen.routeName: (context) =>
            CategoryMealsScreen(availableMeals: _availableMeals),
        MealDetailScreen.routeName: (context) => MealDetailScreen(
              isMealFavorite: _isMealFavorite,
              toggleFavorite: _toggleFavorite,
            ),
        FilterScreen.routeName: (context) => FilterScreen(
              saveFilters: _setFilters,
              currentFilters: _filters,
            ),
      },
      onGenerateRoute: (setting) {
        return MaterialPageRoute(
            builder: (ctx) => TabsScreen(
                  favoriteMeals: _favoriteMeals,
                ));
      },
      onUnknownRoute: (setting) {
        return MaterialPageRoute(builder: (ctx) => TabsScreen());
      },
    );
  }
}
