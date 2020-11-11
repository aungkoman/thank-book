import 'package:flutter/material.dart';
import 'package:thank_book/data/open-facebook.dart';
import 'package:thank_book/routes/about-app.dart';
import 'package:thank_book/routes/setting.dart';
import 'package:url_launcher/url_launcher.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
          children: [
            DrawerHeader(
                child: Center(child: Text("Thank You"))
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Setting"),
              onTap: (){
                print("listTile Setting onTap");
                Navigator.pop(context); // close the drawer
                Navigator.pushNamed(context, Setting.routeName);
              },
            ),
            ListTile(
              leading: Icon(Icons.app_registration),
              title: Text("About"),
              onTap: (){
                print("listTile About onTap");
                Navigator.pop(context); // close the drawer
                Navigator.pushNamed(context, AboutApp.routeName);
              },
            ),
            ListTile(
              leading: Icon(Icons.touch_app),
              title: Text("Facebook Page"),
              onTap: (){
                print("listTile About onTap");
                Navigator.pop(context); // close the drawer
                //Navigator.pushNamed(context, AboutApp.routeName);
                OpenFacebook.openFacebook();
                //_openFacebook();
              },
            ),
          ]
      ),
    );
  }

}

