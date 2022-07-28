import 'package:flutter/material.dart';
import 'package:meals_app/src/screens/filter_screen.dart';
import 'package:meals_app/src/screens/tabs_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  Widget _buildListTile({
    required String title,
    required IconData icon,
    required Function tapHandler,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'RobotoCondensed',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () => tapHandler(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: Text(
              'Cooking Up!',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 30,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          _buildListTile(
            title: 'Meals',
            icon: Icons.restaurant,
            tapHandler: () {
              Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
            },
          ),
          _buildListTile(
            title: 'Filters',
            icon: Icons.settings,
            tapHandler: () {
              Navigator.of(context).pushNamed(FilterScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
