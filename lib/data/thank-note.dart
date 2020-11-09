class ThankNote {
  int id = null;
  String person,description,location,reminder_date,reminder_time;

  // Constructor
  ThankNote({this.id,this.person,this.description,this.location,this.reminder_date, this.reminder_time});

  Map<String,dynamic> toMap() {
    return {
      'id' : id,
      'person' : person,
      'description' : description,
      'location' : location,
      'reminder_date' : reminder_date,
      'reminder_time' : reminder_time
    };
  }

  @override
  String toString(){
    return 'ThankNote {id : $id , person : $person , description : $description, location : $location, reminder_date: $reminder_date, reminder_time : $reminder_time}';
  }

}