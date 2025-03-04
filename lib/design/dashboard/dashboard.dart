import 'package:flutter/material.dart';
import 'package:matrimony_application/design/about_us/about_us.dart';
import 'package:matrimony_application/design/add_user/add_edit_user.dart';
import 'package:matrimony_application/design/user_list/user_list_page.dart';
import 'package:matrimony_application/utils/string_constants.dart';
import 'package:matrimony_application/utils/utils.dart';

//ignore: must_be_immutable
class Dashboard extends StatefulWidget {
  String name = "";
  Dashboard({super.key, required this.name});

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
        flexibleSpace: appBarBG(),
        centerTitle: true,
        title: Text(
          'LoveSync',
          style: TextStyle(
              fontSize: 50,
              color: Colors.pink.shade300,
              fontWeight: FontWeight.bold,
              fontFamily: StyleScript),
        ),
        actions: [
          IconButton(
              onPressed: () {
                logout(context);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Column(
              children: [
                Text(
                  "Hii, ${widget.name}",
                  style: const TextStyle(
                      fontSize: 30,
                      fontFamily: RobotoFlex,
                      fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Welcome to LoveSync",
                  style: TextStyle(
                    fontSize: 23,
                    fontFamily: RobotoFlex,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                myItem('Add User', Icons.add,
                    context: context, myPage: UserForm()),
                myItem('User List', Icons.list_rounded,
                    context: context,
                    myPage: UserListPage(
                      isFav: false,
                    )),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                myItem('Favourite', Icons.favorite,
                    context: context,
                    myPage: UserListPage(
                      isFav: true,
                    )),
                myItem('About Us', Icons.person,
                    context: context, myPage: const AboutUs()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget myItem(String txt, IconData icon, {context, myPage}) {
    double borderRadius = 80;
    Color color = Colors.white;
    return Expanded(
      child: InkWell(
        highlightColor: Colors.pink.shade50,
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return myPage;
            },
          ));
        },
        child: Container(
          width: 200,
          height: 150,
          margin: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.pinkAccent,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: color,
              ),
              Text(
                txt,
                style: TextStyle(
                    fontFamily: RobotoFlex, fontSize: 20, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
