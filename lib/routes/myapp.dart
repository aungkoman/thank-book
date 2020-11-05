import 'package:flutter/material.dart';
import 'package:thank_book/routes/home-page.dart';
import 'package:thank_book/routes/thank-detail.dart';
import 'package:thank_book/routes/thank-form.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thank Book',
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName : (context) => HomePage(),
        ThankForm.routeName : (context) => ThankForm(),
        ThankDetail.routeName : (context) => ThankDetail(),
      },
    );
  }
}
