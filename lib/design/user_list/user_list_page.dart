import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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


  bool isSelectionMode = false;

  Set<int> selectedUsers = {};

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
        flexibleSpace: appBarBG(),
        title: Text(
          widget.isFav ? "Favourite Users" : "User List",
          style: TextStyle(
              fontSize: 50,
              color: Colors.pink.shade300,
              fontWeight: FontWeight.bold,
              fontFamily: 'StyleScript'),
        ),
        centerTitle: true,
        actions: isSelectionMode
            ? [
                IconButton(
                  icon: Icon(
                    selectedUsers.length == data.length
                        ? Icons.check_box
                        : Icons.check_box_outline_blank_sharp,
                    color: Colors.pink.withOpacity(0.7),
                  ),
                  onPressed: selectAllItems,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: deleteSelectedItems,
                ),
                widget.isFav == true
                    ? IconButton(
                        onPressed: () {
                          unfavouriteSelectedItems();
                        },
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.pink,
                        ),
                      )
                    : Container()
              ]
            : null,
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
                      setState(() {
                        getData();
                      });
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
              const Center(
                  child: CircularProgressIndicator())
          ],
        ),
      ),
      floatingActionButton: sortItemsMenu(),
    );
  }

  Widget getListItem(i) {
    int ind = data[i][UserId];

    double borderRad = 23;
    bool isSelect = selectedUsers.contains(ind);
    Color listBgColor = const Color(0xFFDCE6FF);

    return ListTile(
      onLongPress: () => enterSelectionMode(ind),
      onTap: () {
        if (isSelectionMode) {
          toggleSelection(ind);
        } else {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return SwipeUserDetails(
                data: data,
                currentIndex: i,
              );
            },
          )).then(
            (value) {
              setState(() {
                getData();
              });
            },
          );
        }
      },
      contentPadding: EdgeInsets.zero,
      tileColor: isSelect ? Colors.blue.withOpacity(0.3) : null,
      leading: isSelectionMode
          ? Checkbox(
              activeColor: Colors.pink,
              value: isSelect,
              onChanged: (value) => toggleSelection(ind),
            )
          : null,
      title: Container(
        height: 110,
        decoration: BoxDecoration(
          color: listBgColor,
          borderRadius: BorderRadius.circular(borderRad),
        ),
        padding: const EdgeInsets.only(left: 7, right: 5),
        child: Row(children: [
          // region Image
          ClipOval(
            child: Image.asset(
              "assets/images/two_rings.jpg",
              height: 75,
              width: 75,
              fit: BoxFit.cover,
            ),
          ),
          // endregion Image

          const SizedBox(
            width: 10,
          ),

          // region Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // region Name
                Text(
                  data[i][Name],
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontFamily: RobotoFlex,
                    fontSize: 27,
                  ),
                ),
                // endregion Name

                Text(
                  data[i][AboutMe],
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                      color: Color.fromARGB(100, 23, 23, 23),
                      overflow: TextOverflow.ellipsis,
                      fontFamily: RobotoFlex),
                )

              ],
            ),
          ),
          // endregion Details

          // region Buttons
          Align(
            alignment: Alignment.topRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // region favourite
                Expanded(
                  child: IconButton(
                    icon: Icon(
                      data[i][isFavourite] == 1
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.pink,
                      size: 30,
                    ),
                    onPressed: () async {
                      if (data[i][isFavourite] == 0) {
                        _user.changeFavouriteDatabase(data[i][UserId], 1).then((value) {
                          setState(() {
                          getData();
                        });
                        },);
                      } else {
                        unFavouriteDialog(context: context, id: ind).then((value) {
                          setState(() {
                            getData();
                          });
                        },);

                      }
                    },
                  ),
                ),
                // endregion favourite

                // region delete
                Expanded(
                  child: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 25,
                    ),
                    onPressed: () async {

                      await deleteDialog(i: ind, context: context);
                      setState(() {
                        getData();
                      });
                    },
                  ),
                ),
                // endregion delete
              ],
            ),
          )
          // endregion Buttons
        ]),
      ),
    );
  }

  void getData({bool isRev = true}) async {
    if (searchController.text == '') {
      if (widget.isFav) {
        data = await _user.getFavouriteDatabase();
      } else {
        data = await _user.getAllDatabase();
      }
    } else {
      if (widget.isFav) {
        data = _user.searchFavouriteUser(searchController.text);
      } else {
        data = _user.searchUser(searchController.text);
      }
    }

    setState(() {
      data = isRev ? data.reversed.toList() : data.toList();
    });
  }

  // region sort
  Widget sortItemsMenu() {
    return SpeedDial(
      backgroundColor: bgColor,
      label: const Text("Sort By"),
      icon: Icons.sort,
      closeManually: false,
      children: [
        sortItems(text: "$Age reverse", icon: Icons.cake),
        sortItems(text: "$Name reverse", icon: Icons.sort_by_alpha_sharp),
        sortItems(text: Age, icon: Icons.cake),
        sortItems(text: Name, icon: Icons.sort_by_alpha_sharp),
        sortItems(text: "First Added", icon: Icons.date_range_sharp),
        sortItems(text: "Last Added", icon: Icons.date_range),
      ],
    );
  }

  SpeedDialChild sortItems({required String text, required IconData icon}) {
    return SpeedDialChild(
        onTap: () {
          if (text == "Last Added") {
            setState(() {
              getData();
            });
          } else if (text == "First Added") {
            setState(() {
              getData(isRev: false);
            });
          } else {
            sortUserListBy(text);
          }
        },
        label: text,
        labelStyle: const TextStyle(fontFamily: RobotoFlex),
        labelBackgroundColor: bgColor,
        backgroundColor: bgColor,
        child: Icon(icon));
  }

  void sortUserListBy(String text) {
    if (text == Name) {
      data.sort(
        (a, b) {
          return a[Name].compareTo(b[Name]);
        },
      );
    } else if (text == Age) {
      data.sort(
        (a, b) {
          int aAge = _user.ageCalculate(a);
          int bAge = _user.ageCalculate(b);
          return aAge - bAge;
        },
      );
    } else if (text == "$Name reverse") {
      data.sort(
        (a, b) {
          return b[Name].compareTo(a[Name]);
        },
      );
    } else if (text == "$Age reverse") {
      data.sort(
        (a, b) {
          int aAge = _user.ageCalculate(a);
          int bAge = _user.ageCalculate(b);
          return bAge - aAge;
        },
      );
    }

    setState(() {});
  }
  // endregion sort

  void toggleSelection(int ind) {
    setState(() {
      if (selectedUsers.contains(ind)) {
        selectedUsers.remove(ind);
      } else {
        selectedUsers.add(ind);
      }

      if (selectedUsers.isEmpty) {
        isSelectionMode = false;
      }
    });
  }

  void enterSelectionMode(int index) {
    setState(() {
      isSelectionMode = true;
      selectedUsers.add(index);
    });
  }

  void selectAllItems() {
    setState(() {
      if (selectedUsers.length == data.length) {
        // If all are selected, deselect all
        selectedUsers.clear();
        isSelectionMode = false;
      } else {
        // Otherwise, select all
        for (var ele in data) {
          selectedUsers.add(ele[UserId]);
        }
      }
    });
  }

  void deleteSelectedItems() async {
    await showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text(
            'DELETE ',
            style: TextStyle(fontFamily: RobotoFlex),
          ),
          content: const Text(
            'Are you sure want to delete ? ',
            style: TextStyle(fontFamily: RobotoFlex),
          ),
          actions: [
            TextButton(
              child: const Text(
                'Yes',
                style: TextStyle(fontFamily: RobotoFlex),
              ),
              onPressed: () async {
                await _user.deleteSomeUsersDatabase(selectedUsers);
                setState(() {
                  selectedUsers.clear();
                  isSelectionMode = false;
                  getData();
                  Navigator.pop(context);
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

  void unfavouriteSelectedItems() async {
    await showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text(
            'unfavourite',
            style: TextStyle(fontFamily: RobotoFlex),
          ),
          content: const Text(
            'Are you sure want to Unfavourite this users ? ',
            style: TextStyle(fontFamily: RobotoFlex),
          ),
          actions: [
            TextButton(
              child: const Text(
                'Yes',
                style: TextStyle(fontFamily: RobotoFlex),
              ),
              onPressed: () async {
                await _user
                    .changeSomeFavouriteDatabase(selectedUsers)
                    .then((value) {
                  setState(
                    () {
                      getData();
                      Navigator.pop(context);
                      isSelectionMode = false;
                      selectedUsers.clear();
                    },
                  );
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
