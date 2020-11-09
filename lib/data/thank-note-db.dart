
import 'package:flutter/widgets.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:thank_book/data/thank-note.dart';

class ThankNoteDb{

  final String databaseName = "thank_note_database.db";
  final String tableName = 'thank_note';
  /*
    @id : INT PRIMARY KEY
    @person : TEXT
    @description : TEXT
    @location : TEXT
  */
// Open the database and store the reference.
  //Future<Database> database; // Future ဆိုတဲ့အတိုင်းပဲ ဒါက ဘာမှ စောင့်နေမှာ မဟုတ်ဘူး sync ပုံစံအတိုင်းလုပ်သွားမှာ။
  ThankNoteDb(){
    print("ThankNoteDb constructor");
    initialize();
  }

  void initialize() async{
    print("ThankNoteDb initialize");
  }

  // return database instance
  Future<Database> database() async {
    return openDatabase(
        join(await getDatabasesPath(),databaseName), // ဆိုရရင် url ပါပဲကွာ
        // ဒါက database migration အတွက်၊ အောက်က Version ကိုကြည့်လို့ နဂိုဟာနဲ့ မတူတော့ဘူး ဆိုရင် onCreate ထဲကအတိုင်း migrate လုပ်သွားမယ် :D
        onCreate: (db, version) async{
          return await db.execute(
            "CREATE TABLE $tableName (id INTEGER PRIMARY KEY, person TEXT, description TEXT, location TEXT, reminder_date TEXT, reminder_time TEXT)",
          );
        },
        onUpgrade: (Database db,int oldVersion,int newVersion) async {
          await db.execute("DROP TABLE $tableName");
          return await db.execute(
            "CREATE TABLE $tableName (id INTEGER PRIMARY KEY, person TEXT, description TEXT, location TEXT, reminder_date TEXT, reminder_time TEXT)",
          );
        },
        version: 4
    );
  }

  Future<ThankNote> insertThankNote(ThankNote thankNote) async{
    final Database db = await database(); // အခုမှ instance ရအောင် လုပ်မှာ :D အဲ့သလိုမျိုးလား နမူနာမှာက function တစ်ခုကို လုပ်ပြထားတာဆိုတော့ကာ
    int insertedId = await db.insert(
        tableName, // table name
        thankNote.toMap(), // map နဲ့ လက်ခံတယ် ဆိုလိုချင်တာက key : value pair တွေ ပဲ ထည့်ပေးရမယ်။ အခု case မှာတော့ class ကို map ပြောင်းပေးထားတယ်
        conflictAlgorithm:  ConflictAlgorithm.replace // ထည့်ရမလား ထုတ်ရမလား ပဋိပက္ခတွေ ဖြစ်ရင် ဘယ်လိုလုပ်ကြမလဲ? အစားသာ ထိုးလိုက်ပါ
    );
    thankNote.id = insertedId; // modify class member
    print("insertThankNote insertedId is "+insertedId.toString() +" : "+thankNote.toString());
    return thankNote;
    // TDL
    /* အမှန်ကတော့ ဒီနေရာမှာ try catch နဲ့ error handling လုပ်ပြီး Future မှာ တကယ့် data ရလာဉီးမှာလား ၊ မရနိုင်တော့ဘူးလား ဆုံးဖြတ်ပေးရမယ်။ */
  }

  /* ဒီကောင်တွေ အကုန်လုံးက asynchronous operation တွေချည်းပဲ။ call back hell ကနေလွတ်ဖို့ await သုံးပြီး synchronous ပုံစံ ရအောင် ပြန်ရေးထားကြတာ */
  Future<List<ThankNote>> selectThankNote() async {
    final Database db = await database();
    final List<Map<String, dynamic>> thankNotes = await db.query('thank_note'); // select * from table ဖြစ်မှာပေါ့, result ကို တစ်ခုခုနဲ့ စောင့်ရမယ်, ဘာတွေ ပြန်လာမယ် ထင်လည်း Map List ပဲ နေမှာပေါ့
    /*ဒါတွေက မှတ်ရမယ့် ရေးထုံးတွေ ကိုယ့်အသိနဲ့သာဆိုရင် အပေါ်က ရလာတဲ့ thankNOtes ကို loop ပတ်ပြီး နောက်ထပ် List တစ်ခုမှာ add မယ်၊ ပြီးမှ return ပြန်မယ်ပေါ့ */
    /* အခုကတော့ code က တော်တော်ကို ရှင်းသွားတာ */
    return List.generate(thankNotes.length,(i){
      return ThankNote(
        id : thankNotes[i]['id'],
        person: thankNotes[i]['person'],
        description: thankNotes[i]['description'],
          location: thankNotes[i]['location'],
          reminder_date: thankNotes[i]['reminder_date'],
          reminder_time: thankNotes[i]['reminder_time']
      );
    });
  }

  Future<ThankNote> updateThankNote(ThankNote thankNote) async {
    print("updateThankNote");
    final Database db = await database();
    int effectedRowCount  = await db.update(
      tableName, // table name
      thankNote.toMap(), // Map , key : value => column : value
      where: "id = ?", // where condition
      whereArgs: [thankNote.id], // where arguments
    );
    print("updateThankNote effectedRowCount "+effectedRowCount.toString());
    if(effectedRowCount == 0 ) {
      return null;
    }
    else return thankNote;
  }

  Future<ThankNote> deleteThankNote(ThankNote thankNote) async {
    print("deleteThankNote");
    final Database db = await database();
    int effectedRowCount = await db.delete(
      tableName,
      where: "id = ?",
      whereArgs: [thankNote.id]
    );
    print("deleteThankNote effectedRowCount "+effectedRowCount.toString());
    if(effectedRowCount == 0 ){
      return null;
    }
    else {
      return thankNote;
    }
  }

  // Future<void> insertDog(Dog dog) async {
  //   // Get a reference to the database.
  //   final Database db = await database;
  //
  //   // Insert the Dog into the correct table. Also specify the
  //   // `conflictAlgorithm`. In this case, if the same dog is inserted
  //   // multiple times, it replaces the previous data.
  //   await db.insert(
  //     'dogs',
  //     dog.toMap(),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  // }
  //
  // Future<List<Dog>> dogs() async {
  //   // Get a reference to the database.
  //   final Database db = await database;
  //
  //   // Query the table for all The Dogs.
  //   final List<Map<String, dynamic>> maps = await db.query('dogs');
  //
  //   // Convert the List<Map<String, dynamic> into a List<Dog>.
  //   return List.generate(maps.length, (i) {
  //     return Dog(
  //       id: maps[i]['id'],
  //       name: maps[i]['name'],
  //       age: maps[i]['age'],
  //     );
  //   });
  // }
  //
  // Future<void> updateDog(Dog dog) async {
  //   // Get a reference to the database.
  //   final db = await database;
  //
  //   // Update the given Dog.
  //   await db.update(
  //     'dogs',
  //     dog.toMap(),
  //     // Ensure that the Dog has a matching id.
  //     where: "id = ?",
  //     // Pass the Dog's id as a whereArg to prevent SQL injection.
  //     whereArgs: [dog.id],
  //   );
  // }
  //
  // Future<void> deleteDog(int id) async {
  //   // Get a reference to the database.
  //   final db = await database;
  //
  //   // Remove the Dog from the database.
  //   await db.delete(
  //     'dogs',
  //     // Use a `where` clause to delete a specific dog.
  //     where: "id = ?",
  //     // Pass the Dog's id as a whereArg to prevent SQL injection.
  //     whereArgs: [id],
  //   );
  // }
}
