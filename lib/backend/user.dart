import 'dart:convert';
import 'package:matrimony_application/backend/my_database.dart';
import 'package:matrimony_application/utils/string_constants.dart';
import 'package:sqflite/sqflite.dart';

class User {
  static List<Map<String, dynamic>> userList = [];

  int ageCalculate(Map<String, dynamic> user) {
    DateTime current = DateTime.now();

    String str = user[DOB];
    DateTime dob = strToDateTime(str);

    int age = dob.year - current.year;
    if (dob.month < current.month ||
        (dob.month == current.month && dob.day < current.day)) {
      age--;
    }
    return age.abs();
  }

  DateTime strToDateTime(String str) {
    String dobYear = str.substring(str.length - 4);
    String dobMonth = str.substring(str.indexOf("/") + 1, str.lastIndexOf("/"));
    String dobDay = str.substring(0, str.indexOf('/'));

    DateTime ans =
        DateTime(int.parse(dobYear), int.parse(dobMonth), int.parse(dobDay));

    return ans;
  }

  bool isUnique(int i, String value) {
    if (i == 0) {
      for (var ele in userList) {
        if (ele[Email].toString().toLowerCase() ==
            value.toString().toLowerCase()) {
          return false;
        }
      }
    } else {
      for (var ele in userList) {
        if (ele[Mobile].toString().toLowerCase() ==
            value.toString().toLowerCase()) {
          return false;
        }
      }
    }
    return true;
  }

  List<Map<String, dynamic>> searchUser(String value) {
    List<Map<String, dynamic>> filterList = [];
    for (var ele in userList) {
      if (_isSame(ele[Name], value) ||
          _isSame(ele[City], value) ||
          _isSame(ele[Age], value) ||
          _isSame(ele[Email], value) ||
          _isSame(ele[Mobile], value)) {
        filterList.add(ele);
      }
    }
    return filterList;
  }

  List<Map<String, dynamic>> searchFavouriteUser(String value) {
    List<Map<String, dynamic>> filterList = [];
    for (var ele in userList) {
      if (ele[isFavourite] == 1 &&
          (_isSame(ele[Name], value) ||
              _isSame(ele[City], value) ||
              _isSame(ele[Age], value) ||
              _isSame(ele[Email], value) ||
              _isSame(ele[Mobile], value))) {
        filterList.add(ele);
      }
    }
    return filterList;
  }

  bool _isSame(element, value) {
    return (element.toString())
        .toLowerCase()
        .contains(value.toString().toLowerCase());
  }

  Future<void> addUserDatabase(Map<String, dynamic> mp) async {
    userList.add(mp);
    mp[Hobbies] = jsonEncode(mp[Hobbies]);
    Database db = await MyDatabase().initDatabase();
    int id = await db.insert(Table_User, mp);
    mp[UserId] = id;
  }

  Future<List<Map<String, dynamic>>> getAllDatabase() async {
    Database db = await MyDatabase().initDatabase();
    List<Map<String, dynamic>> temp = await db.query(Table_User);
    userList.clear();
    userList.addAll(temp);
    userList = _getHobbies(userList);
    return userList;
  }

  Future<Map<String, dynamic>> getByIdDatabase(int id) async {
    Database db = await MyDatabase().initDatabase();
    List<Map<String, dynamic>> data =
        await db.query(Table_User, where: '$UserId = ?', whereArgs: [id]);

    data = _getHobbies(data);
    if (data.isNotEmpty) {
      return data[0];
    } else {
      return {};
    }
  }

  Future<List<Map<String, dynamic>>> getFavouriteDatabase() async {
    Database db = await MyDatabase().initDatabase();

    List<Map<String, dynamic>> temp = [];
    temp.addAll(
        await db.query(Table_User, where: '$isFavourite = ?', whereArgs: [1]));
    
    temp = _getHobbies(temp);
    return temp;
  }

  Future<void> deleteUserDatabase(int id) async {
    Database db = await MyDatabase().initDatabase();
    userList.removeWhere(
      (element) {
        return element[UserId] == id;
      },
    );
    await db.delete(Table_User, where: '$UserId = ?', whereArgs: [id]);
  }

  Future<void> deleteAllUsersDatabase() async {
    Database db = await MyDatabase().initDatabase();
    userList.clear();
    await db.delete(Table_User);
  }

  Future<void> deleteSomeUsersDatabase(Set<int> ids) async{
    for(int i in ids){
      await deleteUserDatabase(i);
    }
  }

  // to favourite unfavourite users
  Future<void> changeFavouriteDatabase(int id, int value) async {
    Database db = await MyDatabase().initDatabase();
    await db.execute('''
      UPDATE $Table_User
      SET $isFavourite = ?
      WHERE $UserId = ?
      ''', [value, id]);
  }

  // to remove all favourite users
  Future<void> removeAllFavouriteDatabase() async {
    Database db = await MyDatabase().initDatabase();
    await db.execute('UPDATE $Table_User SET $isFavourite = ?', [0]);
  }

  // to change few favourite users
  Future<void> changeSomeFavouriteDatabase(Set<int> ids) async{
    for(int i in ids){
      changeFavouriteDatabase(i, 0);
    }
  }
  Future<void> updateUserDatabase(int id, Map<String, dynamic> mp) async {
    Database db = await MyDatabase().initDatabase();

    for (var element in userList) {
      if (element[UserId] == id) {
        element = mp;
      }
    }
    mp[Hobbies] = jsonEncode(mp[Hobbies]);
    await db.update(Table_User, mp, where: '$UserId = ?', whereArgs: [id]);
  }

  List<Map<String, dynamic>> _getHobbies(List<Map<String, dynamic>> temp) {
    List<Map<String, dynamic>> ans = temp.map(
      (e) {
        var modifiable = Map<String, dynamic>.from(e);
        modifiable[Hobbies] =
            Map<String, bool>.from(jsonDecode(modifiable[Hobbies]));
        return modifiable;
      },
    ).toList();
    return ans;
  }


  void tempInsert() async{
    // Database db = await MyDatabase().initDatabase();
    List<Map<String,dynamic>> ul = [
      {
      Name: "User1",
      Email: "abc@gmail.com",
      Mobile: "1234567890",
      Hobbies: {"Reading": false, "Music": true, "Dance": false},
      City: "Jamnagar",
      Gender: 'Male',
      DOB: '23/01/2007',
      Password: "secret",
      isFavourite: 0,
    },
      {
        Name: "User2",
        Email: "hello@gmail.com",
        Mobile: "9876543211",
        Hobbies: {"Reading": true, "Music": true, "Dance": false},
        City: "Rajkot",
        Gender: 'Female',
        DOB: '23/07/2005',
        Password: "Super@Secret9",
        isFavourite: 1,
      },
      {
        Name: "User3",
        Email: "myemail@gmail.com",
        Mobile: "9824201302",
        Hobbies: {"Reading": true, "Music": true, "Dance": true},
        City: "Baroda",
        Gender: 'Male',
        DOB: '23/07/2006',
        Password: "Super@Secret9",
        isFavourite: 1,
      },
      {
        Name: "User4",
        Email: "myemail@gmail.com",
        Mobile: "9824201303",
        Hobbies: {"Reading": true, "Music": true, "Dance": true},
        City: "Baroda",
        Gender: 'Male',
        DOB: '23/07/2006',
        Password: "Super@Secret9",
        isFavourite:0,
      },
      {
        Name: "mno",
        Email: "myemail@gmail.com",
        Mobile: "9824201307",
        Hobbies: {"Reading": true, "Music": true, "Dance": true},
        City: "Baroda",
        Gender: 'Male',
        DOB: '23/07/2004',
        Password: "Super@Secret9",
        isFavourite: 0,
      },
      {
        Name: "pqr",
        Email: "myemail@gmail.com",
        Mobile: "9824201308",
        Hobbies: {"Reading": true, "Music": true, "Dance": true},
        City: "Baroda",
        Gender: 'Male',
        DOB: '23/07/1980',
        Password: "Super@Secret9",
        isFavourite: 0,
      }
      ];

    for(var ele in ul){
      addUserDatabase(ele);
    }
  }
}

/*
    {
      Name: "User1",
      Email: "abc@gmail.com",
      Mobile: "1234567890",
      Hobbies: {"Reading": false, "Music": true, "Dance": false},
      City: "Jamnagar",
      Gender: 'Male',
      DOB: '23/01/2007',
      Password: "secret",
      isFavourite: 0,
      Age: 18
    },
    {
      Name: "User2",
      Email: "hello@gmail.com",
      Mobile: "9876543211",
      Hobbies: {"Reading": true, "Music": true, "Dance": false},
      City: "Rajkot",
      Gender: 'Female',
      DOB: '23/07/2005',
      Password: "Super@Secret9",
      isFavourite: 1,
      Age: 20
    },
    {
      Name: "User3",
      Email: "myemail@gmail.com",
      Mobile: "9824201302",
      Hobbies: {"Reading": true, "Music": true, "Dance": true},
      City: "Baroda",
      Gender: 'Male',
      DOB: '23/07/2006',
      Password: "Super@Secret9",
      isFavourite: 1,
      Age: 19
    },
    {
      Name: "User4",
      Email: "myemail@gmail.com",
      Mobile: "9824201303",
      Hobbies: {"Reading": true, "Music": true, "Dance": true},
      City: "Baroda",
      Gender: 'Male',
      DOB: '23/07/2006',
      Password: "Super@Secret9",
      isFavourite:0,
      Age: 19
    },
    {
      Name: "Mno",
      Email: "myemail@gmail.com",
      Mobile: "9824201307",
      Hobbies: {"Reading": true, "Music": true, "Dance": true},
      City: "Baroda",
      Gender: 'Male',
      DOB: '23/07/2004',
      Password: "Super@Secret9",
      isFavourite: 0,
      Age: 21
    },
    {
      Name: "Pqr",
      Email: "myemail@gmail.com",
      Mobile: "9824201308",
      Hobbies: {"Reading": true, "Music": true, "Dance": true},
      City: "Baroda",
      Gender: 'Male',
      DOB: '23/07/1980',
      Password: "Super@Secret9",
      isFavourite: 0,
      Age: 4
    },
    {
      Name: "Stu",
      Email: "myemail@gmail.com",
      Mobile: "9824201309",
      Hobbies: {"Reading": true, "Music": true, "Dance": true},
      City: "Baroda",
      Gender: 'Male',
      DOB: '23/07/2006',
      Password: "Super@Secret9",
      isFavourite: 1,
      Age: 19
    },
    {
      Name: "Vwx",
      Email: "myemail@gmail.com",
      Mobile: "9824201310",
      Hobbies: {"Reading": true, "Music": true, "Dance": true},
      City: "Baroda",
      Gender: 'Male',
      DOB: '23/07/2006',
      Password: "Super@Secret9",
      isFavourite: 0,
      Age: 19
    },
    {
      Name: "YzA",
      Email: "myemail@gmail.com",
      Mobile: "9824201311",
      Hobbies: {"Reading": true, "Music": true, "Dance": true},
      City: "Baroda",
      Gender: 'Male',
      DOB: '23/07/2006',
      Password: "Super@Secret9",
      isFavourite: 1,
      Age: 19
    },
 */
