import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_demo/add_edit_user_data.dart';

import 'local_database.dart';
import 'user_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// create list to add the user data
  List<UserData> allUserDataList = [];

  /// instance of the local database
  final localDatabase = LocalDatabase.instance;
  @override
  void initState() {
    super.initState();

    /// to get the user data when page gets loaded if data exist
    initialData();
  }

  initialData() async {
    /// calling function to get user data which is create in local database file
    final allData = await localDatabase.getAllUserData();
    allUserDataList.clear();
    for (var i in allData) {
      /// adding value in the list
      allUserDataList.add(UserData.fromMap(i));
    }

    /// to reload the page
    setState(() {});
  }

  /// to delete the user by id
  _delete(id) async {
    await localDatabase.deleteUserData(id);
    initialData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User list"),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            /// to navigate to the page where user add details
            /// catch the boolean response if data is added
            bool? isAdded = await Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AddEditUserData()));

            /// if data is added calling initialData function again which will reflect the changes rapidly
            if (isAdded == true) {
              initialData();
              setState(() {});
            }
          },
          child: const Icon(Icons.add)),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
          separatorBuilder: (context, index) => const Divider(),
          shrinkWrap: true,
          itemCount: allUserDataList.length,
          itemBuilder: ((context, index) {
            return ListTile(
              onTap: () async {
                /// navigate to edit the data
                /// catching the boolean response for edit
                bool? isUpdated = await Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (_) => AddEditUserData(
                              isEdit: true,
                              userData: allUserDataList[index],
                            )));

                /// if data is updated again calling initialData function
                /// to reflect the changes rapidly
                if (isUpdated == true) {
                  initialData();
                  setState(() {});
                }
              },

              /// displaying first name and last name
              title: Text(
                  "  ${allUserDataList[index].firstName} ${allUserDataList[index].lastName}"),

              /// displaying mobile number and age
              subtitle: Text(
                  "Mobile : ${allUserDataList[index].mobile} Age : ${allUserDataList[index].age}"),

              /// displaying the id
              leading: CircleAvatar(
                child: Text(" ${allUserDataList[index].id}"),
              ),

              /// button to delete the record
              trailing: IconButton(
                  onPressed: () {
                    /// calling delete function which requires id
                    _delete(allUserDataList[index].id);
                  },
                  icon: const Icon(Icons.delete_forever)),
            );
          }),
        ),
      ),
    );
  }
}
