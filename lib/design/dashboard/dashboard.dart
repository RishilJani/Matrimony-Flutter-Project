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
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              children: [
                myItem('Add User', Icons.add, context, UserForm()),
                myItem('User List', Icons.list_rounded, context, UserListPage(isFav: false,)),
              ],
            ),
            const SizedBox( height: 20, ),
            Row(
              children: [
                myItem('Favourite', CupertinoIcons.heart_fill, context, UserListPage( isFav: true,)),
                myItem('About Us', Icons.person, context, const AboutUs()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget myItem(String txt, IconData icon, [context, my_page]) {
    return Expanded(
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return my_page;
            },
          ));
        },
        child: Card(
            shadowColor: Colors.lightBlue,
            margin: const EdgeInsets.all(20),
            elevation: 10,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                  Icon(
                    icon,
                    size: 35,
                  ),

                Text(
                  txt,
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            )),
      ),
    );
  }
}
