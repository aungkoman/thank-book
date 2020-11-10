import 'package:shared_preferences/shared_preferences.dart';

class ThankSharedPreference {
  static SharedPreferences sPref;
  ThankSharedPreference(){
    print("ThankSharedPreference constructor");
    print("sPref is "+sPref.toString());
    _initialize();
  }
  void _initialize() async{
    print("ThankSharedPreference initialize");
    sPref = await SharedPreferences.getInstance();
    print("sPref is "+sPref.toString());
  }

}