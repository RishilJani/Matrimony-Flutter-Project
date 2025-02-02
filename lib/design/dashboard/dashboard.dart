import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrimony_application/design/about_us/about_us.dart';
import 'package:matrimony_application/design/add_user/add_edit_user.dart';
import 'package:matrimony_application/design/user_list/user_list_page.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        centerTitle: true,
        title: const Text(
          'Matrimony',
          style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              fontFamily: 'StyleScript'
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              children: [
                myItem('Add User', Icons.add, context: context,myPage:  UserForm(),fontColor: Colors.black),
                myItem('User List', Icons.list_rounded, context:  context, myPage:  UserListPage(isFav: false,),fontColor: Colors.black),
              ],
            ),
            const SizedBox( height: 20, ),
            Row(
              children: [
                myItem('Favourite', CupertinoIcons.heart_fill, context:  context,myPage:  UserListPage( isFav: true,),fontColor: Colors.black),
                myItem('About Us', Icons.person, context:  context, myPage:  const AboutUs(),fontColor: Colors.black),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget myItem(String txt, IconData icon,{context, myPage,Color? fontColor}) {
    return Expanded(
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return myPage;
            },
          ));
        },
        child: SizedBox(
          height: 200,
          child: Card(
              shadowColor: fontColor,
              margin: const EdgeInsets.all(20),
              elevation: 30,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(255,23 , 234, 247),
                        Color.fromARGB(255, 96, 120, 234),
                      ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                        icon,
                        size: 35,
                        color: fontColor,
                      ),

                    Text(
                      txt,
                      style: TextStyle(
                          color: fontColor,
                          fontFamily: 'RobotoFlex',
                          fontSize: 20
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}


// region Redial
// RadialGradient(
// colors: [Colors.pinkAccent,Colors.blueAccent,Colors.blueGrey],
// focalRadius: 1,
// center: Alignment.center,
// radius: 0.5
// )
// endregion Redial
