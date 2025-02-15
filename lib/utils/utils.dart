import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrimony_application/backend/user.dart';
import 'package:matrimony_application/utils/string_constants.dart';


  Widget appBarGradient(List<Color> listofColors){
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: listofColors
          )
      ),
    );
  }

  TextStyle myTextStyle(){
    return const TextStyle(
        fontFamily: RobotoFlex,
        fontSize: 33,
        fontWeight: FontWeight.w600,
        color: Color.fromRGBO(0, 0, 0,0.7),
    );
  }

Future<void> unFavouriteDialog(context,{required Map<String,dynamic> data}) async {
    final User user = User();
  await showDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: const Text("Unfavourite"),
        content: Text(
            "Are you sure want to remove ${data[Name]} from favourite?"),
        actions: [
          TextButton(
            child: const Text("Yes"),
            onPressed: () {
              user.changeFavouriteDatabase(data[UserId], 0)
                  .then((value) => Navigator.pop(context));
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
/*

 */