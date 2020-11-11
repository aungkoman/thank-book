import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thank_book/componets/main-drawer.dart';
import 'package:thank_book/data/notification-class.dart';
import 'package:thank_book/data/thank-constant.dart';
import 'package:thank_book/data/thank-note-db.dart';
import 'package:thank_book/data/thank-note.dart';
import 'package:thank_book/data/thank-search-delicate.dart';
import 'package:thank_book/main.dart';
import 'package:thank_book/routes/notification-receiver.dart';
import 'package:thank_book/routes/thank-detail.dart';
import 'package:thank_book/routes/thank-form.dart';
import 'package:http/http.dart' as http;
import 'package:thank_book/style/thank-text-style.dart';

class HomePage extends StatefulWidget {
  static String routeName = '/';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // final List<String> list = List.generate(10, (index) => "Text $index");
  final ThankNoteDb thankNoteDb = ThankNoteDb();
  List<ThankNote> thankNotes = [
    ThankNote(id: -1, person: "Thank", description: "Let me thank you for using our app.", location: "MYANMAR"),
    ThankNote(id: -2, person: "How To Use", description: "Just add thankfulness and get remind how beauty our life.", location: "YGN")
  ];

  NotificationClass notificationClass;
  SharedPreferences sPref;
  bool dailyNotificationStatus;
  DateTime dailyNotificationTime;

  @override
  void initState() {
    // TODO: implement initState
    print("HomePage initState");
    super.initState();
    initialize();

  } // initState

  Future<void> initialize() async{
    /* get thankNotes from db */
    print("HomePage initialize");
    final List<ThankNote> thankNotesUpdate = await thankNoteDb.selectThankNote();

    print("thankNotesUpdate.length : "+thankNotesUpdate.length.toString());
    if(thankNotesUpdate.length != 0){
      final thankNotesUpdateReversed = thankNotesUpdate.reversed.toList();
      thankNotesUpdateReversed.forEach((note) {
        print(note.toString());
      });
      setState(() {
        thankNotes = thankNotesUpdateReversed;
        // thankNotes.add(ThankNote(id: 3, person: "person init", description: "description init", location: "MDY"));
        /* အမှန်ကတော့ အသစ် ပြင်လိုက်ရမှာ လောလောဆယ် မပြင်နိုင်သေးလို့ :D */
      });
      notificationClass = NotificationClass(context); // ရုပ်တည်ကြီးနဲ့ context ကို ခေါ်သွားတာ :P
      // notificationClass.ShowNotification();


      // notificationClass.scheduleDailyNotification(ThankConstant.dailyNotificationId, hour, minute)

      /*
        ဒါက ပထမဆုံး အကြိမ်ပဲ ဆိုကြပါစို့
        ဒါဆိုရင် zonedSchedule notificaiton ထည့်ဖို့လိုလာပြီ
        ဘယ် Data ကို ယူပြီး ထည့်မှာလဲ ဆိုရင် default data ဖြစ်တဲ့ ညကိုးနာရီပေါ့။
       */
      sPref = await SharedPreferences.getInstance();
      dailyNotificationStatus = (sPref.getBool('dailyNotificationStatus') != null ) ? sPref.getBool('dailyNotificationStatus') : true;
      sPref.setBool('dailyNotificationStatus', dailyNotificationStatus);
      dailyNotificationTime = (sPref.getString('dailyNotificationTime') != null ) ? DateTime.parse(sPref.getString('dailyNotificationTime')) : DateTime(2020,12,12,21,00,00);
      sPref.setString('dailyNotificationTime', dailyNotificationTime.toString());
      _toggleDailyNotification();
    }

    // _ShowNotification(); // စာအတိုလေးတွေအတွက်ပဲ အဆင်ပြေတယ်
    // _showBigPictureNotification(); // နှစ်ခုလုံးက အတိုလေးတွေပဲ ရမှာ :D

    /*
    အခုလုပ်ရမှာက နေ့တိုင်း ည ကိုးနာရီဆိုရင် ကျေးဇူးတင်ဖို့အတွက် notification တက်ပေးမယ်
    တကယ်လို့ user က မတက်ချင်ဘူးဆိုရင် အဲ့ scheduled notification ကို ဖျတ်ထားပေးမယ်
    အချိန်ပြောင်းရင် လိုက်ပြောင်းထားပေးမယ်
    that's all
    ဒါ က setting page မှာ သွားလုပ်ရမယ် ထင်တယ်။ :D
     */
  }


  void _toggleDailyNotification(){
    if(dailyNotificationStatus == true){
      print("Daily Notification is set at "+dailyNotificationTime.hour.toString() + ":"+ dailyNotificationTime.minute.toString());
      notificationClass.scheduleDailyNotification(ThankConstant.dailyNotificationId, dailyNotificationTime.hour, dailyNotificationTime.minute);
    }
    else{
      print("Daily Notification cancel");
      notificationClass.cancelNotification(ThankConstant.dailyNotificationId);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thank Book'),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () async{
            print("action Search onPressed");
            showSearch(context: context, delegate: ThankSearchDelicate(thankNotes));
          })
        ],
      ),
      drawer: MainDrawer(),
      body: thankCardList(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          print("fab onPresssed at HomePage");
          print("go to "+ThankForm.routeName);
          newThankNoteRouteResult(context);
          // Navigator.pushNamed(context, ThankForm.routeName);
          /*
          setState(() {
            // thankNotes.add(ThankNote(id: 2, person: "person2", description: "description2", location: "YGN"));
            thankNotes.insert(0,ThankNote(id: 2, person: "person2", description: "description2", location: "YGN"));
          });

           */
        },
        tooltip: 'Add new thank',
        child: Icon(Icons.add),
      ),
    );
  }

  /* ဒိ widget တွေက state ကို မှီခိုနေတော့ ဘယ်လို အပြင်ကို ခွဲထုတ်ရမလဲ? */
  Widget thankCardList(){
    return ListView.separated(
      itemCount: thankNotes.length,
      separatorBuilder: (BuildContext context, int index){
        return Divider(
          height: 20,
        );
      },
      itemBuilder: (BuildContext context, int index){
          int descInt = (thankNotes[index].toMap()['description'].length > 150 ) ? 150 : thankNotes[index].toMap()['description'].length;
          String description = thankNotes[index].toMap()['description'].substring(0,descInt)+ "...";

          int locationInt = (thankNotes[index].toMap()['location'].length > 150 ) ? 150 : thankNotes[index].toMap()['location'].length;
          String location = thankNotes[index].toMap()['location'].substring(0,locationInt) + "...";

          return Card(
            child: ListTile(
              // leading: IconButton(
              //   icon: Icon(Icons.edit,color: Colors.blue,),
              //   onPressed: () async{
              //     print("edit button onPressed");
              //     updateThankNoteRouteResult(context, thankNotes[index]);
              //   },
              // ),
              // leading: Icon(Icons.person,color: Colors.blueAccent,),
              title: Text(thankNotes[index].toMap()['person'], style: ThankTextStyle.textStyleListHeading,),
              subtitle: Text(description + "["+location+"]", style: ThankTextStyle.textStyleListDesc),

              // trailing: IconButton(
              //   onPressed: () async {
              //     print("trailing onPressed");
              //     // Navigator.pop မှာက data pass လုပ်ပေးလို့ရတော့ စောင့်နေလိုက်မယ် :D :D :D
              //     bool comfirm = await showDialog(
              //         context: context,
              //         builder: (_) => comfirmDeleteDialog(),
              //         barrierDismissible: false,
              //     );
              //     print("comfirm is "+comfirm.toString());
              //     if(comfirm){
              //       var thankNote = await thankNoteDb.deleteThankNote(thankNotes[index]);
              //       if(thankNote != null){
              //         setState(() {
              //           // ဖျတ်ပြီးသား note ကို state မှာပါ ဖျတ်မယ်။
              //           thankNotes = thankNotes.where((note) => note.id != thankNote.id).toList();
              //         });
              //         Scaffold.of(context)
              //           ..removeCurrentSnackBar()
              //           ..showSnackBar(SnackBar(content: Text("Delete Success 👍")));
              //       }
              //       else{
              //         Scaffold.of(context)..removeCurrentSnackBar()..showSnackBar(SnackBar(content: Text("Oh dear, let me thanks you first. 🤝")));
              //       }
              //     }
              //     else {
              //       Scaffold.of(context)
              //         ..removeCurrentSnackBar()
              //         ..showSnackBar(SnackBar(content: Text("ကျေးဇူးတရားကို မချေဖျတ်တာ ကောင်းမွန်တဲ့ အလေ့အထဖြစ်ပါတယ်။")));
              //     }
              //   },
              //   icon: Icon(Icons.delete),
              // ),
              onTap: () async{
                print("listTile onTap "+thankNotes[index].toMap()['id'].toString());
                Navigator.pushNamed(context, ThankDetail.routeName,arguments: thankNotes[index]);
              },
            ),
          );
       }, // itemBuilder
    );
  }

  void newThankNoteRouteResult(BuildContext context) async{
    final result = await Navigator.pushNamed(context, ThankForm.routeName);
    print("new thank result is "+result.toString());
    if(result != null){
      thankNotes.insert(0,result);
      setState(() {
        thankNotes = thankNotes;
      });
    }
  }

  void updateThankNoteRouteResult(BuildContext context,ThankNote thankNote) async{
    final result = await Navigator.pushNamed(context, ThankForm.routeName, arguments: thankNote);
    //ThankNote updateResult = await Navigator.pushNamed(context, ThankForm.routeName, arguments: thankNote);
    print("update thank result "+result.toString());
    if(result != null){
      thankNotes = thankNotes.where((note) => note.id != thankNote.id).toList();
      thankNotes.insert(0,result);
      setState(() {
        thankNotes = thankNotes;
        //thankNotes[thankNotes.indexWhere((note) => note.id == result.id)] = result;
      });
    }
  }

  AlertDialog comfirmDeleteDialog(){
    return AlertDialog(
      title: Text("Delete?"),
      content: Text("Are you sure to delete this thank?"),
      actions: [
        TextButton(
            onPressed: (){
              print("comfirmDeleteDialog Yes onPressed");
              Navigator.pop(context,true);
              return true;
            },
            child: Text("Yes")
        ),
        TextButton(
            onPressed: (){
              print("comfirmDeleteDialog No onPressed");
              Navigator.pop(context,false);
            },
            child: Text("No")
        ),
      ],
    );
  }

}
