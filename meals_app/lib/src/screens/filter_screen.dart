import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  static const String routeName = "FilterScreen";

  final Function? saveFilters;

  final Map<String, bool> currentFilters;

  const FilterScreen({this.saveFilters, required this.currentFilters});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late bool? _glutenFree;
  late bool? _vegetarian;
  late bool? _vegan;
  late bool? _lactoseFree;

  @override
  void initState() {
    _glutenFree = widget.currentFilters['gluten'];
    _vegetarian = widget.currentFilters['vegetarian'];
    _vegan = widget.currentFilters['vegan'];
    _lactoseFree = widget.currentFilters['lactose'];

    super.initState();
  }

  Widget _buildSwitchListTile({
    required String title,
    required String subtitle,
    required bool currentValue,
    required Function updateValue,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: currentValue,
      onChanged: (newValue) => updateValue(newValue),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your filter"),
        actions: [
          IconButton(
            onPressed: () {
              final Map<String, bool> _filters = {
                'gluten': _glutenFree!,
                'lactose': _lactoseFree!,
                'vegan': _vegetarian!,
                'vegetarian': _vegetarian!,
              };

              widget.saveFilters!(_filters);
            },
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              'Adjust your meal selection.',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildSwitchListTile(
                  title: 'Gluten-free',
                  subtitle: "Only include gluten-free meals",
                  currentValue: _glutenFree!,
                  updateValue: (newValue) {
                    setState(() {
                      _glutenFree = newValue;
                    });
                  },
                ),
                _buildSwitchListTile(
                  title: 'Lactose-free',
                  subtitle: "Only include lactose-free meals",
                  currentValue: _lactoseFree!,
                  updateValue: (newValue) {
                    setState(() {
                      _lactoseFree = newValue;
                    });
                  },
                ),
                _buildSwitchListTile(
                  title: 'Vegan-free',
                  subtitle: "Only include veganmeals",
                  currentValue: _vegan!,
                  updateValue: (newValue) {
                    setState(() {
                      _vegan = newValue;
                    });
                  },
                ),
                _buildSwitchListTile(
                  title: 'Vegetarian-free',
                  subtitle: "Only include vegetarian meals",
                  currentValue: _vegetarian!,
                  updateValue: (newValue) {
                    setState(() {
                      _vegetarian = newValue;
                    });
                  },
                ), 
              ],
            ),
          ),
        ],
      ),
    );
  }
}
