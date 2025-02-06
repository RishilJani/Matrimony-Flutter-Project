import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrimony_application/design/user_list/user_list_page.dart';
import 'package:matrimony_application/utils/string_constants.dart';

import '../../backend/user.dart';
import '../../utils/utils.dart';
import '../add_user/add_edit_user.dart';

// ignore: must_be_immutable
class UserDetailsPage extends StatefulWidget {
  UserDetailsPage({super.key,required this.userDetail});
  Map<String,dynamic> userDetail = {};

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
    widget.userDetail[Age] = age;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   flexibleSpace: appBarGredient([
      //     const Color.fromARGB(255, 240, 47, 194),
      //     const Color.fromARGB(255, 96, 148, 234),
      //   ]),
      //   centerTitle: true,
      //   title: const Text(
      //       'User details',
      //       style: TextStyle(
      //         fontSize: 40,
      //         fontWeight: FontWeight.bold,
      //         fontFamily: 'GreatVibes'
      //     ),
      //   ),
      //
      //   actions: [
      //     // Favourite
      //     IconButton(
      //         icon: Icon(widget.userDetail[isFavourite] ? Icons.favorite : Icons.favorite_border,color: Colors.pink,),
      //         onPressed: (){
      //           ind = findIndex(widget.userDetail);
      //           if(!widget.userDetail[isFavourite]){
      //             _user.changeFavourite(ind);
      //             setState(() { widget.userDetail = _user.getById(ind); });
      //           }else{
      //             unFavourite(ind);
      //           }
      //         }
      //     ),
      //
      //     // delete
      //     IconButton(
      //         icon: const Icon(Icons.delete,color: Colors.red,),
      //         onPressed: (){
      //           ind = findIndex(widget.userDetail);
      //           deleteDialog(ind);
      //         }
      //     ),
      //
      //     // Edit
      //     IconButton(
      //       icon: const Icon(Icons.edit,color: Colors.blueGrey,),
      //       onPressed: (){
      //         Navigator.push(context,
      //             MaterialPageRoute(
      //               builder: (context) {
      //                 ind = findIndex(widget.userDetail);
      //                 return UserForm(userDetail: widget.userDetail,ind : ind);
      //               },
      //             )
      //         ).then((value)=> setState(() {
      //           if(value != null){
      //             widget.userDetail = value;
      //           }
      //         }));
      //       },
      //     ),
      //
      //     const SizedBox(width: 8,)
      //   ],
      // ),
      //

      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.userDetail[Name].toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 40,
                        fontFamily: "RobotoFlex"
                    ),
                  )
                ],
              ),
              const Text("About",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
              const SizedBox( height: 10,),

              // userItem(Name),
              // const SizedBox( height: 8,),

              userItem(Gender),
              const SizedBox( height: 8,),

              userItem(City),
              const SizedBox( height: 8,),

              const Text("Personal Information",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              const SizedBox( height: 10,),

              userItem(DOB),
              const SizedBox( height: 8,),

              userItem(Age),
              const SizedBox( height: 8,),

              //  hobbies
              Row(
                children: [
                  const Expanded(flex: 1, child: Text("Hobbies ")),
                  const Expanded(flex:1,child: Text(":")),
                  Expanded(flex: 3,
                      child: Row(
                        children: [ Text(getHobbies(),style: const TextStyle(fontWeight: FontWeight.w600),) ],
                      )
                  )
                ],
              ),
              const SizedBox( height: 8,),

              const Text("Contact",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              const SizedBox( height: 10,),

              userItem(Email),
              const SizedBox( height: 8,),

              userItem(Mobile),
              const SizedBox( height: 8,),

            ],
          ),
        ),
      )
    );
  }

  Widget userItem(String txt){
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text("$txt "),
        ),
        const Expanded(
            flex: 1,
            child: Text(":",)
        ),
        Expanded(
            flex: 3,
            child: Text(
              widget.userDetail[txt].toString(),
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                fontFamily: RobotoFlex
              ),
            )
        ),
      ],
    );
  }



  void unFavourite(int i){
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text("Unfavourite"),
          content: Text("Are you sure want to remove ${_user.getById(i)[Name]} from favourite?"),
          actions: [
            TextButton(
              child: const Text("Yes"),
              onPressed: (){
                _user.changeFavourite(i);
                setState(() { widget.userDetail = _user.getById(ind); });
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text("No"),
              onPressed: (){
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void deleteDialog(int i){
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title:const Text('DELETE '),
          content: Text('Are you sure want to delete ${_user.getById(i)[Name]}? '),
          actions: [
            TextButton(
              child: const Text('yes'),
              onPressed: () {
                _user.deleteUser(i);
                Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) {
                      return UserListPage(isFav: false);
                    },
                )
                );
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

  int findIndex(item) {
    List<Map<String, dynamic>> tempData = _user.getAll();
    int ans = 0;
    for (int i = 0; i < tempData.length; i++) {
      if (tempData[i][Name] == item[Name] && tempData[i][Email] == item[Email]) {
        ans = i;
        break;
      }
    }
    return ans;
  }

  String getHobbies(){
    String hobbies = "";
    for(var i in widget.userDetail[Hobbies].keys) {
      if (widget.userDetail[Hobbies][i] == true) {
        hobbies += i + " , ";
      }
    }
    hobbies = hobbies.substring(0,hobbies.length-2);
    return hobbies;
  }
}
