import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrimony_application/backend/user.dart';
import 'package:matrimony_application/design/add_user/add_edit_user.dart';
import 'package:matrimony_application/design/user_list/user_details.dart';
import 'package:matrimony_application/design/user_list/user_list_page.dart';
import 'package:matrimony_application/utils/string_constants.dart';
import 'package:matrimony_application/utils/utils.dart';

// ignore: must_be_immutable
class SwipeUserDetails extends StatefulWidget {
  Map<String, dynamic> userDetail = {};
  SwipeUserDetails({super.key, required this.userDetail});
  @override
  State<SwipeUserDetails> createState() => _SwipeUserDetailsState();
}

class _SwipeUserDetailsState extends State<SwipeUserDetails> {
  final User _user = User();
  int ind = -1;
  int age = 0;
  @override
  void initState() {
    super.initState();
    // widget.userDetail[Age] = User().ageCalculate(widget.userDetail);
    age = User().ageCalculate(widget.userDetail);
    ind = widget.userDetail[UserId];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],

      appBar: AppBar(
        flexibleSpace: appBarGradient([
          const Color.fromARGB(255, 240, 47, 194),
          const Color.fromARGB(255, 96, 148, 234),
        ]),
        centerTitle: true,
        title: Text(
          "${widget.userDetail[Name]}",
          style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              fontFamily: StyleScript),
        ),
      ),

      body: widget.userDetail.isEmpty
          ? const Text("Some Error Occurred")
          : Stack(
              children: [
                // Main Content
                Image.asset(
                  "assets/images/Holding_Hands.jpg",
                  height: 900,
                  fit: BoxFit.cover,
                  width: 400,
                ),

                // Gesture Detector for Swipe Up
                Align(
                  alignment: Alignment.bottomLeft,
                  child: GestureDetector(
                    onVerticalDragUpdate: (details) {
                      if (details.delta.dy < -10) {
                        // Detect upward swipe
                        _showBottomSheet(context);
                        _user.getByIdDatabase(ind).then((value) {
                          setState(() { widget.userDetail = value; });
                        },);
                      }
                    },
                    child: Container(
                      alignment: Alignment.bottomLeft, // Swipe Area alignment
                      height: 250, // Swipe Area Height
                      color: Colors.transparent,
                      child: Container(
                        width: 700,
                        height: 700,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(50, 100, 100, 94),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: getDetails(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  // Function to show the bottom sheet
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: 700,
          padding: const EdgeInsets.all(16),
          child: UserDetailsPage(userDetail: widget.userDetail),
        );
      },
    );
  }

  // to get user details for this page
  Widget getDetails() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // region Name
          Text(
            widget.userDetail[Name],
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 33,
                color: Color.fromRGBO(0, 0, 0, 0.75),
                fontFamily: RobotoFlex),
          ),
          // endregion Name

          const SizedBox(
            height: 8,
          ),

          // region Age
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.date_range,
                size: 25,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                "$age",
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                    color: Color.fromRGBO(0, 0, 0, 0.6),
                    fontFamily: RobotoFlex),
              ),
            ],
          ),
          // endregion Age

          // region City
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_pin,
                size: 25,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                "${widget.userDetail[City]}",
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                    color: Color.fromRGBO(0, 0, 0, 0.6),
                    fontFamily: RobotoFlex),
              ),
            ],
          ),
          // endregion City

          Expanded(child: Container()),

          getButtons(),
        ],
      ),
    );
  }

  // buttons favourite, delete, edit, info
  Widget getButtons() {
    return Row(
      children: [
        // region favorite
        Expanded(
          child: IconButton(
              padding: const EdgeInsets.all(5),
              onPressed: () {
                if (widget.userDetail[isFavourite] == 0) {
                  _user.changeFavouriteDatabase(widget.userDetail[UserId], 1);
                  setState(() {

                    _user.getByIdDatabase(ind).then((value) {
                      setState(() { widget.userDetail = value; });
                    },);
                  });
                } else {
                  unFavourite(ind);
                }
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
                )).then((value) => _user.getByIdDatabase(ind).then((value) {
                  setState(() {
                    widget.userDetail = value;
                    age = User().ageCalculate(widget.userDetail);
                  });
                },)
                );
              },
              icon: const Icon(
                Icons.edit,
                color: Color.fromARGB(255, 75, 190, 255),
                size: 30,
              )),
        ),
        // endregion Edit

        // region info
        Expanded(
          child: IconButton(
              padding: const EdgeInsets.all(5),
              onPressed: () {
                _showBottomSheet(context);
              },
              icon: const Icon(
                CupertinoIcons.info,
                color: Colors.pink,
                size: 30,
              )),
        ),
        // endregion info
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
              "Are you sure want to remove ${widget.userDetail[Name]} from favourite?"),
          actions: [
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                // _user.changeFavourite(i);
                _user.changeFavouriteDatabase(widget.userDetail[UserId], 0);
                _user.getByIdDatabase(ind).then((value) {
                  setState(() { widget.userDetail = value; });
                },);
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
}
