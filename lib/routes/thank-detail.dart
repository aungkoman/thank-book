import 'package:flutter/material.dart';

class ThankDetail extends StatefulWidget {
  static const String routeName = "/thank-detail";
  @override
  _ThankDetailState createState() => _ThankDetailState();
}

class _ThankDetailState extends State<ThankDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thank Detail'),
      ),
      body: Center(child: Text('Thank Detail'),),
    );
  }
}
