import 'package:curved_progress_bar/curved_progress_bar.dart';
import 'package:flutter/material.dart';

class CircularBorderIcon extends StatelessWidget {
  final Widget? extra;
  final double size;
  final double percentage;
  final Color color;

  const CircularBorderIcon({
    super.key,
    this.extra,
    required this.size,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CurvedCircularProgressIndicator(
            value: percentage / 100,
            strokeWidth: 10,
            animationDuration: const Duration(seconds: 1),
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            valueColor: AlwaysStoppedAnimation<Color>(
              color,
            ),
          ),
        ),
        SizedBox(
          width: size,
          height: size,
          child: extra ?? Container(),
        ),
      ],
    );
  }
}
