import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class DataLabel<T> extends StatelessWidget {
  const DataLabel({
    super.key, required this.getValue, this.style
  });

  final String Function(T) getValue;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (context, model, _) {
        return Text(getValue(model), style: style);
      },
    );
  }
}

