import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final Color color1;
  final Color color2;
  final String icon;
  final String name;
  final VoidCallback onTap;

  const CardWidget({
    super.key,
    required this.color1,
    required this.icon,
    required this.name,
    required this.onTap,
    required this.color2,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            gradient: LinearGradient(
              colors: [color1, color2],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.asset(icon),
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  name,
                  style: const TextStyle(color: Colors.white, fontSize: 15.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
