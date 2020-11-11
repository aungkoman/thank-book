import 'package:flutter/material.dart';
import 'package:thank_book/data/open-facebook.dart';

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
      floatingActionButton: FloatingActionButton(
        onPressed: (){ OpenFacebook.openFacebook();},
        child: Icon(Icons.favorite),
      ),
    );
    /*
    return Center(
      child: Text("Thank Book is developed by MmSoftware100"),
    );

     */
  }
}
