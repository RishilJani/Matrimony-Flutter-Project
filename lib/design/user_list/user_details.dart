import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrimony_application/design/user_list/user_list_page.dart';
import 'package:matrimony_application/utils/string_constants.dart';

import '../../backend/user.dart';
import '../add_user/add_edit_user.dart';

// ignore: must_be_immutable
class UserDetailsPage extends StatefulWidget {
  UserDetailsPage({super.key, required this.userDetail});
  Map<String, dynamic> userDetail = {};

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final User _user = User();
  int ind = 0;
  int age = 0;
  @override
  void initState() {
    age = _user.ageCalculate(widget.userDetail);
    widget.userDetail[Age] = age;
    ind = _user.getAll().indexOf(widget.userDetail);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.userDetail.isNotEmpty
          ? SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.userDetail[Name].toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 40,
                              fontFamily: "RobotoFlex"),
                        )
                      ],
                    ),
                    const Text(
                      "About",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    userItem(Gender),
                    const SizedBox(
                      height: 8,
                    ),

                    userItem(City),
                    const SizedBox(
                      height: 8,
                    ),

                    const Text(
                      "Personal Information",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    userItem(DOB),
                    const SizedBox(
                      height: 8,
                    ),

                    userItem(Age),
                    const SizedBox(
                      height: 8,
                    ),

                    //  hobbies
                    Row(
                      children: [
                        const Expanded(flex: 1, child: Text("Hobbies ")),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                Text(
                                  getHobbies(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),

                    const Text(
                      "Contact",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    userItem(Email),
                    const SizedBox(
                      height: 8,
                    ),

                    userItem(Mobile),
                    const SizedBox(
                      height: 8,
                    ),

                    Wrap(
                      direction: Axis.horizontal,
                      children: [
                        getButtons(),
                      ],
                    )
                  ],
                ),
              ),
            )
          : const Text("Some Error Occurred"),
    );
  }

  Widget userItem(String txt) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text("$txt "),
        ),
        const Expanded(
            flex: 1,
            child: Text(
              ":",
            )),
        Expanded(
            flex: 3,
            child: Text(
              widget.userDetail[txt].toString(),
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  fontFamily: RobotoFlex),
            )),
      ],
    );
  }

  Widget getButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // region favorite
        Expanded(
          child: IconButton(
              padding: const EdgeInsets.all(5),
              onPressed: () {
                if (!widget.userDetail[isFavourite]) {
                  _user.changeFavourite(ind);
                  setState(() {
                    widget.userDetail = _user.getById(ind);
                  });
                } else {
                  unFavourite(ind);
                }
              },
              icon: Icon(
                widget.userDetail[isFavourite]
                    ? CupertinoIcons.heart_solid
                    : CupertinoIcons.heart,
                color: Colors.pink,
                size: 30,
              )),
        ),
        // endregion favorite

        // region Delete
        Expanded(
          child: IconButton(
              padding: const EdgeInsets.all(5),
              onPressed: () {
                deleteDialog(ind);
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
                size: 30,
              )),
        ),
        // endregion Delete

        // region Edit
        Expanded(
          child: IconButton(
              padding: const EdgeInsets.all(5),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return UserForm(userDetail: widget.userDetail);
                  },
                )).then((value) => setState(() {
                      widget.userDetail = _user.getById(ind);
                    }));
              },
              icon: const Icon(
                Icons.edit,
                color: Color.fromARGB(255, 75, 190, 255),
                size: 30,
              )),
        ),
        // endregion Edit
      ],
    );
  }

  void unFavourite(int i) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text("Unfavourite"),
          content: Text(
              "Are you sure want to remove ${_user.getById(i)[Name]} from favourite?"),
          actions: [
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                _user.changeFavourite(i);
                setState(() {
                  widget.userDetail = _user.getById(ind);
                });
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void deleteDialog(int i) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('DELETE '),
          content:
              Text('Are you sure want to delete ${_user.getById(i)[Name]}? '),
          actions: [
            TextButton(
              child: const Text('yes'),
              onPressed: () {
                _user.deleteUser(i);
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) {
                    return UserListPage(isFav: false);
                  },
                ));
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  // int findIndex(item) {
  //   List<Map<String, dynamic>> tempData = _user.getAll();
  //   int ans = 0;
  //   for (int i = 0; i < tempData.length; i++) {
  //     if (tempData[i][Name] == item[Name] && tempData[i][Email] == item[Email]) {
  //       ans = i;
  //       break;
  //     }
  //   }
  //   return ans;
  // }

  String getHobbies() {
    String hobbies = "";
    for (var i in widget.userDetail[Hobbies].keys) {
      if (widget.userDetail[Hobbies][i] == true) {
        hobbies += i + " , ";
      }
    }
    hobbies = hobbies.substring(0, hobbies.length - 2);
    return hobbies;
  }
}
