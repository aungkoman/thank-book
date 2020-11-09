import 'package:flutter/material.dart';

class AboutApp extends StatelessWidget {
  static const String routeName = "/about-app";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Thank Book"),
      ),
      body: Center(
        child: Text("Thank Book is developed by MmSoftware100"),
      ),
    );
    /*
    return Center(
      child: Text("Thank Book is developed by MmSoftware100"),
    );

     */
  }
}
