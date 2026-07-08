import 'package:flutter/material.dart';

class DrawerListTail extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;
  final double? iconSize;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isExpanded;

  const DrawerListTail({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.iconColor = Colors.black,
    this.iconSize,
    this.backgroundColor,
    this.textColor,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: isExpanded ? Text(title) : Text(''),
      leading: Icon(icon, color: iconColor, size: iconSize),
      tileColor: backgroundColor,
      textColor: textColor,
      onTap: onTap,
    );
  }
}
