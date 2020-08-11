class Player {

  String id;
  String name;
  String email;

  Player.fromMap(Map map){
    name = map["name"];
    email = map["email"];
  }

  @override
  String toString() {
    // TODO: implement toString
    return "${name} - ${email} - ${id}";
  }

}