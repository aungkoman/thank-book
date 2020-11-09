import 'package:flutter/material.dart';

class NotificationReceiver extends StatefulWidget {
  final String payload;
  //const NotificationReceiver(this.payload,{Key key,}) : super(key: key);

  /* constructor, ဒီ class တွေက StatefulWidget class ကို extends လုပ်ထားကြတာဆိုတော့ သူ့ရဲ့ မူလ constructor ကိုလည်း ပြန်ခေါ်ပေးဖို့လိုတယ်
    ကိုယ်မခေါ်လည်း သူတို့က အော်တိုခေါ်ကြမှာပါပဲ။
   */
  NotificationReceiver(this.payload,{Key key}) : super(key: key){
    print("NotificationReceiver constructor");
  }

  //const NotificationReceiver(this.payload, {Key key,}) : super(key: key);

  @override
  _NotificationReceiverState createState() => _NotificationReceiverState();
}

class _NotificationReceiverState extends State<NotificationReceiver> {
  String _payload;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _payload = widget.payload;
    /* သူ extend လုပ်ထားတဲ့ parent class ထဲက data ကို ဝင်ယူတာ */
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification Receiver"),
      ),
      body: Center(
        child: Text("Notificaiton Payload is "+_payload),
      ),

    );
  }
}
