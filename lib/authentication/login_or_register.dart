import 'package:demo/pages/login_page.dart';
import 'package:demo/pages/register_page.dart';
import 'package:flutter/material.dart';
class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  // intially show login page
  bool showLoginPage = true;

  //toggle between two pages
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage){
      return LoginPage(onTap: togglePages);
    }
    else{
      return RegisterPage(onTap: togglePages);
    }
  }
}
