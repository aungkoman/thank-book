import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:thank_book/data/thank-note.dart';
import 'package:thank_book/routes/thank-form.dart';
import 'package:thank_book/style/thank-text-style.dart';

class ThankDetail extends StatefulWidget {
  static const String routeName = "/thank-detail";
  @override
  _ThankDetailState createState() => _ThankDetailState();
}

class _ThankDetailState extends State<ThankDetail> {
  ThankNote thankNote;
  int isInitialize = 0 ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("ThankDetail initState");
    isInitialize++;
    initialize();
  }
  Future<void> initialize() async{
    print("ThankDetail initialize");
  }

  @override
  Widget build(BuildContext context) {
    ThankNote tN = ModalRoute.of(context).settings.arguments;
    if(tN != null && isInitialize == 1){
      print("build First Time");
      setState(() {
        thankNote = tN;
        isInitialize++;
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(thankNote.person),
      ),
      body: thankCardStack(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, ThankForm.routeName, arguments: thankNote);
        },
        child: Icon(Icons.edit,),
      ),
    );
  }

  Widget thankCardStack(){
    return Container(
      margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Card(
          elevation: 20,
          child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Text(thankNote.description+ "["+thankNote.location+"]", style: ThankTextStyle.textStyleListDesc)
              )
          )
      ),
    );
  } // thankCardStack

}
