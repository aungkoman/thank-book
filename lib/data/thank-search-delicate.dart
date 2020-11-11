import 'package:flutter/material.dart';
import 'package:thank_book/data/thank-note.dart';
import 'package:thank_book/routes/thank-detail.dart';

class ThankSearchDelicate extends SearchDelegate{
  /* SearchDelegate ဆိုတာနဲ့ implement လုပ်ရမယ့် method က လေးခု */
  // buildActions
  // buildLeading
  // buildResults
  // buildSuggestions
  /* ဒီ method တွေ အကုန်လုံးက BuildContext context ထုတ်ပေးပြီး Widget တစ်ခု return ပြန်ပေးတယ် */

  /* မှတ်သားရမယ့် member variable နဲ့ method ကတော့ query နဲ့ showResult() */
  /* showResults(context) လို့ခေါ်လိုက်ရင် buildResult ကို သွားခေါ်တယ် */
  /* query ပြောင်းနေရင်လည်း လုပ်စရာရှိတဲ့အလုပ် သူ့ဘာသာသူ လုပ်နေတဲ့ သဘော */


  /* default အနေနဲ့ appBar က အဖြူရောင် ပြောင်းပြီး searchBar ပေါ်လာတာ
    ကိုယ်က Theme ကို override ပြန်လုပ်ပြီး consistance ui ရအောင် လုပ်လို့ရတယ်

    Customizing the ThemeData of your search page AppBar
   */

  final List<ThankNote> listExample;
  List<ThankNote> recentList;
  ThankSearchDelicate(this.listExample){
     recentList = listExample;
  }


  @override
  // TODO: implement searchFieldLabel
  String get searchFieldLabel => "ရှာဖွေရန်...";

  /*
    parent class ရဲ့ member variable ကို override လုပ်တာမျိုး
    လှတာက လှတယ်။
    getter/ setter လိုမျိုး ဖြစ်မယ်။

    query ကို ကြည့်ကြည့်ရင် set နဲ့ လုပ်ပြထားတာတွေ့တယ်။
  */
  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme;
  }
  
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        //close(context, null);
        Navigator.pop(context);
      },
    );
  }

  String selectedResult = "";
  @override
  Widget buildResults(BuildContext context) {

      /* ဒီနေရာမှာ result ကို ထုတ်ရမှာ */
    /* query ဆိုပြီး ရှာထားတဲ့ keyword ကို ယူလို့ရတယ် */
    /* ထုံးစံအတိုင်း List view နဲ့ပဲ ရှိသလောက် ပြ မရှိရင် no result found ပေါ့ */
    List<ThankNote> resultThankList = listExample.where((note) => note.person.contains(query) || note.description.contains(query) || note.location.contains(query),).toList();
    if(resultThankList.length == 0 ) return Center(child: Text(query + " အတွက် ရှာမတွေ့ပါ"),);
    return ListView.separated(
        itemBuilder: (BuildContext context, int index){
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text(
                resultThankList[index].person,
              ),
              subtitle: Text(
                  resultThankList[index].description + "[ "+resultThankList[index].location+" ]"
              ),
              // leading: query.isEmpty ? Icon(Icons.access_time) : SizedBox(),
              onTap: (){
                selectedResult = resultThankList[index].person;
                // showResults(context);
                Navigator.pop(context);
                Navigator.pushNamed(context, ThankDetail.routeName,arguments: resultThankList[index]);
              },
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index){
          return Divider(
            height: 20,
          );
        },
        itemCount: resultThankList.length
    );
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "buildResult : query "+query.toString()+" , result "+selectedResult,
            ),
          )
        ],
      );
  }


  @override
  Widget buildSuggestions(BuildContext context) {
    List<ThankNote> suggestionList = [];
    query.isEmpty
        ? suggestionList = recentList //In the true case
        : suggestionList.addAll(listExample.where((note) => note.person.contains(query) || note.description.contains(query) || note.location.contains(query),));

    if(suggestionList.length == 0 ) return Center(child: Text('"'+query.toString()+'" ကိုရှာမတွေ့ပါ...'),);


    return ListView.separated(
      itemCount: suggestionList.length,
      separatorBuilder: (BuildContext context, int index){
        return Divider(
          height: 20,
        );
      },
      itemBuilder: (context, index) {

        int descInt = (suggestionList[index].location.length > 150 ) ? 150 : suggestionList[index].description.length;
        String description = suggestionList[index].description.substring(0,descInt)+ "...";

        int locationInt = (suggestionList[index].toMap()['location'].length > 150 ) ? 150 : suggestionList[index].location.length;
        String location = suggestionList[index].toMap()['location'].substring(0,locationInt) + "...";

        return Card(
          margin: EdgeInsets.all(8),
          child: ListTile(
            title: Text(
              suggestionList[index].person,
            ),
            subtitle: Text(
             description + "[ "+location+" ]"
            ),
            // leading: query.isEmpty ? Icon(Icons.access_time) : SizedBox(),
            onTap: (){
              selectedResult = suggestionList[index].person;
              // showResults(context);
              Navigator.pop(context);
              Navigator.pushNamed(context, ThankDetail.routeName,arguments: suggestionList[index]);
            },
          ),

        );
      },
    );

    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.
    // return Column();
  }
}