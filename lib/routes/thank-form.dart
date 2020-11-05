import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThankForm extends StatefulWidget {
  static const String routeName = "/thank-form";
  @override
  _ThankFormState createState() => _ThankFormState();
}

class _ThankFormState extends State<ThankForm> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> personMap = {
    'person' : '',
    'description' : '',
    'location' : ''
  };

  // String person,description,location;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thank Form'),
      ),
      /* ဘာလို့ Builder ခံပြီး သုံးတာလဲ? ဆိုရမယ်ဆိုရင် context ပြသနာပေါ့ဗျာ ကလေးတွေက Scaffold Context ကို ခေါ်သုံးချင်တော့ မိဘ ကတဆင့် အဘိုးအဘွားဆီ လှမ်းပူဆာတဲ့ သဘော */
        /* အဖေ အမေ ကို တောင်းဆိုလို့ မရတဲ့ ကိစ္စတွေ ဆိုတော့ကာ အဘိုး အဘွားဆီကို တောင်းပေါ့ဗျာ */
      body: Builder(
        builder: (context) =>
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 8),
                      child: TextFormField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(),
                          hintText: "Enter person name",
                          labelText: "Person Name"
                        ),
                        validator: (value){
                          if(value.isEmpty){
                            return "Please enter some text";
                          }
                          else{
                            return null;
                          }
                        }, // validator
                        onChanged: (value){
                          setState(() {
                            personMap['person'] = value;
                            print("person input text onChange "+personMap['person']+ " ... "+personMap['description']);
                          });
                        }, // onChanged
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 8, 20, 8),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(8),
                            border: OutlineInputBorder(),
                            labelText: "Description",
                            hintText: "Enter description",

                        ),
                        validator: (value){
                          if(value.isEmpty){
                            return "Please enter some text";
                          }
                          else{
                            return null;
                          }
                        }, // validator
                        onChanged: (value){
                          setState(() {
                            personMap['description'] = value;
                            print("description input text onChange "+personMap['description']);
                          });
                        }, // onChanged
                      ),
                    ),
                    // location input
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 8, 20, 8),
                      child: TextFormField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(),
                          labelText: "Location",
                          hintText: "Enter Location",
                        ),
                        validator: (value){
                          if(value.isEmpty){
                            return "Please enter Location text";
                          }
                          else{
                            return null;
                          }
                        }, // validator
                        onChanged: (value){
                          setState(() {
                            personMap['location'] = value;
                            print("location input text onChange "+personMap['location']);
                          });
                        }, // onChanged
                      ),
                    ),
                    ElevatedButton(
                        onPressed: (){
                          if(_formKey.currentState.validate()){
                            print("form is validated");
                            Scaffold
                                .of(context)
                                .showSnackBar(SnackBar(content: Text('Form Data ')));
                            Navigator.pop(context);
                          }
                        },
                        child: Text('+ Add Thank Note')
                    )
                  ],
                ),
              ),
            ),
      )
    );
  }
}
