import 'package:flutter/material.dart';
import 'package:meals_app/src/models/meal.dart';
import 'package:meals_app/src/models/tab_item.dart';
import 'package:meals_app/src/screens/categories_screen.dart';
import 'package:meals_app/src/screens/favorites_screen.dart';
import 'package:meals_app/src/widgets/main_drawer.dart';

class TabsScreen extends StatefulWidget {
  final List<Meal>? favoriteMeals;

  TabsScreen({this.favoriteMeals});

  static const String routeName = 'TabsScreen';

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _currentIndexPage = 0;

  late final List<TabItem> _tabs;

  @override
  void initState() {
    _tabs = [
      TabItem(
        icon: Icon(Icons.category),
        text: "Categories",
        page: CategoriesScreen(),
      ),
      TabItem(
        icon: Icon(Icons.favorite),
        text: "Favorites",
        page: FavoritesScreen(
          favoriteMeals: widget.favoriteMeals,
        ),
      ),
    ];
    super.initState();
  }

  void _selectTab(int pageIndex) {
    setState(() {
      _currentIndexPage = pageIndex;
    });
  }

  Widget _currentPageView() {
    return _tabs.toList()[_currentIndexPage].page;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tabs[_currentIndexPage].text),
      ),
      drawer: MainDrawer(),
      body: _currentPageView(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndexPage,
        items: _tabs
            .map((tab) => BottomNavigationBarItem(
                  icon: tab.icon,
                  label: tab.text,
                ))
            .toList(),
        onTap: _selectTab,
      ),
    );
  }
}
