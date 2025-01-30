import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrimony_application/design/user_list/user_details.dart';
import 'package:matrimony_application/utils/string_constants.dart';

import '../../backend/user.dart';
import '../add_user/add_edit_user.dart';

//ignore: must_be_immutable
class UserListPage extends StatefulWidget {
  UserListPage({super.key,required this.isFav});
  bool isFav = false;

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final User _user = User();
  List<Map<String, dynamic>> data = [];
  TextEditingController searchController = TextEditingController();

  bool isAllFavourite = false;

  @override
  void initState() {
    super.initState();
    getData();
    isAllFavourite = changeAllFavourite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: widget.isFav ? Colors.pinkAccent : Colors.blueAccent,
        title: Text( widget.isFav ? "Favourite Users" : "User List" ,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [

          // region AllFavourite
          IconButton(
            tooltip: isAllFavourite ? "Remove all from favourite" : "Add All to favourite",
              onPressed: data.isEmpty ? null : (){
                unFavourite(0,isAllFavourite);
              },
              icon: Icon(isAllFavourite ? Icons.favorite : Icons.favorite_border_rounded,color: Colors.pink),
          ),
          // endregion AllFavourite

          // region DeleteAll
          IconButton(
              onPressed: data.isEmpty ? null : (){
                deleteDialog(0,true);
              },
              icon: const Icon(Icons.delete,color: Colors.red,),
          )
          // endregion DeleteALl
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          mainAxisSize : MainAxisSize.max,
          children: [

            // Search Bar
            Row(
              children: [
                Expanded(
                    child: TextFormField(
                      onChanged: (value){
                        if(value == ''){
                         setState(() { getData(); });
                        }
                        else{
                          setState(() { getData(value); });
                        }
                        // search code here
                      },
                      controller: searchController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(10),
                            left: Radius.circular(10),
                          )
                        ),
                        labelText: 'Search user',
                        hintText: 'Search user',
                      ),
                    ),
                )
              ],
            ),

            const SizedBox( height: 15 ,),

            data.isEmpty ? const Center(child:  Text("No user found"),)
                : Expanded(
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return getListItem(index);
                    },
                )
            )
          ],
        ),
      ),
    );
  }


  Widget getListItem(i){
    int ind = 0;
    return Card(
      elevation: 10,
      child: ListTile(
        onTap: (){
          Navigator.push(context,MaterialPageRoute(
              builder: (context) {
                return UserDetailsPage(userDetail : data[i]);
              },
          )
          ).then((value){
            setState(() {
              getData();
            });
          });
        },
        title: Wrap(
          direction: Axis.vertical,
          children: [
            // Name
            Text( data[i][Name] ,style:  const TextStyle(fontSize: 22), ),

            // Email
            Text( data[i][Email] ,style:  const TextStyle(fontSize: 17), ),

            // Mobile
            Text( data[i][Mobile] ,style:  const TextStyle(fontSize: 17), ),

            // City
            Text( data[i][City].toString() ,style:  const TextStyle(fontSize: 17), ),

            // Age
            Text("Age : ${data[i][Age].toString()}" ,style:  const TextStyle(fontSize: 17), ),
          ],
        ),
        trailing: Wrap(
          direction: Axis.vertical,
          children: [
            // Favourite
            IconButton(
                icon: Icon(data[i][isFavourite] ? Icons.favorite : Icons.favorite_border,color: Colors.pink,),
                onPressed: (){
                  ind = findIndex(data[i]);
                  if(!data[i][isFavourite]){
                    _user.changeFavourite(ind);
                    setState(() {
                      isAllFavourite = changeAllFavourite();
                      getData();
                    });
                  }else{
                    ind = findIndex(data[i]);
                    unFavourite(ind);
                  }
                }
            ),

            // delete
            IconButton(
                icon: const Icon(Icons.delete,color: Colors.red,),
                onPressed: (){
                  ind = findIndex(data[i]);
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
                        ind = findIndex(data[i]);
                        return UserForm(userDetail: _user.getById(ind),ind : i);
                      },
                  )
                ).then((value)=> setState(() {}));
              },
            ),

          ],
        ),
      ),
    );
  }

  void getData([String? txt]){
    if(searchController.text == ''){
      if(widget.isFav){
        data = _user.getFavourite();
      }else{
        data = _user.getAll();
      }
      // changeAllFavourite();
    }else{
      if(widget.isFav){
        data = _user.searchFavouriteUser(searchController.text);
      }else{
        data = _user.searchUser(searchController.text);
      }

    }
  }

  void unFavourite(int i,[bool? isAll]){
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text( isAll == null ? "Unfavourite" :
                isAllFavourite ? "Unfavourite" :"Favourite"
            ),
            content: Text( isAll == null ?
                "Are you sure want to remove ${_user.getById(i)[Name]} from favourite?"
            : isAllFavourite ? "Are you sure want to remove all from Favourite?":"Are you sure want to add all to Favourite?"),
            actions: [
              TextButton(
                  child: const Text("Yes"),
                  onPressed: (){
                    isAll == null ?  _user.changeFavourite(i) : _user.removeAllFavourite(!isAllFavourite);
                    setState(() {
                      isAllFavourite = changeAllFavourite();
                      getData();
                    });
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

  void deleteDialog(int i,[bool? isAll]){
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title:const Text('DELETE '),
          content: Text(
            isAll == null ?
              'Are you sure want to delete ${_user.getById(i)[Name]}? '
                : "Are you sure want to delete all users?"
          ),
          actions: [
            TextButton(
              child: const Text('yes'),
              onPressed: () {
                isAll == null ?  _user.deleteUser(i) : _user.deleteAllUsers();

                Navigator.pop(context);
                setState(() {
                  searchController.clear();
                  getData();
                });
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

  int findIndex(Map<String, dynamic> item) {
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

  bool changeAllFavourite(){
    for(var ele in data){
      if(!ele[isFavourite]){
        return false;
      }
    }

    return true;
  }
}
