import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrimony_application/design/user_list/swipe_user_details.dart';
import 'package:matrimony_application/utils/string_constants.dart';

import '../../backend/user.dart';
import '../../utils/utils.dart';

//ignore: must_be_immutable
class UserListPage extends StatefulWidget {
  UserListPage({super.key, required this.isFav});
  bool isFav = false;

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final User _user = User();
  List<Map<String, dynamic>> data = [];
  TextEditingController searchController = TextEditingController();

  bool isAllFavourite = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: appBarGradient([
          const Color.fromARGB(255, 240, 47, 194),
          const Color.fromARGB(255, 96, 148, 234),
        ]),
        title: Text(
          widget.isFav ? "Favourite Users" : "User List",
          style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              fontFamily: 'StyleScript'),
        ),
        centerTitle: true,
        // actions: [
        //   // // region AllFavourite
        //   // IconButton(
        //   //   tooltip: isAllFavourite
        //   //       ? "Remove all from favourite"
        //   //       : "Add All to favourite",
        //   //   onPressed: data.isEmpty ? null  : () { unFavourite(0, isAllFavourite); },
        //   //   icon: Icon(
        //   //       isAllFavourite ? Icons.favorite : Icons.favorite_border_rounded,
        //   //       color: (data.isEmpty || !isAllFavourite )
        //   //           ? Colors.grey
        //   //           :  Colors.pink),
        //   // ),
        //   // // endregion AllFavourite
        //   //
        //   // // region DeleteAll
        //   // IconButton(
        //   //   onPressed: data.isEmpty
        //   //       ? null
        //   //       : () {
        //   //           deleteDialog(0, true);
        //   //         },
        //   //   icon: Icon(
        //   //     Icons.delete,
        //   //     color: data.isEmpty ? Colors.grey : Colors.red,
        //   //   ),
        //   // )
        //   // // endregion DeleteALl
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Search Bar
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    onChanged: (value) {
                      if (value == '') {
                        setState(() {
                          getData();
                        });
                      } else {
                        setState(() {
                          getData(value);
                        });
                      }
                      // search code here
                    },
                    controller: searchController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(10),
                        left: Radius.circular(10),
                      )),
                      labelText: 'Search user',
                      labelStyle:
                          TextStyle(fontSize: 30, fontFamily: 'GreatVibes'),
                      hintStyle:
                          TextStyle(fontSize: 30, fontFamily: 'GreatVibes'),
                    ),
                  ),
                ),
                Expanded(
                    child: Row(
                  children: [
                    // region AllFavourite
                    Expanded(
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        tooltip: isAllFavourite
                            ? "Remove all from favourite"
                            : "Add All to favourite",
                        onPressed: data.isEmpty || !isAllFavourite
                            ? null
                            : () {
                                unFavourite(0, isAllFavourite);
                              },
                        icon: Icon(
                            isAllFavourite
                                ? Icons.favorite
                                : Icons.favorite_border_rounded,
                            color: (data.isEmpty || !isAllFavourite)
                                ? Colors.grey
                                : Colors.pink),
                      ),
                    ),
                    // endregion AllFavourite

                    // region DeleteAll
                    Expanded(
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: data.isEmpty
                            ? null
                            : () {
                                deleteDialog(0, true);
                              },
                        icon: Icon(
                          Icons.delete,
                          color: data.isEmpty ? Colors.grey : Colors.red,
                        ),
                      ),
                    )
                    // endregion DeleteALl
                  ],
                )
                )
              ],
            ),

            const SizedBox(
              height: 15,
            ),

            if (data.isNotEmpty)
              Expanded(
                  child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return getListItem(index);
                },
              ))
            else
              const Center(child: Text("User not found",style: TextStyle(fontSize: 20),))
          ],
        ),
      ),
    );
  }

  Widget getListItem(i) {
    int ind = data[i][UserId];
    int age = _user.ageCalculate(data[i]);

    return ListTile(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return SwipeUserDetails(data: data,currentIndex: i,);
          },
        )).then(
          (value) {
            setState(() {
              getData();
            });
          },
        );
      },
      contentPadding: EdgeInsets.zero,
      title: Card(
        elevation: 15,
        child: Container(
          height: 150,
          // list tile  gradient
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color.fromARGB(255, 72, 219, 232),
              Color.fromARGB(255, 54, 97, 204),
            ],
          )),
          padding: const EdgeInsets.only(right: 15),
          child: Row(children: [
            // region Image
            Container(
              margin: const EdgeInsets.only(right: 4),
              width: 100,
              height: 151,
              child: Image.asset(
                "assets/images/Holding_Hands.jpg",
                fit: BoxFit.cover,
              ),
            ),
            // endregion Image

            // region Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // region Name
                  Text(
                    data[i][Name],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontFamily: RobotoFlex,
                      color: Colors.white,
                      fontSize: 28,
                    ),
                  ),
                  // endregion Name

                  // region Age
                  Text(
                    'age : ${age.toString()}',
                    maxLines: 1,
                    style:
                        const TextStyle(fontFamily: RobotoFlex, fontSize: 23),
                  ),
                  // endregion Age

                  // region Mobile
                  Text(
                    data[i][Mobile],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style:
                        const TextStyle(fontFamily: RobotoFlex, fontSize: 23),
                  ),
                  // endregion Mobile

                  // region City
                  Text(
                    data[i][City].toString(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style:
                        const TextStyle(fontFamily: RobotoFlex, fontSize: 23),
                  ),
                  // endregion City
                ],
              ),
            ),
            // endregion Details

            // region Buttons
            Align(
              alignment: Alignment.topRight,
              child: Flex(
                direction: Axis.vertical,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // region favourite
                  IconButton(
                    icon: Icon(
                      data[i][isFavourite] == 1
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.pink,
                    ),
                    onPressed: () {
                      if (data[i][isFavourite] == 0) {
                        _user.changeFavouriteDatabase(data[i][UserId], 1);
                        setState(() {
                          getData();
                          isAllFavourite = changeAllFavourite();
                        });
                      } else {
                        unFavourite(ind);
                      }
                    },
                  ),
                  // endregion favourite

                  // region delete
                  IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        deleteDialog(ind);
                      }),
                  // endregion delete

                  // region edit
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Color.fromARGB(255, 75, 190, 255),
                    ),
                    onPressed: () {},
                  ),
                  // endregion edit
                ],
              ),
            )
            // endregion Buttons
          ]),
        ),
      ),
    );
  }

  void getData([String? txt]) async {
    if (searchController.text == '') {
      if (widget.isFav) {
        data = await _user.getFavouriteDatabase();
      } else {
        data = await _user.getAllDatabase();
      }
      isAllFavourite = changeAllFavourite();
    } else {
      if (widget.isFav) {
        data = _user.searchFavouriteUser(searchController.text);
      } else {
        data = _user.searchUser(searchController.text);
      }
    }
    setState(() {
      data = data.reversed.toList();
    });
  }

  void unFavourite(int i, [bool? isAll]) async {
    Map<String, dynamic> tempUser = await _user.getByIdDatabase(i);
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(
              isAll == null
                  ? "Unfavourite"
                  : isAllFavourite
                      ? "Unfavourite"
                      : "Favourite",
              style: const TextStyle(fontFamily: RobotoFlex),
            ),
            content: Text(
              isAll == null
                  ? "Are you sure want to remove ${tempUser[Name]} favourite?"
                  : isAllFavourite
                      ? "Are you sure want to remove all from Favourite?"
                      : "Are you sure want to add all to Favourite?",
              style: const TextStyle(fontFamily: RobotoFlex),
            ),
            actions: [
              TextButton(
                onPressed: isAllFavourite
                    ? () {
                        isAll == null
                            ? _user.changeFavouriteDatabase(i, 0)
                            : _user.removeAllFavouriteDatabase();
                        setState(() {
                          isAllFavourite = false;
                          getData();
                        });
                        Navigator.pop(context);
                      }
                    : null,
                child: const Text(
                  "Yes",
                  style: TextStyle(fontFamily: RobotoFlex),
                ),
              ),
              TextButton(
                child: const Text(
                  "No",
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
  }

  void deleteDialog(int i, [bool? isAll]) async {
    Map<String, dynamic> tempUser = await _user.getByIdDatabase(i);
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text(
              'DELETE ',
              style: TextStyle(fontFamily: RobotoFlex),
            ),
            content: Text(
              isAll == null
                  ? 'Are you sure want to delete ${tempUser[Name]}? '
                  : "Are you sure want to delete all users?",
              style: const TextStyle(fontFamily: RobotoFlex),
            ),
            actions: [
              TextButton(
                child: const Text(
                  'Yes',
                  style: TextStyle(fontFamily: RobotoFlex),
                ),
                onPressed: () {
                  isAll == null
                      ? _user.deleteUserDatabase(tempUser[UserId])
                      : _user.deleteAllUsersDatabase();

                  Navigator.pop(context);
                  setState(() {
                    searchController.clear();
                    getData();
                  });
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
  }

  bool changeAllFavourite() {
    for (var ele in data) {
      if (ele[isFavourite] == 1) {
        return true;
      }
    }
    return false;
  }
}
