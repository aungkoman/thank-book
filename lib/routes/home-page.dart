import 'package:flutter/material.dart';
import 'package:thank_book/data/thank-note-db.dart';
import 'package:thank_book/data/thank-note.dart';
import 'package:thank_book/routes/about-app.dart';
import 'package:thank_book/routes/thank-form.dart';

class HomePage extends StatefulWidget {
  static String routeName = '/';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final ThankNoteDb thankNoteDb = ThankNoteDb();
  List<ThankNote> thankNotes = [
    ThankNote(id: -1, person: "Thank", description: "Let me thank you for using our app.", location: "MYANMAR"),
    ThankNote(id: -2, person: "How To Use", description: "Just add thankfulness and get remind how beauty our life.", location: "YGN")
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
      drawer: Drawer(
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

          ]
        ),
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
          return Card(
            child: ListTile(
              leading: IconButton(
                icon: Icon(Icons.edit,color: Colors.blue,),
                onPressed: () async{
                  print("edit button onPressed");
                  updateThankNoteRouteResult(context, thankNotes[index]);
                },
              ),
              // leading: Icon(Icons.person,color: Colors.blueAccent,),
              title: Text(thankNotes[index].toMap()['person']),
              subtitle: Text(thankNotes[index].toMap()['description'] + "["+thankNotes[index].toMap()['location']+"]"),

              trailing: IconButton(
                onPressed: () async {
                  print("trailing onPressed");
                  // Navigator.pop မှာက data pass လုပ်ပေးလို့ရတော့ စောင့်နေလိုက်မယ် :D :D :D
                  bool comfirm = await showDialog(
                      context: context,
                      builder: (_) => comfirmDeleteDialog(),
                      barrierDismissible: false,
                  );
                  print("comfirm is "+comfirm.toString());
                  if(comfirm){
                    var thankNote = await thankNoteDb.deleteThankNote(thankNotes[index]);
                    if(thankNote != null){
                      setState(() {
                        thankNotes = thankNotes.where((note) => note.id != thankNote.id).toList();
                      });
                      Scaffold.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(SnackBar(content: Text("Delete Success 👍")));
                    }
                    else{
                      Scaffold.of(context)..removeCurrentSnackBar()..showSnackBar(SnackBar(content: Text("Oh dear, let me thanks you first. 🤝")));
                    }
                  }
                  else {
                    Scaffold.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(SnackBar(content: Text("ကျေးဇူးတရားကို မချေဖျတ်တာ ကောင်းမွန်တဲ့ အလေ့အထဖြစ်ပါတယ်။")));
                  }
                },
                icon: Icon(Icons.delete),
              ),
              onTap: () async{
                print("listTile onTap "+thankNotes[index].toMap()['id'].toString());
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
