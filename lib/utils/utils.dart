import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrimony_application/backend/user.dart';
import 'package:matrimony_application/design/dashboard/splash_screen.dart';
import 'package:matrimony_application/utils/string_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

final User user = User();

  Widget appBarGradient(){
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 245, 212, 94),
                Color.fromARGB(255, 238, 158, 98),
              ]
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


Future<void> unFavouriteDialog({required context,required int id}) async {
    Map<String,dynamic> tempUser = await user.getByIdDatabase(id);
  await showDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: const Text("Unfavourite"),
        content: Text(
            "Are you sure want to remove ${tempUser[Name]} from favourite?"),
        actions: [
          TextButton(
            child: const Text("Yes"),
            onPressed: () {
              user.changeFavouriteDatabase(id, 0)
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


void deleteDialog({required int i ,required context}) async {
  Map<String, dynamic> tempUser = await user.getByIdDatabase(i);

  await showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text(
            'DELETE ',
            style: TextStyle(fontFamily: RobotoFlex),
          ),
          content: Text(
            'Are you sure want to delete ${tempUser[Name]}? ',
            style: const TextStyle(fontFamily: RobotoFlex),
          ),
          actions: [
            TextButton(
              child: const Text(
                'Yes',
                style: TextStyle(fontFamily: RobotoFlex),
              ),
              onPressed: () {
                user.deleteUserDatabase(tempUser[UserId]);
                Navigator.pop(context);
                },
            ),
            TextButton(
              child: const Text(
                'No',
                style: TextStyle(fontFamily: RobotoFlex),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );

}

void logout(context){
  showDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title:  const Text(
          'Log out ',
          style: TextStyle(fontFamily: RobotoFlex),
        ),
        content: const Text("Are you sure want to log out ?"),
        actions: [
          TextButton(
            onPressed: () async{
              SharedPreferences pref = await SharedPreferences.getInstance();
              pref.setBool(rememberMe, false);

              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const SplashScreen();
                  },));
            },
            child: const Text("Yes"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No"),
          )
        ],
      );
    },
  );
}