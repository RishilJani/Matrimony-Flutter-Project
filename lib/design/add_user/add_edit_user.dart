// Code to add user
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matrimony_application/backend/user.dart';
import 'package:intl/intl.dart';
import '../../utils/string_constants.dart';

// ignore: must_be_immutable
class UserForm extends StatefulWidget {
  UserForm({super.key, this.userDetail, this.ind});
  int? ind = -1;
  Map<String, dynamic>? userDetail = {};
  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final User _user = User();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  List<String> cities = ['Jamnagar', 'Rajkot', 'Ahmedabad', 'Baroda','Dwarka'];
  String selectCity = '';
  bool isEdit = false;

  DateTime date = DateTime.now();
  DateTime? pikedDate = DateTime.now();
  String dob = 'Select DOB';

  Map<String, bool> hobbies = {};

  bool isPassword = false;
  bool isCPassword = false;

  String gender = 'Female';

  @override
  void initState() {
    super.initState();
    if (widget.userDetail != null) {
      isEdit = true;
      nameController.text = widget.userDetail![Name].toString();
      emailController.text = widget.userDetail![Email].toString();
      mobileController.text = widget.userDetail![Mobile].toString();
      passwordController.text = widget.userDetail![Password].toString();
      confirmPasswordController.text = widget.userDetail![Password].toString();
      hobbies.addAll(widget.userDetail![Hobbies]);
      gender = widget.userDetail![Gender];
      selectCity = widget.userDetail![City];
      dob = widget.userDetail![DOB];
    } else {
      selectCity = cities[0];
      hobbies = {"Reading": false, "Music": false, "Dance": false};
      dob = DateFormat("dd/MM/yyyy").format(DateTime(date.year - 20));
      pikedDate = DateTime(date.year - 20);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text(
          isEdit ? 'Edit Details' : "Register User",
          style: const TextStyle(fontWeight: FontWeight.bold),
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
                  suffix: Icon(Icons.person),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter your name';
                    }
                    if (value.length < 3 || value.length > 50) {
                      return 'Enter valid full name';
                    }
                    if (!RegExp(r"[a-zA-Z\s']{3,50}").hasMatch(value)) {
                      return 'Enter valid name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20,),
                // endregion Name

                // For email
                // region Email
                getInput(emailController, 'Email Address',
                    keyboard: TextInputType.emailAddress, 
                    validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter your Email Address';
                  }
                  if (!RegExp(
                          r"^[a-zA-Z0-9._%+]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                      .hasMatch(value!)) {
                    return "Enter a valid email address";
                  }
                  if (widget.userDetail == null && !_user.isUnique(0, value)) {
                    return 'Enter Unique email';
                  }
                  return null;
                },
                    suffix: Icon(Icons.email)
                ),
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
                    keyboard: TextInputType.phone, 
                    validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter your mobile number";
                  }
                  if (value!.length != 10) {
                    return 'Enter 10-digit mobile';
                  }
                  if (!RegExp(r"^\+?[0-9]{10,15}$").hasMatch(value!)) {
                    return 'Enter a valid 10-digit mobile number';
                  }
                  if (widget.userDetail == null && !_user.isUnique(1, value)) {
                    return 'Enter Unique Phone number';
                  }
                  return null;
                },
                    suffix: Icon(Icons.phone)
                ),
                const SizedBox(
                  height: 20,
                ),
                // endregion Mobile

                // Hobbies Check boxes
                // region Hobbies
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 150, child: Text('Hobbies : ',style: TextStyle(fontSize: 15),)),
                    const SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var i in hobbies.keys)
                          InkWell(
                            onTap: () {
                              changeHobbies(i, !hobbies[i]!);
                            },
                            child: Row(
                              children: [
                                Checkbox(
                                  value: hobbies[i],
                                  onChanged: (value) => changeHobbies(i, value),
                                ),
                                Text(i)
                              ],
                            ),
                          )
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                // endregion Hobbies

                // Gender Radio buttons
                // region Gender
                Row(
                  children: [
                    const SizedBox(width: 150, child: Text('Gender : ',style: TextStyle(fontSize: 15),)),
                    const SizedBox(
                      width: 8,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          gender = 'Male';
                        });
                      },
                      child: Row(
                        children: [
                          Radio(
                            value: 'Male',
                            groupValue: gender,
                            onChanged: (String? value) {
                              setState(() {
                                gender = value!;
                              });
                            },
                          ),
                          const Text('Male'),
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
                            value: 'Female',
                            groupValue: gender,
                            onChanged: (String? value) {
                              setState(() {
                                gender = value!;
                              });
                            },
                          ),
                          const Text('Female'),
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
                    const SizedBox(width: 150, child: Text('DOB : ',style: TextStyle(fontSize: 15),)),
                    const SizedBox(
                      width: 8,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 1.0, style: BorderStyle.solid),
                          borderRadius: const BorderRadius.horizontal(
                              right: Radius.circular(10),
                              left: Radius.circular(10))),
                      child: TextButton(
                          onPressed: () async {
                            pikedDate = await showDatePicker(
                              context: context,
                              initialEntryMode: DatePickerEntryMode.calendar,
                              initialDate: DateTime(date.year - 20),
                              firstDate: DateTime(date.year - 80),
                              lastDate: DateTime(date.year - 18),
                              helpText: "Date of Birth",
                            ) ?? DateTime(date.year - 20,1,1);

                            dob = DateFormat("dd/MM/yyyy").format(pikedDate!);
                            setState(() {});
                          },
                          child: Text(
                            dob,
                            style: const TextStyle(color: Colors.black),
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
                    const SizedBox(width: 150, child: Text('City : ',style: TextStyle(fontSize: 15),)),
                    const SizedBox(
                      width: 8,
                    ),
                    DropdownButton(
                      menuWidth: 200,
                      icon: const Icon(Icons.location_city),
                        value: selectCity,
                        items: cities.map((city) {
                          return DropdownMenuItem(
                            value: city,
                            child: Text(city.toString()),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectCity = value!;
                          });
                        })
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                // endregion City

                // Password
                // region Password
                getInput(passwordController, 'Password',
                    isObs: true,
                    validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter your password";
                  }
                  return null;
                },
                  isPasswordVisible: isPassword,
                  onToggle:  (){ setState(() { isPassword = !isPassword; });}
                ),
                const SizedBox(
                  height: 20,
                ),
                // endregion Password

                //Confirm Password
                // region CPassword
                getInput(confirmPasswordController, 'Confirm Password',
                    isObs: true, validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter your password to confirm";
                  }
                  if (passwordController.text != value) {
                    return "confirm password doesn't match";
                  }
                  return null;
                },
                  isPasswordVisible: isCPassword,
                  onToggle: ()=> setState(() { isCPassword = !isCPassword; })
                ),
                const SizedBox(
                  height: 20,
                ),
                // endregion CPassword

                // Submit Button
                // region Button
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Map<String, dynamic> mp = {
                          Name: nameController.text,
                          Email: emailController.text,
                          Mobile: mobileController.text,
                          Hobbies: hobbies,
                          City: selectCity,
                          Gender: gender,
                          DOB: dob,
                          Password: passwordController.text,
                          isFavourite: widget.userDetail == null
                              ? false
                              : widget.userDetail![isFavourite]
                        };
                        if (isEdit) {
                          _user.updateUser(widget.ind!, mp);
                          isEdit = false;
                        } else {
                          _user.addUser(mp);
                        }
                        Navigator.pop(context, mp);
                      }
                    },
                    child: Text(isEdit ? 'Edit User' : 'Submit'))
                // endregion Button
              ],
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
        onToggle
      }) {
    return Row(
      children: [
        SizedBox(
            width: 150,
            child:  Text(
                "$txt : ",
                style: TextStyle(fontSize: 15),
            )
        ),
        const SizedBox( width: 8, ),
        Expanded(
          child: TextFormField(
            obscureText: (isObs ?? false) && (isPasswordVisible == false),
            autovalidateMode: AutovalidateMode.onUnfocus,
            validator: validator,
            controller: controller,
            keyboardType: keyboard,
            inputFormatters: formatters,
            decoration: InputDecoration(
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(10), left: Radius.circular(10))),
                labelText: 'Enter your $txt',
                hintText: 'Enter your $txt',
              suffixIcon: isObs != null ?
                  IconButton(
                      onPressed: onToggle,
                      icon: Icon(isPasswordVisible! ? Icons.visibility : Icons.visibility_off )) : suffix ),
        ),
        )
      ],
    );
  }

  void changeHobbies(String i, bool? value) {
    setState(() {
      hobbies[i] = value!;
    });
  }
}
