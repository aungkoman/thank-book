import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:thank_book/componets/main-drawer.dart';
import 'package:thank_book/data/notification-class.dart';
import 'package:thank_book/data/thank-constant.dart';
import 'package:thank_book/data/thank-note-db.dart';
import 'package:thank_book/data/thank-note.dart';
import 'package:thank_book/data/thank-search-delicate.dart';

import 'package:thank_book/routes/thank-detail.dart';
import 'package:thank_book/routes/thank-form.dart';

import 'package:thank_book/style/thank-text-style.dart';

class HomePage extends StatefulWidget {
  static String routeName = '/';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AdmobBannerSize bannerSize;
  AdmobInterstitial interstitialAd;
  AdmobReward rewardAd;
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

  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  // AdmobBannerSize bannerSize;
  // AdmobInterstitial interstitialAd;
  // AdmobReward rewardAd;


  bool bannerShow = true;
  int isInitialize = 0;

  @override
  void initState() {
    // TODO: implement initState
    print("HomePage initState");
    super.initState();
    initialize();

    isInitialize++;
    bannerSize = AdmobBannerSize.BANNER;

    interstitialAd = AdmobInterstitial(
      adUnitId: getInterstitialAdUnitId(),
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
        handleEvent(event, args, 'Interstitial');
      },
    );

    rewardAd = AdmobReward(
      adUnitId: getRewardBasedVideoAdUnitId(),
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) rewardAd.load();
        handleEvent(event, args, 'Reward');
      },
    );

    interstitialAd.load();
    rewardAd.load();

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
      key: scaffoldState,
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
      body: Column(children: [
          Expanded(child: thankCardList()),
        Visibility(
          visible: bannerShow,
          child: Container(
            // margin: EdgeInsets.only(bottom: 20.0),
            child: AdmobBanner(
              adUnitId: getBannerAdUnitId(),
              adSize: bannerSize,
              listener: (AdmobAdEvent event,Map<String, dynamic> args) {
                print("listener AdmobAdEvent");
                handleEvent(event, args, 'Banner');
              },
              onBannerCreated:
                  (AdmobBannerController controller) {
                print("onBannerCreated");
                if(isInitialize == 1){
                  isInitialize++;
                  setState(() {
                    bannerShow = false;
                  });
                }

                // Dispose is called automatically for you when Flutter removes the banner from the widget tree.
                // Normally you don't need to worry about disposing this yourself, it's handled.
                // If you need direct access to dispose, this is your guy!
                // controller.dispose();
              },
            ),
          ),
        ),
        ]
      ),
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
                print("int r is "+(isInitialize % 2).toString());
                (isInitialize % 2 == 0 ) ?  showIntersittialAd() : showRewardAd();
                isInitialize++;
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

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        setState(() {
          bannerShow = true;
        });
        print('New Admob $adType Ad loaded!');
        //showSnackBar('New Admob $adType Ad loaded!');
        break;
      case AdmobAdEvent.opened:
        print('Admob $adType Ad opened!');
        //showSnackBar('Admob $adType Ad opened!');
        break;
      case AdmobAdEvent.closed:
        print('Admob $adType Ad closed!');
        //showSnackBar('Admob $adType Ad closed!');
        break;
      case AdmobAdEvent.failedToLoad:
        print('Admob $adType failed to load. :(');
        //showSnackBar('Admob $adType failed to load. :(');
        break;
      case AdmobAdEvent.rewarded:
        print('Admob rewared');
        // showDialog(
        //   context: scaffoldState.currentContext,
        //   builder: (BuildContext context) {
        //     return WillPopScope(
        //       child: AlertDialog(
        //         content: Column(
        //           mainAxisSize: MainAxisSize.min,
        //           children: <Widget>[
        //             Text('Reward callback fired. Thanks Andrew!'),
        //             Text('Type: ${args['type']}'),
        //             Text('Amount: ${args['amount']}'),
        //           ],
        //         ),
        //       ),
        //       onWillPop: () async {
        //         scaffoldState.currentState.hideCurrentSnackBar();
        //         return true;
        //       },
        //     );
        //   },
        // );
        break;
      default:
    }
  }

  void showSnackBar(String content) {
    scaffoldState.currentState.showSnackBar(
      SnackBar(
        content: Text(content),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  String getBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-7499955469448445/8545286423';
    }
    return null;
  }

  String getInterstitialAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-7499955469448445/5685482505';
    }
    return null;
  }

  String getRewardBasedVideoAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/1712485313';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-7499955469448445/5106403168';
    }
    return null;
  }


  Future<void> showIntersittialAd() async{
    if (await interstitialAd.isLoaded) {
      interstitialAd.show();
      //return true;
    } else {
      print('Interstitial ad is still loading...');
      // showSnackBar('Interstitial ad is still loading...');
      // return false;
    }
  }

  Future<void> showRewardAd() async {
    if (await rewardAd.isLoaded) {
      rewardAd.show();
    } else {
      // showSnackBar('Reward ad is still loading...');
      print('Reward ad is still loading...');
    }
  }
}



