import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final double size;

  const CircularButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.color = Colors.white,
    this.size = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 1),
        ),
        child: Center(
          child: Icon(
            icon,
            color: color,
            size: 12 * (size / 40), // scale like SwiftUI example
          ),
        ),
      ),
    );
  }
}
