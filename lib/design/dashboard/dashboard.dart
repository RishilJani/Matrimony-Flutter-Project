import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrimony_application/design/about_us/about_us.dart';
import 'package:matrimony_application/design/add_user/add_edit_user.dart';
import 'package:matrimony_application/design/user_list/user_list_page.dart';
import 'package:matrimony_application/utils/string_constants.dart';
import 'package:matrimony_application/utils/utils.dart';

//ignore: must_be_immutable
class Dashboard extends StatefulWidget {
  String name = "";
  Dashboard({super.key,required this.name});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Colors.transparent,
        flexibleSpace: appBarGradient(),
        centerTitle: true,
        title: const Text(
          'LoveSync',
          style: TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.bold,
              fontFamily: StyleScript
          ),
        ),

        actions: [
          IconButton(onPressed: (){
            logout(context);
          }, icon: const Icon(Icons.logout)
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
              Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hii, ${widget.name}",
                  style: const TextStyle(
                    fontSize: 30,
                    fontFamily: RobotoFlex,
                    fontWeight: FontWeight.w600
                  ),
                ),
                const Text(
                  "Welcome to LoveSync",
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: RobotoFlex,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ],
            ),

            const SizedBox( height: 20, ),
            Row(
              children: [
                myItem('Add User', Icons.add, context: context,myPage:  UserForm()),
                myItem('User List', Icons.list_rounded, context:  context, myPage:  UserListPage(isFav: false,)),
              ],
            ),
            const SizedBox( height: 20, ),
            Row(
              children: [
                myItem('Favourite', CupertinoIcons.heart_fill, context:  context,myPage:  UserListPage( isFav: true,)),
                myItem('About Us', Icons.person, context:  context, myPage:  const AboutUs()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget myItem(String txt, IconData icon,{context, myPage}) {
    double borderRadius = 75;
    Color? fontColor;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return myPage;
            },
          ));
        },
        child: ShaderMask(
          shaderCallback: (bounds) {
            return const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 105, 241, 250),
                Color.fromARGB(255, 128, 146, 255),
              ],
            ).createShader(bounds);
          },
          child: Container(
            width: 200,
            height: 150,
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 5
              ),
              borderRadius: BorderRadius.circular(borderRadius),
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
                      fontFamily: RobotoFlex,
                      fontSize: 20
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}