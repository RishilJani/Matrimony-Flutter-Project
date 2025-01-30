import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrimony_application/design/user_list/user_list_page.dart';
import 'package:matrimony_application/utils/string_constants.dart';

import '../../backend/user.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        title: Text(
            widget.userDetail[Name],
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              fontFamily: 'StyleScript'
          ),
        ),

        actions: [
          // Favourite
          IconButton(
              icon: Icon(widget.userDetail[isFavourite] ? Icons.favorite : Icons.favorite_border,color: Colors.pink,),
              onPressed: (){
                ind = findIndex(widget.userDetail);
                if(!widget.userDetail[isFavourite]){
                  _user.changeFavourite(ind);
                  setState(() { widget.userDetail = _user.getById(ind); });
                }else{
                  unFavourite(ind);
                }
              }
          ),

          // delete
          IconButton(
              icon: const Icon(Icons.delete,color: Colors.red,),
              onPressed: (){
                ind = findIndex(widget.userDetail);
                deleteDialog(ind);
              }
          ),

          // Edit
          IconButton(
            icon: const Icon(Icons.edit,color: Colors.blueGrey,),
            onPressed: (){
              Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context) {
                      ind = findIndex(widget.userDetail);
                      return UserForm(userDetail: widget.userDetail,ind : ind);
                    },
                  )
              ).then((value)=> setState(() {
                if(value != null){
                  widget.userDetail = value;
                }
              }));
            },
          ),

          const SizedBox(width: 8,)
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text("About",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
              const SizedBox( height: 10,),

              userItem(Name),
              const SizedBox( height: 8,),

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

  Widget userItem(txt){
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text("$txt "),
        ),
        const Expanded(
            flex: 1,
            child: Text(":")
        ),
        Expanded(
            flex: 3,
            child: Text(widget.userDetail[txt].toString(),style: const TextStyle(fontWeight: FontWeight.w600),)
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
