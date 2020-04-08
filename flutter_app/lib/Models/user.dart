class User {
  String id;
  String firstName;
  String secondName;
  String mobileNumber;
  String password;
  User(this.id, this.firstName, this.secondName, this.mobileNumber,
      this.password);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(json['id'], json['firstName'], json['secondName'],
        json['mobileNumber'], json['password']);
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'secondName': secondName,
        'mobileNumber': mobileNumber,
        'password': password
      };
}
