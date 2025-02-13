import 'package:flutter/material.dart';
import 'package:matrimony_application/design/dashboard/dashboard.dart';
import 'package:matrimony_application/utils/string_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginSignupPage extends StatefulWidget {
  const LoginSignupPage({super.key});

  @override
  State<LoginSignupPage> createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLogin = true;
  bool isRemember = false;
  bool obscurePassword = true;

  late SharedPreferences pref;
  @override
  void initState() {
    super.initState();
    getPreference();
  }
  Future<void> getPreference() async{
    pref = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isLogin ? 'Log in' : 'Sign Up',
                  style: const TextStyle(
                    fontFamily: RobotoFlex,
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                // region UserName
                TextFormField(
                  controller: nameController,
                  style: const TextStyle(fontFamily: RobotoFlex),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      labelText: 'Enter your user name',
                      prefixIcon: const Icon(Icons.person_outline)),
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
                // endregion UserName

                const SizedBox(
                  height: 15,
                ),

                // region Password
                TextFormField(
                  controller: passwordController,
                  autovalidateMode: AutovalidateMode.onUnfocus,
                  style: const TextStyle(fontFamily: RobotoFlex),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      labelText: 'Enter your password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                          onPressed: ()=> setState(() { obscurePassword = !obscurePassword;}),
                          icon: Icon( obscurePassword ? Icons.visibility_off : Icons.visibility)
                      )
                  ),
                  validator: passwordValidation,
                  obscureText: obscurePassword,
                ),
                // endregion Password

                const SizedBox(
                  height: 15,
                ),

                // region Checkbox
                InkWell(
                  onTap: () {
                    setState(() {
                      isRemember = !isRemember;
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Remember me ?"),
                      Checkbox(
                        value: isRemember,
                        onChanged: (value) {
                          setState(() {
                            isRemember = !isRemember;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                // endregion Checkbox

                const SizedBox(
                  height: 15,
                ),

                // region Submit
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              pref.setString(userName, nameController.text.toString());
                              pref.setString(userPassword, passwordController.text.toString());
                              pref.setBool(remember, isRemember);
                              var snack = SnackBar(
                                  content: Text(isLogin
                                      ? "Login Successfully"
                                      : "Sign up Successfully"));
                              ScaffoldMessenger.of(context).showSnackBar(snack);
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(
                                builder: (context) {
                                  return const Dashboard();
                                },
                              ));
                            }
                          },
                          child: Text(
                            isLogin ? 'Log in' : 'Sign Up',
                          )),
                    )
                  ],
                ),
                // endregion Submit

                const SizedBox(
                  height: 15,
                ),

                // region LoginSignup
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(isLogin
                        ? "Don't have an account?"
                        : 'Already Have an account?'),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          nameController.clear();
                          passwordController.clear();
                          isLogin = !isLogin;
                          isRemember = false;
                        });
                      },
                      child: Text(isLogin ? "Register here" : 'Log in'),
                    )
                  ],
                ),
                // endregion LoginSignup
              ],
            ),
          )),
    );
  }

  String? passwordValidation(String? value) {
    String? str = pref.getString(userPassword);
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
    if(isLogin && str == null){ return 'User not registered , Signup first'; }
    if(isLogin  && str != null && str != value){
      return 'password is wrong';
    }
    return null;
  }
}
