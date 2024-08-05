import 'package:flutter/material.dart';

class AppLargeText extends StatelessWidget {
  final double size ;
  final String text;
  final Color? color;
  final int? maxlines;

  const AppLargeText({super.key, required this.text, this.color, this.size = 30,this.maxlines = 30});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontWeight: FontWeight.bold,color: color,fontSize: size,overflow: TextOverflow.ellipsis),
      maxLines: maxlines,
      textScaler: const TextScaler.linear(1.0),
    );
  }
}
