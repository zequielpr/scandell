import 'package:flutter/cupertino.dart';

class Vender extends StatefulWidget {
  const Vender({Key? key}) : super(key: key);

  @override
  State<Vender> createState() => _VenderState();
}

class _VenderState extends State<Vender> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: Text('Vender'),),);
  }
}
