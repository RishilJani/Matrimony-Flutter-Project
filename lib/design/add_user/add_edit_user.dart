import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matrimony_application/backend/user.dart';
import 'package:intl/intl.dart';
import '../../utils/string_constants.dart';
import '../../utils/utils.dart';

// ignore: must_be_immutable
class UserForm extends StatefulWidget {
  UserForm({super.key, this.userDetail});
  Map<String, dynamic>? userDetail = {};
  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  // region variables
  int ind = -1;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final User _user = User();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController aboutMeController = TextEditingController();

  List<String> cities = ['Jamnagar', 'Rajkot', 'Ahmedabad', 'Baroda', 'Dwarka'];
  List<String> professions = [
    'Business',
    'Teacher',
    'Professor',
    'Doctor',
    'Engineer',
    'CA'
  ];
  String selectCity = '';
  String selectProfession = '';
  bool isEdit = false;

  DateTime date = DateTime.now();
  DateTime? pikedDate = DateTime.now();
  String dob = 'Select DOB';

  Map<String, bool> hobbies = {};

  bool isPassword = false;
  bool isCPassword = false;

  String gender = 'Female';
  // endregion variables

  @override
  void initState() {
    super.initState();
    // _user.tempInsert();
    if (widget.userDetail != null) {
      isEdit = true;
      nameController.text = widget.userDetail![Name].toString();
      emailController.text = widget.userDetail![Email].toString();
      mobileController.text = widget.userDetail![Mobile].toString();
      passwordController.text = widget.userDetail![Password].toString();
      confirmPasswordController.text = widget.userDetail![Password].toString();
      aboutMeController.text = widget.userDetail![AboutMe] ?? "Available";
      hobbies.addAll(widget.userDetail![Hobbies]);
      gender = widget.userDetail![Gender];
      selectCity = widget.userDetail![City];
      dob = widget.userDetail![DOB];
      pikedDate = _user.strToDateTime(widget.userDetail![DOB]);

      selectProfession = widget.userDetail![Profession] ?? professions[0];
      ind = widget.userDetail![UserId];
    } else {
      selectCity = cities[0];
      selectProfession = professions[0];
      hobbies = {"Reading": false, "Music": false, "Dance": false};
      dob = DateFormat("dd/MM/yyyy").format(DateTime(date.year - 20));
      pikedDate = DateTime(date.year - 20, 1, 1);
      aboutMeController.text = "Available";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: appBarBG(),
          title: Text(
            isEdit ? 'Edit Details' : "Register User",
            style: TextStyle(
                fontSize: 50,
                color: Colors.pink.shade300,
                fontWeight: FontWeight.bold,
                fontFamily: 'StyleScript'),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  // For name
                  // region Name
                  getInput(
                    nameController,
                    'Name',
                    formatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'[0-9]')),
                    ],
                    keyboard: TextInputType.name,
                    suffix: Icons.person,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter your name';
                      }
                      if (value.length < 3 || value.length > 50) {
                        return 'Enter valid name within length between 3 and 50';
                      }
                      if (!RegExp(r"[a-zA-Z\s']{3,50}").hasMatch(value)) {
                        return 'Enter valid name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // endregion Name

                  // For email
                  // region Email
                  getInput(emailController, 'Email Address',
                      keyboard: TextInputType.emailAddress, validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter your Email Address';
                    }
                    if (!RegExp(
                            r"^[a-zA-Z0-9._%+]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                        .hasMatch(value!)) {
                      return "Enter a valid email address";
                    }
                    if (widget.userDetail == null &&
                        !_user.isUnique(0, value)) {
                      return 'Enter Unique email';
                    }
                    return null;
                  }, suffix: Icons.email),
                  const SizedBox(
                    height: 20,
                  ),
                  // endregion Email

                  // for Phone number
                  // region Mobile
                  getInput(mobileController, 'Phone Number',
                      formatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        LengthLimitingTextInputFormatter(10)
                      ],
                      keyboard: TextInputType.phone, validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter your mobile number";
                    }
                    if (value!.length != 10) {
                      return 'Enter 10-digit mobile';
                    }
                    if (!RegExp(r"^\+?[0-9]{10,15}$").hasMatch(value!)) {
                      return 'Enter a valid 10-digit mobile number';
                    }
                    if (widget.userDetail == null &&
                        !_user.isUnique(1, value)) {
                      return 'Enter Unique Phone number';
                    }
                    return null;
                  }, suffix: Icons.phone),
                  const SizedBox(
                    height: 20,
                  ),
                  // endregion Mobile

                  // Hobbies Check boxes
                  // region Hobbies
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [for (var i in hobbies.keys) getCheckbox(i)],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // endregion Hobbies

                  // Gender Radio buttons
                  // region Gender
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            gender = 'Male';
                          });
                        },
                        child: Row(
                          children: [
                            Radio(
                              activeColor: Colors.pink,
                              splashRadius: 60,
                              value: 'Male',
                              groupValue: gender,
                              onChanged: (String? value) {
                                setState(() {
                                  gender = value!;
                                });
                              },
                            ),
                            const Text(
                              'Male',
                              style: TextStyle(fontFamily: RobotoFlex),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            gender = 'Female';
                          });
                        },
                        child: Row(
                          children: [
                            Radio(
                              activeColor: Colors.pink,
                              splashRadius: 60,
                              value: 'Female',
                              groupValue: gender,
                              onChanged: (String? value) {
                                setState(() {
                                  gender = value!;
                                });
                              },
                            ),
                            const Text(
                              'Female',
                              style: TextStyle(fontFamily: RobotoFlex),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // endregion Gender

                  // DOB date picker
                  // region DOB
                  Row(
                    children: [
                      const SizedBox(
                          width: 150,
                          child: Text(
                            'DOB : ',
                            style:
                                TextStyle(fontFamily: RobotoFlex, fontSize: 15),
                          )),
                      const SizedBox(
                        width: 8,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1.0, style: BorderStyle.solid),
                            borderRadius: const BorderRadius.horizontal(
                                right: Radius.circular(10),
                                left: Radius.circular(10))),
                        child: TextButton(
                            onPressed: () async {
                              pikedDate = await showDatePicker(
                                    context: context,
                                    barrierDismissible: true,
                                    helpText: "Date of Birth",
                                    initialEntryMode:
                                        DatePickerEntryMode.calendar,
                                    initialDate: pikedDate,
                                    firstDate: DateTime(date.year - 80, 1, 1),
                                    lastDate: DateTime(date.year - 18, 1, 1),
                                  ) ??
                                  DateTime(date.year - 20, 1, 1);

                              dob = DateFormat("dd/MM/yyyy").format(pikedDate!);
                              setState(() {});
                            },
                            child: Text(
                              dob,
                              style: const TextStyle(
                                  fontFamily: RobotoFlex, color: Colors.black),
                            )),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // endregion DOB

                  // City dropdown
                  // region City
                  Row(
                    children: [
                      const SizedBox(
                          width: 150,
                          child: Text(
                            'City : ',
                            style:
                                TextStyle(fontFamily: RobotoFlex, fontSize: 15),
                          )),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: DropdownButton(
                            menuWidth: 200,
                            dropdownColor: bgColor,
                            value: selectCity,
                            items: cities.map((city) {
                              return DropdownMenuItem(
                                value: city,
                                child: Text(
                                  city.toString(),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectCity = value!;
                              });
                            }),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // endregion City

                  // Profession dropdown
                  // region Profession
                  Row(
                    children: [
                      const SizedBox(
                          width: 150,
                          child: Text(
                            '$Profession : ',
                            style:
                                TextStyle(fontFamily: RobotoFlex, fontSize: 15),
                          )),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: DropdownButton(
                            menuWidth: 200,
                            value: selectProfession,
                            onChanged: (value) {
                              setState(() {
                                selectProfession = value.toString();
                              });
                            },
                            items: professions.map((e) {
                              return DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    e.toString(),
                                  ));
                            }).toList()),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // endregion Profession

                  // About Me
                  // region AboutMe
                  getInput(aboutMeController, 'About',
                      suffix: Icons.info_outline_rounded,
                      keyboard: TextInputType.multiline),
                  const SizedBox(
                    height: 20,
                  ),
                  // endregion AboutMe

                  // Password
                  // region Password
                  getInput(passwordController, 'Password',
                      isObs: true,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "Enter your password";
                        }
                        if (value.length < 8) {
                          return 'Too short : Password must \ncontain at least 8 letters';
                        }
                        if (value.length > 16) {
                          return 'Too long : Password must \ncontain at most 16 letters';
                        }
                        if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
                          return "Password must contain \nat least one lower case letter";
                        }
                        if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
                          return "Password must contain \nat least one Upper case letter";
                        }
                        if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
                          return "Password must contain \nat least one digit";
                        }
                        if (!RegExp(r'(?=.*[@#$%^&+=*!])').hasMatch(value)) {
                          return "Password must contain \nat least one special character\n(@#\$%^&+=*!)";
                        }

                        return null;
                      },
                      isPasswordVisible: isPassword,
                      onToggle: () {
                        setState(() {
                          isPassword = !isPassword;
                        });
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  // endregion Password

                  //Confirm Password
                  // region CPassword
                  getInput(confirmPasswordController, 'Confirm Password',
                      isObs: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter your password to confirm";
                        }
                        if (passwordController.text != value) {
                          return "confirm password doesn't match";
                        }
                        return null;
                      },
                      isPasswordVisible: isCPassword,
                      onToggle: () => setState(() {
                            isCPassword = !isCPassword;
                          })),
                  const SizedBox(
                    height: 20,
                  ),
                  // endregion CPassword

                  // Submit Button

                  // region Button
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            style: ButtonStyle(
                                padding: WidgetStateProperty.all(
                                    const EdgeInsets.all(12)),
                                backgroundColor: WidgetStateProperty.all(
                                    Colors.pink.shade400)
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                Map<String, dynamic> mp = await sendData();
                                if (context.mounted) {
                                  Navigator.pop(context, mp);
                                }
                              }
                            },
                            child: Text(
                                isEdit ? 'Edit User' : 'Register',
                                style: const TextStyle(
                                  fontFamily: RobotoFlex,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                        ),
                      ),
                    ],
                  )
                  // endregion Button
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getInput(TextEditingController controller, String txt,
      {List<TextInputFormatter>? formatters,
      validator,
      suffix,
      TextInputType? keyboard,
      bool? isObs,
      bool? isPasswordVisible,
      onToggle}) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            textCapitalization: (controller == nameController)
                ? TextCapitalization.words
                : TextCapitalization.none,
            obscureText: (isObs ?? false) && (isPasswordVisible == false),
            autovalidateMode: AutovalidateMode.onUnfocus,
            validator: validator,
            controller: controller,
            keyboardType: keyboard,
            inputFormatters: formatters,
            maxLines: isObs == true ? 1 : null,
            style: const TextStyle(fontFamily: RobotoFlex),
            decoration: InputDecoration(
                labelText: 'Enter your $txt',
                suffixIcon: isObs != null
                    ? IconButton(
                        onPressed: onToggle,
                        icon: Icon(
                          isPasswordVisible!
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: const Color(0xFF0096FF),
                        ))
                    : Icon(
                        suffix,
                        color: const Color(0xFF0096FF),
                      )),
          ),
        )
      ],
    );
  }

  Widget getCheckbox(String i) {
    return InkWell(
      onTap: () {
        changeHobbies(i, !hobbies[i]!);
      },
      child: Row(
        children: [
          Checkbox(
            activeColor: Colors.pink,
            value: hobbies[i],
            onChanged: (value) => changeHobbies(i, value),
          ),
          Text(i)
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> sendData() async {
    Map<String, dynamic> mp = {
      Name: nameController.text.toString().trim(),
      Email: emailController.text,
      Mobile: mobileController.text,
      Hobbies: hobbies,
      City: selectCity,
      Profession: selectProfession,
      Gender: gender,
      DOB: dob,
      AboutMe: aboutMeController.text,
      Password: passwordController.text,
      isFavourite:
          widget.userDetail == null ? 0 : widget.userDetail![isFavourite]
    };

    if (isEdit) {
      await _user.updateUserDatabase(ind, mp);
      isEdit = false;
    } else {
      await _user.addUserDatabase(mp);
    }
    return mp;
  }

  void changeHobbies(String i, bool? value) {
    setState(() {
      hobbies[i] = value!;
    });
  }
}
