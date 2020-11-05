class ThankNote {
  int id;
  String person,description,location;

  // Constructor
  ThankNote({this.id,this.person,this.description,this.location});

  Map<String,dynamic> toMap() {
    return {
      'id' : id,
      'person' : person,
      'description' : description,
      'location' : location,
    };
  }

  @override
  String toString(){
    return 'ThankNote {id : $id , person : $person , description : $description, location : $location';
  }

}