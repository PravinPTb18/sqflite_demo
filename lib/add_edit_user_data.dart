import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:sqflite_demo/user_data.dart';
import 'local_database.dart';

class AddEditUserData extends StatefulWidget {
  /// constructor to get boolean response
  final bool? isEdit;

  /// constructor to get user data object
  final UserData? userData;
  const AddEditUserData({super.key, this.isEdit = false, this.userData});

  @override
  State<AddEditUserData> createState() => _AddEditUserDataState();
}

class _AddEditUserDataState extends State<AddEditUserData> {
  /// creating controllers for all text editing controller
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  /// creating instance of the local database
  final localDatabase = LocalDatabase.instance;

  /// insert function to add user data
  _insert(firstName, lastName, address, age, mobile) async {
    Map<String, dynamic> row = {
      LocalDatabase.columnFirstName: firstName,
      LocalDatabase.columnLastName: lastName,
      LocalDatabase.columnAddress: address,
      LocalDatabase.columnAge: age,
      LocalDatabase.columnMobile: mobile
    };
    UserData userData = UserData.fromMap(row);
    await localDatabase.insertUserData(userData);
    Navigator.pop(context, true);
    setState(() {});
  }

  /// to update the existing user data
  _update(id, firstName, lastName, address, mobile, age) async {
    UserData userData = UserData(id, firstName, lastName, address, mobile, age);
    await localDatabase.updateUserData(userData);
    Navigator.pop(context, true);
  }

  @override
  void initState() {
    super.initState();

    /// checking isEdit boolean value
    widget.isEdit == true ? setPrefilledData() : null;
  }

  /// to prefill the text editing controller value id isEdit id true
  setPrefilledData() {
    firstNameController.text = widget.userData!.firstName!;
    lastNameController.text = widget.userData!.lastName!;
    mobileController.text = widget.userData!.mobile.toString();
    addressController.text = widget.userData!.address!;
    ageController.text = widget.userData!.age.toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isEdit == true ? "Edit user data" : "Add user data "),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextField(
                controller: firstNameController,
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                    label: const Text("First name"),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.green)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.green))),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextField(
                controller: lastNameController,
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                    label: const Text("Last name"),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.green)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.green))),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextField(
                controller: addressController,
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                    label: const Text("Address"),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.green)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.green))),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.65,
                  child: TextField(
                    controller: mobileController,
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.top,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        label: const Text("Mobile number"),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(color: Colors.green)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(color: Colors.green))),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.15,
                  child: TextField(
                    controller: ageController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                        label: const Text("Age"),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(color: Colors.green)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(color: Colors.green))),
                  ),
                ),
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  String firstName = firstNameController.text;
                  String lastName = lastNameController.text;
                  String address = addressController.text;
                  int age = int.parse(ageController.text);
                  int mobile = int.parse(mobileController.text);

                  /// calling function to update and insert the data
                  widget.isEdit == true
                      ? _update(widget.userData!.id, firstName, lastName,
                          address, mobile, age)
                      : _insert(firstName, lastName, address, age, mobile);
                },
                child: Text(widget.isEdit == true
                    ? "Edit user data"
                    : "Save user data")),
          ],
        ),
      ),
    );
  }
}
