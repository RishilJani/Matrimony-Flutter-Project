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

  bool isAllFavourite = true;
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
        flexibleSpace: appBarGradient(),
        title: Text(
          widget.isFav ? "Favourite Users" : "User List",
          style: const TextStyle(
              fontSize: 40,
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
                    color: Colors.blueAccent.withOpacity(0.7),
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
                  child: Text(
                "User not found",
                style: TextStyle(fontSize: 20),
              ))
          ],
        ),
      ),
      floatingActionButton: sortItemsMenu(),
    );
  }

  Widget getListItem(i) {
    int ind = data[i][UserId];
    int age = _user.ageCalculate(data[i]);

    double borderRad = 23;
    bool isSelect = selectedUsers.contains(ind);
    Color borderColor = const Color(0xFFC2D8F8);

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
              value: isSelect,
              onChanged: (value) => toggleSelection(ind),

            )
          : null,

      title: Container(
        height: 120,
        decoration: BoxDecoration(
          color: borderColor,
          border: Border.all(color: borderColor, width: 0.5),
          borderRadius: BorderRadius.circular(borderRad),
        ),
        padding: const EdgeInsets.only(right: 15, top: 5, bottom: 5),
        child: Row(children: [
          // region Image
          ClipOval(
            child: Image.asset(
              "assets/images/two_rings.jpg",
              height: 100,
              width: 100,
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
              children: [
                // region Name
                Text(
                  data[i][Name],
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontFamily: RobotoFlex,
                    fontSize: 35,
                  ),
                ),
                // endregion Name

                // region City
                Text(
                  data[i][City].toString(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(fontFamily: RobotoFlex, fontSize: 23),
                ),
                // endregion City

                // region Age
                Text(
                  'age : ${age.toString()}',
                  maxLines: 1,
                  style: const TextStyle(fontFamily: RobotoFlex, fontSize: 21),
                ),
                // endregion Age

                // region Mobile
                // Text(
                //   data[i][Mobile],
                //   overflow: TextOverflow.ellipsis,
                //   maxLines: 1,
                //   style: const TextStyle(fontFamily: RobotoFlex, fontSize: 23),
                // ),
                // endregion Mobile
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
                    onPressed: () {
                      if (data[i][isFavourite] == 0) {
                        _user.changeFavouriteDatabase(data[i][UserId], 1);
                        setState(() {
                          getData();
                          isAllFavourite = changeAllFavourite();
                        });
                      } else {
                        unFavouriteDialog(context: context, id: ind)
                            .then((value) => setState(() {
                                  Navigator.pop(context);
                                  getData();
                            }));
                      }                    },
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
                    onPressed: () async{
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
      isAllFavourite = changeAllFavourite();
    } else {
      if (widget.isFav) {
        data = _user.searchFavouriteUser(searchController.text);
      } else {
        data = _user.searchUser(searchController.text);
      }
    }
    setState(() {
      if (isRev) {
        data = data.reversed.toList();
      } else {
        data = data.toList();
      }
    });
  }

  void unFavouriteAll() {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text(
            "Unfavourite",
            style: TextStyle(fontFamily: RobotoFlex),
          ),
          content: const Text(
            "Are you sure want to remove all from Favourite?",
            style: TextStyle(fontFamily: RobotoFlex),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _user.removeAllFavouriteDatabase();
                setState(() {
                  isAllFavourite = false;
                  getData();
                });

                Navigator.pop(context);
              },
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

  bool changeAllFavourite() {
    for (var ele in data) {
      if (ele[isFavourite] == 1) {
        return true;
      }
    }
    return false;
  }

  // region sort
  Widget sortItemsMenu() {

    return SpeedDial(
      label: const Text("Sort By"),
      icon: Icons.sort,
      closeManually: false,
      // backgroundColor: bgColour,
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
    Color bgColour = const Color.fromARGB(255, 242, 242, 242);
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
        labelBackgroundColor: bgColour,
        backgroundColor: bgColour,
        child: Icon(icon)
    );
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
