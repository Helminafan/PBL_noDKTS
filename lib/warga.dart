class ContactModel {
  String name;
  String number;
  String email;

  var id;

  ContactModel({this.name = "", this.number = "", this.email = "", required int id});
}
