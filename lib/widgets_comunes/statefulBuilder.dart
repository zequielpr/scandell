import 'package:flutter/material.dart';

typedef Disposer = void Function();

class MyStatefulBuilder extends StatefulWidget {
  const MyStatefulBuilder({
    required Key? key,
    required this.builder,
    required this.dispose,
  }) : assert(builder != null),
        super(key: key);

  final StatefulWidgetBuilder builder;
  final Disposer dispose;

  @override
  _MyStatefulBuilderState createState() => _MyStatefulBuilderState();
}

class _MyStatefulBuilderState extends State<MyStatefulBuilder> {
  @override
  Widget build(BuildContext context) => widget.builder(context, setState);

  @override
  void dispose() {
    super.dispose();
    widget.dispose();
  }
}