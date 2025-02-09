import 'package:matrimony_application/utils/string_constants.dart';

class User {
  static List<Map<String, dynamic>> userList = [
    {
      Name: "User1",
      Email: "abc@gmail.com",
      Mobile: "1234567890",
      Hobbies: {"Reading": false, "Music": true, "Dance": false},
      City: "Jamnagar",
      Gender: 'Male',
      DOB: '23/01/2007',
      Password: "secret",
      isFavourite: false,
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
      isFavourite: true,
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
      isFavourite: true,
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
      isFavourite: false,
      Age: 19
    },
    {
      Name: "def",
      Email: "myemail@gmail.com",
      Mobile: "9824201304",
      Hobbies: {"Reading": true, "Music": true, "Dance": true},
      City: "Baroda",
      Gender: 'Male',
      DOB: '23/07/2002',
      Password: "Super@Secret9",
      isFavourite: true,
      Age: 23
    },
    {
      Name: "ghi",
      Email: "myemail@gmail.com",
      Mobile: "9824201305",
      Hobbies: {"Reading": true, "Music": true, "Dance": true},
      City: "Baroda",
      Gender: 'Male',
      DOB: '23/07/2006',
      Password: "Super@Secret9",
      isFavourite: false,
      Age: 19
    },
    {
      Name: "jkl",
      Email: "myemail@gmail.com",
      Mobile: "9824201306",
      Hobbies: {"Reading": true, "Music": true, "Dance": true},
      City: "Baroda",
      Gender: 'Male',
      DOB: '23/07/1999',
      Password: "Super@Secret9",
      isFavourite: true,
      Age: 26
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
      isFavourite: false,
      Age: 21
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
      isFavourite: false,
      Age: 4
    },
    {
      Name: "stu",
      Email: "myemail@gmail.com",
      Mobile: "9824201309",
      Hobbies: {"Reading": true, "Music": true, "Dance": true},
      City: "Baroda",
      Gender: 'Male',
      DOB: '23/07/2006',
      Password: "Super@Secret9",
      isFavourite: true,
      Age: 19
    },
    {
      Name: "vwx",
      Email: "myemail@gmail.com",
      Mobile: "9824201310",
      Hobbies: {"Reading": true, "Music": true, "Dance": true},
      City: "Baroda",
      Gender: 'Male',
      DOB: '23/07/2006',
      Password: "Super@Secret9",
      isFavourite: false,
      Age: 19
    },
    {
      Name: "yzA",
      Email: "myemail@gmail.com",
      Mobile: "9824201311",
      Hobbies: {"Reading": true, "Music": true, "Dance": true},
      City: "Baroda",
      Gender: 'Male',
      DOB: '23/07/2006',
      Password: "Super@Secret9",
      isFavourite: true,
      Age: 19
    },
  ];

  void addUser(Map<String, dynamic> mp) {
    mp[Age] = ageCalculate(mp);
    userList.add(mp);
  }

  List<Map<String, dynamic>> getAll() {
    return userList;
  }

  Map<String, dynamic> getById(i) {
    if (i < 0 || i >= userList.length) {
      return {};
    }
    return userList[i];
  }

  List<Map<String, dynamic>> getFavourite() {
    List<Map<String, dynamic>> temp = [];
    for (var ele in userList) {
      if (ele[isFavourite]) {
        temp.add(ele);
      }
    }
    return temp;
  }

  void updateUser(int id, Map<String, dynamic> mp) {
    mp[Age] = ageCalculate(mp);
    userList[id] = mp;
  }

  void deleteUser(id) {
    userList.removeAt(id);
  }

  void deleteAllUsers() {
    userList.clear();
  }

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

  void changeFavourite(i) {
    userList[i][isFavourite] = !userList[i][isFavourite];
  }

  void removeAllFavourite(bool value) {
    for (int i = 0; i < userList.length; i++) {
      userList[i][isFavourite] = value;
    }
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
      if (ele[isFavourite] &&
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
}
