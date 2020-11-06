import 'package:flutter/material.dart';
import 'package:thank_book/data/thank-note-db.dart';
import 'package:thank_book/data/thank-note.dart';
import 'package:thank_book/routes/thank-form.dart';

class HomePage extends StatefulWidget {
  static String routeName = '/';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final ThankNoteDb thankNoteDb = ThankNoteDb();
  List<ThankNote> thankNotes = [
    ThankNote(id: 1, person: "person1", description: "description1", location: "NPT"),
    ThankNote(id: 2, person: "person2", description: "description2", location: "YGN")
  ];


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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thank Book'),
      ),
      body: thankCardList(),
      /*
      body: ListView(
        children: [
          ListTile(
            title: Text('Person1'),
            subtitle: Text('Thank description'),
            onTap: (){
              print("listTile onTap");
            },
          ),
          ListTile(
            title: Text('Person1'),
            subtitle: Text('Thank description'),
          )
        ],
      ),

       */
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
          return ListTile(
            leading: Icon(Icons.person,color: Colors.blueAccent,),
            title: Text(thankNotes[index].toMap()['person']),
            subtitle: Text(thankNotes[index].toMap()['description'] + "["+thankNotes[index].toMap()['location']+"]"),

            trailing: IconButton(
              onPressed: (){
                print("trailing onPressed");
              },
              icon: Icon(Icons.double_arrow),
            ),
            onTap: (){
              print("listTile onTap "+thankNotes[index].toMap()['id'].toString());
            },
          );
       }, // itemBuilder
    );
  }

  void newThankNoteRouteResult(BuildContext context) async{
    final result = await Navigator.pushNamed(context, ThankForm.routeName);
    print("result is "+result.toString());
    if(result != null){
      thankNotes.insert(0,result);
      setState(() {
        thankNotes = thankNotes;
      });
    }
  }

}
