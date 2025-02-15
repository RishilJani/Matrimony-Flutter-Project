import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrimony_application/design/user_list/user_list_page.dart';
import 'package:matrimony_application/utils/string_constants.dart';
import 'package:matrimony_application/utils/utils.dart';

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
    ind = widget.userDetail[UserId];
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
                        Expanded(
                          child: Text(
                            widget.userDetail[Name].toString(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 40,
                                fontFamily: "RobotoFlex"),
                          ),
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
          child: Text(
            "$txt ",
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        const Expanded(
            flex: 1,
            child: Text(
              ":",
            )),
        Expanded(
            flex: 3,
            child: Text(
              txt == Age ? "$age" : widget.userDetail[txt].toString(),
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  fontFamily: RobotoFlex),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
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
              onPressed: () async {
                if (widget.userDetail[isFavourite] == 0) {
                  await _user.changeFavouriteDatabase(widget.userDetail[UserId], 1);
                } else {
                  await unFavouriteDialog(context, data: widget.userDetail);
                }
                _user.getByIdDatabase(widget.userDetail[UserId]).then((value) { setState(() { widget.userDetail = value; }); }, );
              },
              icon: Icon(
                widget.userDetail[isFavourite] == 1
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
                deleteDialog();
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
                )).then((value) =>
                    _user.getByIdDatabase(widget.userDetail[UserId]).then(
                      (value) {
                        setState(() {
                          widget.userDetail = value;
                          age = User().ageCalculate(widget.userDetail);
                        });
                      },
                    ));
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

  void deleteDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('DELETE '),
          content:
              Text('Are you sure want to delete ${widget.userDetail[Name]}? '),
          actions: [
            TextButton(
              child: const Text('yes'),
              onPressed: () {
                _user.deleteUserDatabase(widget.userDetail[UserId]);
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
