import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final double size ;
  final String text;
  final Color? color;
  final TextAlign textAlign;
  final int? maxlines;

  const AppText({super.key, required this.text, this.color, this.size = 14,this.textAlign = TextAlign.start,this.maxlines =30});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
        style: Theme.of(context).textTheme.bodyMedium
            ?.copyWith(color: color,fontSize: size,overflow: TextOverflow.ellipsis),
      textAlign: textAlign,
      maxLines: maxlines,
      textScaler: const TextScaler.linear(1.0),
    );
  }
}
