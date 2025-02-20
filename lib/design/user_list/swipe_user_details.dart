import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrimony_application/backend/user.dart';
import 'package:matrimony_application/design/add_user/add_edit_user.dart';
import 'package:matrimony_application/design/user_list/user_details.dart';
import 'package:matrimony_application/utils/string_constants.dart';
import 'package:matrimony_application/utils/utils.dart';

// ignore: must_be_immutable
class SwipeUserDetails extends StatefulWidget {
  SwipeUserDetails({super.key, required this.data, required this.currentIndex});
  int currentIndex = 0;
  List<Map<String, dynamic>> data = [];
  @override
  State<SwipeUserDetails> createState() => _SwipeUserDetailsState();
}

class _SwipeUserDetailsState extends State<SwipeUserDetails> {
  final User _user = User();

  int age = 0;

  late PageController _pageController;
  @override
  void initState() {
    super.initState();
    age = _user.ageCalculate(widget.data[widget.currentIndex]);
    _pageController = PageController(initialPage: widget.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                logout(context);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: widget.data.isEmpty
          ? const Text("Some Error Occurred")
          : PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: widget.data.length,
              itemBuilder: (context, index) {
                return displayUser(index);
              },
            ),
    );
  }

  Widget displayUser(int i) {
    age = _user.ageCalculate(widget.data[widget.currentIndex]);
    return Stack(
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
                _showBottomSheet(context, i);
                _user.getByIdDatabase(widget.data[i][UserId]).then(
                  (value) {
                    setState(() {
                      widget.data[i] = value;
                    });
                  },
                );
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
                child: getDetails(i),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Function to show the bottom sheet
  void _showBottomSheet(BuildContext context, int i) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: 700,
          padding: const EdgeInsets.all(16),
          child: UserDetailsPage(userDetail: widget.data[i]),
        );
      },
    ).then(
      (value) {
        _user
            .getByIdDatabase(widget.data[i][UserId])
            .then((value) => setState(() {
                  widget.data[i] = value;
                }));
      },
    );
  }

  // to get user details for this page
  Widget getDetails(int i) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // region Name
          Text(
            widget.data[i][Name],
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
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
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
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
                "${widget.data[i][City]}",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
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

          getButtons(i),
        ],
      ),
    );
  }

  // buttons favourite, delete, edit, info
  Widget getButtons(int i) {
    return Row(
      children: [
        // region favorite
        Expanded(
          child: IconButton(
              padding: const EdgeInsets.all(5),
              onPressed: () {
                if (widget.data[i][isFavourite] == 0) {
                  _user.changeFavouriteDatabase(widget.data[i][UserId], 1);
                  setState(() {
                    _user.getByIdDatabase(widget.data[i][UserId]).then(
                      (value) {
                        setState(() {
                          widget.data[i] = value;
                        });
                      },
                    );
                  });
                } else {
                  unFavouriteDialog(
                      context: context, id: widget.data[i][UserId]);
                }
              },
              icon: Icon(
                widget.data[i][isFavourite] == 1
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
                deleteDialog(i: widget.data[i][UserId], context: context);
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
                size: 30,
              )
          ),
        ),
        // endregion Delete

        // region Edit
        Expanded(
          child: IconButton(
              padding: const EdgeInsets.all(5),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return UserForm(userDetail: widget.data[i]);
                  },
                )).then((value) =>
                    _user.getByIdDatabase(widget.data[i][UserId]).then(
                      (value) {
                        setState(() {
                          widget.data[i] = value;
                          age = User().ageCalculate(widget.data[i]);
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

        // region info
        Expanded(
          child: IconButton(
              padding: const EdgeInsets.all(5),
              onPressed: () {
                _showBottomSheet(context, i);
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

}
