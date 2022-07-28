import 'package:flutter/widgets.dart';

class TabItem {
  final Icon icon;
  final String text;
  final Widget page;
  
  const TabItem({
    required this.icon,
    required this.text,
    required this.page,
  });
}