import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:thank_book/data/notification-class.dart';
import 'package:thank_book/data/thank-note-db.dart';
import 'package:thank_book/data/thank-note.dart';

class ThankForm extends StatefulWidget {
  static const String routeName = "/thank-form";
  @override
  _ThankFormState createState() => _ThankFormState();
}

class _ThankFormState extends State<ThankForm> {
  final _formKey = GlobalKey<FormState>();

  /* get data from rounte */

  Map<String, dynamic> personMap = {
    'id' : null,
    'person' : '',
    'description' : '',
    'location' : '',
    'reminder' : true,
    'reminder_date' : null,
    'reminder_time' : null
  };

  Map<String, dynamic> initialData;
/*
  Map<String, dynamic> initialData = {
    'id' : null,
    'person' : '',
    'description' : '',
    'location' : ''
  };

 */

  // String person,description,location;


  TextEditingController dateReminderController = TextEditingController();
  TextEditingController timeReminderController = TextEditingController();

  NotificationClass notificationClass;
  int isInitialize = 0;
  @override
  void initState() {
    // TODO: implement initState
    print("ThankForm initState");
    super.initState();
    isInitialize++;
    print("isInitialize "+isInitialize.toString());
    initialize();
  }

  void initialize() async{
    print("ThankForm initialize");
    notificationClass = NotificationClass(context);
  }

  @override
  Widget build(BuildContext context) {

    final ThankNote passedThankNote = ModalRoute.of(context).settings.arguments;
    print("ThankForm build passedThankNote "+passedThankNote.toString());



    if(isInitialize == 1){
      timeReminderController.text = (initialData != null && initialData['reminder_time'] != null ) ? initialData['reminder_time'] : null;
      dateReminderController.text = (initialData != null && initialData['reminder_date'] != null ) ? initialData['reminder_date'] : null;
      isInitialize++;

      if(passedThankNote != null){
        setState(() {
          initialData = passedThankNote.toMap();
          /* make sure it is first time */
          if(initialData['id'] != personMap['id']){
            personMap = initialData;
            personMap['reminder'] = (personMap['reminder'] == "true") ? true : false; // String နဲ့ မှတ်ထားလို့
            // ဒီမှာ render လုပ်ရင် bool နဲ့ လုပ်နေတာ :D
          }
        });
        print("initialData id is "+initialData['id'].toString());
      };

    }

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
                        initialValue: (initialData != null) ? initialData['person'] : null,
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
                        initialValue: (initialData != null) ? initialData['description'] : null,
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
                        initialValue: (initialData != null) ? initialData['location'] : null,
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
                    // location input
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 8, 20, 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: ListTile(
                        title: Text("Reminder"),
                        trailing: Checkbox(
                          value: personMap['reminder'],
                          onChanged: (value){
                            print("Reminder checkbox onChanged "+value.toString());
                            setState(() {
                              personMap['reminder'] = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: personMap['reminder'],
                      child: Container(
                        margin: EdgeInsets.fromLTRB(20, 8, 20, 8),
                        child: TextFormField(
                          readOnly: true,
                          controller: dateReminderController,
                          /* controller နဲ့ initialValue:  ကို ပေါင်းသုံးလို့မရပါ တစ်ခုပဲ သုံးရပါမယ်။ */
                          // initialValue: (initialData != null ) ? initialData['reminder_date'] : null,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(8),
                            border: OutlineInputBorder(),
                            labelText: "Reminder Date",
                            hintText: "Choose Date",
                          ),
                          validator: (value){
                            if(value.isEmpty){
                              return "Tap to choose date";
                            }
                            else{
                              return null;
                            }
                          }, // validator
                          onChanged: (value){
                            print("date input text onChange "+personMap['date']);
                          }, // onChanged
                          onTap: (){
                            print("date field onTap");
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime.now(),
                                maxTime: DateTime(2300),
                                onChanged: (date) {
                                  print('change $date');
                                  dateReminderController.text = date.toString();
                                  setState(() {
                                    personMap['reminder_date'] = date.toString();
                                    print("personMap data is "+personMap['reminder_date']);
                                  });
                                }, onConfirm: (date) {
                                  print('confirm $date');
                                  dateReminderController.text = date.toString();
                                  setState(() {
                                    personMap['reminder_date'] = date.toString();
                                    print("personMap data is "+personMap['reminder_date']);
                                  });
                                },
                                currentTime: DateTime.now(), locale: LocaleType.en
                            );
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: personMap['reminder'],
                      child: Container(
                        margin: EdgeInsets.fromLTRB(20, 8, 20, 8),
                        child: TextFormField(
                          readOnly: true,
                          controller: timeReminderController,
                          // we can't use both initialValue and controller at the same time
                          // initialValue: (initialData != null ) ? initialData['reminder_time'] : null,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(8),
                            border: OutlineInputBorder(),
                            labelText: "Reminder Time",
                            hintText: "Choose Time",
                          ),
                          validator: (value){
                            if(value.isEmpty){
                              return "Tap to choose time";
                            }
                            else{
                              return null;
                            }
                          }, // validator
                          onChanged: (value){
                            setState(() {
                              print("time input text onChange "+personMap['date']);
                            });
                          }, // onChanged
                          onTap: (){
                            print("time field onTap");
                            DatePicker.showTimePicker(context,
                                showTitleActions: true,
                                onChanged: (time) {
                                  print('change $time');
                                  timeReminderController.text = time.toString();
                                  setState(() {
                                    personMap['reminder_time'] = time.toString();
                                  });
                                },
                                onConfirm: (time) {
                                  print('confirm $time');
                                  timeReminderController.text = time.toString();
                                  setState(() {
                                    personMap['reminder_time'] = time.toString();
                                  });
                                },
                                currentTime: DateTime.now(), locale: LocaleType.en
                            );
                          },
                        ),
                      ),
                    ),

                    ElevatedButton(
                        onPressed: () async {
                          print("id is "+ personMap['id'].toString());
                          if(_formKey.currentState.validate()){
                            print("form is validated");
                            Scaffold
                                .of(context)
                                ..removeCurrentSnackBar()
                                ..showSnackBar(SnackBar(content: Text('Form Data is validated ')));
                            //  add to database



                            // database class instance
                            ThankNoteDb thankNoteDb = ThankNoteDb();
                            // omit id to get auto increment
                            // data class instance

                            // ဒီနေရာမှာ personMap ကို ထည့်ပေးလိုက်ရင်တောင် အဆင်ပြေတယ်။
                            print("final personMap is "+personMap.toString());
                            ThankNote thankNote = ThankNote(
                              id: personMap['id'],
                              person: personMap['person'],
                              description: personMap['description'],
                              location: personMap['location'],
                              reminder: personMap['reminder'].toString(),
                              reminder_date: personMap['reminder_date'],
                              reminder_time: personMap['reminder_time'],
                            );
                            print("final thankNote is "+thankNote.toString());
                            /*
                            ThankNote thankNote = ThankNote(
                              id: personMap['id'],
                              person: personMap['person'],
                              description: personMap['description'],
                              location: personMap['location'],
                              reminder_date: personMap['reminder_date'],
                              reminder_time: personMap['reminder_time'],
                            );

                             */
                            // insert data to database
                            print("insert or update thankNote data  is "+thankNote.toString());
                            thankNote = await thankNoteDb.insertThankNote(thankNote);

                            /*
                             ဒီနေရာမှာ notification setup လုပ်ရမယ်
                             inserted id နဲ့ reminder status အပေါမူတည်ပြီး
                             */
                            print("inserted/updated Thank Note "+thankNote.toString());
                            if(thankNote.reminder == "true"){
                              // add zonedScheduled notification
                              final DateTime day = DateTime.parse(thankNote.reminder_date);
                              final DateTime time = DateTime.parse(thankNote.reminder_time);
                              notificationClass.scheduleDailyNotification(thankNote.id, time.hour, time.minute, title: thankNote.person, message: thankNote.description,payload: thankNote.description);
                              print("notification set ");
                            }
                            else{
                              notificationClass.cancelNotification(thankNote.id);
                              print("notification calcel");
                            }
                            List<PendingNotificationRequest>  notiList = await notificationClass.pendingNotificationRequests();
                            print("pending notificaiton is "+notiList.toString());
                            notiList.forEach((noti) {
                              print("noti is "+noti.title);
                            });
                            // go back
                            Navigator.pop(context,thankNote);
                          }
                        },
                        child: Text((initialData != null) ? "Update" : "+ Add")
                    )
                  ],
                ),
              ),
            ),
      )
    );
  }
}
