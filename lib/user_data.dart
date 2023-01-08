import 'local_database.dart';

/// model class of the user data

class UserData {
  int? id;
  String? firstName;
  String? lastName;
  String? address;
  int? mobile;
  int? age;

  UserData(this.id, this.firstName, this.lastName, this.address, this.mobile,
      this.age);

  Map<String, dynamic> toMap() {
    return {
      LocalDatabase.columnId: id,
      LocalDatabase.columnFirstName: firstName,
      LocalDatabase.columnLastName: lastName,
      LocalDatabase.columnAddress: address,
      LocalDatabase.columnAge: age,
      LocalDatabase.columnMobile: mobile,
    };
  }

  UserData.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    firstName = map['first_name'];
    lastName = map['last_name'];
    address = map['address'];
    age = map['age'];
    mobile = map['mobile'];
  }
}
