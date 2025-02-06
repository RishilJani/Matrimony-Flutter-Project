import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrimony_application/backend/user.dart';
import 'package:matrimony_application/design/user_list/user_details.dart';
import 'package:matrimony_application/utils/string_constants.dart';

// ignore: must_be_immutable
class SwipeUpBottomSheet extends StatefulWidget {
  Map<String,dynamic> userDetail = {};
  SwipeUpBottomSheet({super.key,required
  this.userDetail});
  @override
  State<SwipeUpBottomSheet> createState() => _SwipeUpBottomSheetState();
}

class _SwipeUpBottomSheetState extends State<SwipeUpBottomSheet> {

  @override
  void initState() {
    super.initState();
    widget.userDetail[Age] = User().ageCalculate(widget.userDetail);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        centerTitle: true,
          title: Text("${widget.userDetail[Name]}",
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              fontFamily: StyleScript
          ),)
      ),

      body: Stack(
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
                if (details.delta.dy < -10) { // Detect upward swipe
                  _showBottomSheet(context);
                }
              },

              child: Container(
                alignment: Alignment.bottomLeft,
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
        height: 600,
        padding: const EdgeInsets.all(16),
        child: UserDetailsPage(userDetail: widget.userDetail),
      );
      },
    );
  }


  Widget getDetails(){
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
                color: Color.fromRGBO(0, 0, 0,0.75),
                fontFamily: RobotoFlex
            ),
          ),
          // endregion Name

          const SizedBox(height: 8,),

          // region Age
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.date_range,size: 25,),
              const SizedBox(width: 8,),
              Text(
                "${widget.userDetail[Age]}",
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                    color: Color.fromRGBO(0, 0, 0,0.6),
                    fontFamily: RobotoFlex
                ),
              ),
            ],
          ),
          // endregion Age

          // region City
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.location_pin,size: 25,),
              const SizedBox(width: 8,),
              Text(
                "${widget.userDetail[City]}",
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                    color: Color.fromRGBO(0, 0, 0,0.6),
                    fontFamily: RobotoFlex
                ),
              ),
            ],
          ),
          // endregion City

          // region Buttons
          Row(
            children: [
              // region favorite
              Expanded(
                child: IconButton(
                  padding: const EdgeInsets.all(5),
                    onPressed: (){},
                    icon: Icon(widget.userDetail[isFavourite]
                        ? CupertinoIcons.heart_solid
                        : CupertinoIcons.heart ,
                        color: Colors.pink,
                        size: 30,)
                ),
              ),
              // endregion favorite
              
              // region info
              Expanded(
                child: IconButton(
                    padding: const EdgeInsets.all(5),
                    onPressed: (){},
                    icon: const Icon(CupertinoIcons.info ,
                      color: Colors.pink,
                      size: 30,)
                ),
              ),
              // endregion info

              // region info
              Expanded(
                child: IconButton(
                    padding: const EdgeInsets.all(5),
                    onPressed: (){},
                    icon: const Icon(CupertinoIcons.info ,
                      color: Colors.pink,
                      size: 30,)
                ),
              ),
              // endregion info
            ],
          ),
          // endregion Buttons

        ],
      ),
    );
  }

}